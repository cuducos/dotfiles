import os
import platform
import venv
from itertools import chain
from multiprocessing import Process, freeze_support
from pathlib import Path
from stat import S_IXGRP, S_IXOTH, S_IXUSR
from tempfile import NamedTemporaryFile
from urllib.request import urlopen


DOTFILES_DIR = Path.cwd()
DOTFILES_GIT = DOTFILES_DIR / ".git"
HOME_DIR = Path.home()

CONFIG_FILE_NAMES = (".fdignore", ".gitconfig", ".gitignore_global", ".ripgreprc")
CONFIG_FILES = (DOTFILES_DIR / f for f in CONFIG_FILE_NAMES)

NEOVIM_VENV = HOME_DIR / ".virtualenvs" / "neovim"
NEOVIM_PYTHON = NEOVIM_VENV / "bin" / "python"

KITTY_CONF = HOME_DIR / ".config" / "kitty"
CATPPUCCIN_THEMES = "https://raw.githubusercontent.com/catppuccin/kitty/main/themes/"

IS_MAC = platform.system().lower() == "darwin"
FONT_KEYS = ("font_family", "bold_font", "italic_font", "bold_italic_font")
MAC_FONTS = (
    "FiraCode Nerd Font Mono Retina",
    "FiraCode Nerd Font Mono Bold",
    "FiraCode Nerd Font Mono Light",
    "FiraCode Nerd Font Mono Medium",
)
LINUX_FONTS = {
    "Fira Code Retina Nerd Font Complete Mono",
    "Fira Code Bold Nerd Font Complete Mono",
    "Fira Code Light Nerd Font Complete Mono",
    "Fira Code SemiBold Nerd Font Complete Mono",
}
FONTS = dict(zip(FONT_KEYS, MAC_FONTS if IS_MAC else LINUX_FONTS))

APT_PKGS = ("fd-find", "bat", "unzip")
DEB_PKGS = (
    "https://github.com/dandavison/delta/releases/download/0.16.5/git-delta_0.16.5_amd64.deb",
    "https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb",
)
BIN_PKGS = (
    (
        "sd",
        "https://github.com/chmln/sd/releases/download/v0.7.6/sd-v0.7.6-x86_64-unknown-linux-gnu",
    ),
)


class ConcurrentRunner:
    def __init__(self):
        self.tasks = []

    def __enter__(self):
        return self

    def run(self, func, *args):
        task = Process(target=func, args=args)
        task.start()
        self.tasks.append(task)

    def __exit__(self, *_):
        for task in self.tasks:
            task.join()


def which(bin):
    for directory in os.environ["PATH"].split(os.pathsep):
        path = Path(directory) / bin
        if not path.exists() or not path.is_file():
            continue
        return path


def download_as(url, path):
    if not path.exists():
        path.touch()

    with urlopen(url) as resp:
        path.write_bytes(resp.read())


def create_all_dirs():
    for path in DOTFILES_DIR.glob("**/*"):
        if not path.is_dir() or DOTFILES_GIT in path.parents:
            continue

        target = HOME_DIR / path.relative_to(DOTFILES_DIR)
        target.mkdir(exist_ok=True)


def create_all_symlinks():
    for path in chain(CONFIG_FILES, (DOTFILES_DIR / ".config").glob("**/*")):
        if not path.is_file():
            continue

        target = HOME_DIR / path.relative_to(DOTFILES_DIR)
        if target.exists():
            continue

        target.symlink_to(path)


def install_bin(name, url):
    bin = HOME_DIR / "bin"
    if not bin.exists():
        bin.mkdir()

    path = bin / name
    download_as(url, path)
    path.chmod(path.stat().st_mode | S_IXUSR | S_IXGRP | S_IXOTH)


def install_deb(url):
    with NamedTemporaryFile(suffix=".deb") as tmp:
        download_as(url, tmp.name)
        cmd = f"dpkg -i {tmp.name}"
        if which("sudo"):
            cmd = f"sudo {cmd}"
        os.system(cmd)


def install_via_package_manager():
    apt = f"apt install -y {' '.join(APT_PKGS)}"
    if which("sudo"):
        apt = f"sudo {apt}"
    os.system(apt)

    for url in DEB_PKGS:
        install_deb(url)


def configure_spin():
    if not os.getenv("SPIN"):
        return

    with ConcurrentRunner() as runner:
        runner.run(install_via_package_manager)
        for name, url in BIN_PKGS:
            runner.run(install_bin, name, url)


def configure_kitty():
    fish = which("fish")
    if IS_MAC:
        fish = f"{fish} --login --interactive"

    fonts = "\n".join(f"{k}\t{v}" for k, v in FONTS.items())
    (KITTY_CONF / "fonts.conf").write_text(fonts)
    (KITTY_CONF / "shell.conf").write_text(f"shell\t{fish}")

    with ConcurrentRunner() as runner:
        for theme in ("latte", "frappe"):
            path = KITTY_CONF / f"catppuccin-{theme}.conf"
            if path.exists():
                continue

            url = f"{CATPPUCCIN_THEMES}{theme}.conf"
            runner.run(download_as, url, path)


def configure_nvim():
    if not NEOVIM_VENV.exists():
        venv.create(NEOVIM_VENV, with_pip=True)
        os.system(f"{NEOVIM_PYTHON} -m pip install --upgrade pip")
        os.system(f"{NEOVIM_PYTHON} -m pip install black neovim")

    os.system("nvim --headless '+Lazy! sync' +qa")
    os.system("nvim --headless -c 'silent UpdateRemotePlugins' -c 'quitall'")
    os.system(
        "nvim --headless -c 'autocmd User MasonUpgradeComplete sleep 100m | qall' -c 'MasonUpgrade'"
    )


if __name__ == "__main__":
    freeze_support()
    with ConcurrentRunner() as runner:
        runner.run(configure_spin)
        create_all_dirs()
        create_all_symlinks()
        runner.run(configure_kitty)
        runner.run(configure_nvim)
