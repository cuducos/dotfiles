from itertools import chain
from multiprocessing import Process, freeze_support
from pathlib import Path
from tempfile import NamedTemporaryFile, TemporaryDirectory
from urllib.request import urlretrieve
import os
import platform
import venv


DOTFILES_DIR = Path.cwd()
DOTFILES_GIT = DOTFILES_DIR / ".git"
HOME_DIR = Path.home()

CONFIG_FILE_NAMES = (".fdignore", ".gitconfig", ".gitignore_global", ".ripgreprc")
CONFIG_FILES = (DOTFILES_DIR / f for f in CONFIG_FILE_NAMES)

NEOVIM_VENV = HOME_DIR / ".virtualenvs" / "neovim"
NEOVIM_PYTHON = NEOVIM_VENV / "bin" / "python"

KITTY_CONF = HOME_DIR / ".config" / "kitty"
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
RUST_PKGS = (
    ("dandavison/delta", "0.16.5"),
    ("chmln/sd", "v0.7.6"),
)
APT_PKGS = ("fd-find", "bat", "unzip")


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


def install_from_git_with_cargo(repo, tag):
    with TemporaryDirectory() as path:
        os.system(f"git clone --branch {tag} https://github.com/{repo}.git {path}")
        os.system(f"{HOME_DIR / '.cargo' / 'bin' / 'cargo'} install --path {path}")


def install_rust():
    if which("cargo"):
        return

    with NamedTemporaryFile() as tmp:
        urlretrieve("https://sh.rustup.rs", filename=tmp.name)
        os.system(f"sh {tmp.name} -y")


def configure_spin():
    if not os.getenv("SPIN"):
        return

    with ConcurrentRunner() as runner:
        apt = f"apt install -y {' '.join(APT_PKGS)}"
        if which("sudo"):
            apt = f"sudo {apt}"

        runner.run(os.system, apt)
        install_rust()
        for repo, tag in RUST_PKGS:
            runner.run(install_from_git_with_cargo, repo, tag)


def configure_kitty():
    fish = which("fish")
    if IS_MAC:
        fish = f"{fish} --login --interactive"

    fonts = "\n".join(f"{k}\t{v}" for k, v in FONTS.items())
    (KITTY_CONF / "fonts.conf").write_text(fonts)
    (KITTY_CONF / "shell.conf").write_text(f"shell\t{fish}")


def configure_nvim():
    if not NEOVIM_VENV.exists():
        venv.create(NEOVIM_VENV, with_pip=True)
        os.system(f"{NEOVIM_PYTHON} -m pip install --upgrade pip")
        os.system(f"{NEOVIM_PYTHON} -m pip install black neovim")

    os.system("nvim --headless '+Lazy! sync' +qa")
    os.system("nvim --headless -c 'silent UpdateRemotePlugins' -c 'quitall'")


if __name__ == "__main__":
    freeze_support()
    with ConcurrentRunner() as runner:
        runner.run(configure_spin)
        create_all_dirs()
        create_all_symlinks()
        runner.run(configure_kitty)
        runner.run(configure_nvim)
