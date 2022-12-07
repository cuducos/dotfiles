import os
import platform
import venv
from itertools import chain
from pathlib import Path
from tempfile import NamedTemporaryFile
from urllib.request import urlretrieve


DOTFILES_DIR = Path.cwd()
DOTFILES_GIT = DOTFILES_DIR / ".git"
HOME_DIR = Path.home()

CONFIG_FILES = (DOTFILES_DIR / f for f in ("fdignore", "gitconfig", "gitignore_global"))

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


def create_nvim_virtualenv():
    if NEOVIM_VENV.exists():
        return

    venv.create(NEOVIM_VENV, with_pip=True)
    os.system(f"{NEOVIM_PYTHON} -m pip install --upgrade pip")
    os.system(f"{NEOVIM_PYTHON} -m pip install black neovim")


def prepare_spin_instance():
    if not os.getenv("SPIN"):
        return

    os.system("sudo apt install -y fd-find rust-bat unzip")

    # delta is not an apt
    version = "0.14.0"
    deb = f"git-delta_{version}_{platform.machine()}.deb"
    url = f"https://github.com/dandavison/delta/releases/download/{version}/{deb}"
    with NamedTemporaryFile(suffix=".deb") as path:
        urlretrieve(url, filename=path.name)
        os.system(f"sudo dpkg -i {path}")


def configure_kitty():
    def which(bin):
        for directory in os.environ["PATH"].split(os.pathsep):
            path = Path(directory) / bin
            if not path.exists() or not path.is_file():
                continue
            return path

    fish = which("fish")
    if IS_MAC:
        fish = f"{fish} --login --interactive"

    fonts = "\n".join(f"{k}\t{v}" for k, v in FONTS.items())
    (KITTY_CONF / "fonts.conf").write_text(fonts)
    (KITTY_CONF / "shell.conf").write_text(f"shell\t{fish}")


def install_catppuccin_for_kitty():
    path = KITTY_CONF / "catppuccin-latte.conf"
    if path.exists():
        return

    url = "https://raw.githubusercontent.com/catppuccin/kitty/main/latte.conf"
    urlretrieve(str(url), filename=path)


def configure_nvim():
    commands = (
        ("packadd packer.nvim", "quitall"),
        ("autocmd User PackerComplete quitall", "PackerSync"),
        ("UpdateRemotePlugins", "quitall"),
    )
    for cmd1, cmd2 in commands:
        os.system(f"nvim --headless -c '{cmd1}' -c '{cmd2}'")


if __name__ == "__main__":
    create_all_dirs()
    create_all_symlinks()
    create_nvim_virtualenv()
    prepare_spin_instance()
    configure_kitty()
    install_catppuccin_for_kitty()
    configure_nvim()
