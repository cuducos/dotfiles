import os
import platform
import venv
from itertools import chain
from pathlib import Path
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


def configure_kitty():
    fish = which("fish")
    if IS_MAC:
        fish = f"{fish} --login --interactive"

    fonts = "\n".join(f"{k}\t{v}" for k, v in FONTS.items())
    (KITTY_CONF / "fonts.conf").write_text(fonts)
    (KITTY_CONF / "shell.conf").write_text(f"shell\t{fish}")

    for theme in ("latte", "frappe"):
        path = KITTY_CONF / f"catppuccin-{theme}.conf"
        if path.exists():
            continue

        url = f"{CATPPUCCIN_THEMES}{theme}.conf"
        download_as(url, path)


def configure_nvim():
    if not NEOVIM_VENV.exists():
        venv.create(NEOVIM_VENV, with_pip=True)
        os.system(f"{NEOVIM_PYTHON} -m pip install --upgrade pip")
        os.system(f"{NEOVIM_PYTHON} -m pip install ruff ruff-lsp")

    os.system("nvim --headless '+Lazy! sync' +qa")
    os.system("nvim --headless -c 'silent UpdateRemotePlugins' -c 'quitall'")
    os.system(
        "nvim --headless -c 'autocmd User MasonUpgradeComplete sleep 100m | qall' -c 'MasonUpgrade'"
    )


if __name__ == "__main__":
    create_all_dirs()
    create_all_symlinks()
    configure_kitty()
    configure_nvim()
