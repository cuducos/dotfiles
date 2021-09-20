"""
Create symlinks in ~/.config pointing to the .config files in this repository.

Existing files in ~/.config are moved to /tmp (just in case).

The default behavior is to show which files are moved to /tmp and which
symlinks are created.
"""

from argparse import ArgumentParser
from pathlib import Path
from shutil import move


HOME = Path.home().absolute()
TMP = Path("/tmp").absolute()
GIT = Path(".git").absolute()
SKIP = set(Path(f).absolute() for f in ("LICENSE", "README.md", __file__))


def is_valid(path):
    path = path.absolute()
    return path.is_file() and path not in SKIP and not path.is_relative_to(GIT)


class Symlink:
    def __init__(self, relative_path, verbose=True):
        if not isinstance(relative_path, Path):
            relative_path = Path(relative_path)

        self.relative_path = relative_path
        self.verbose = verbose
        self.repo_path = self.relative_path.absolute()
        self.symlink_path = HOME / str(self.relative_path)
        self.backup_path = TMP / str(self.relative_path)

    def echo(self, *args, **kwargs):
        if not self.verbose:
            return
        print(*args, **kwargs)

    def should_backup(self):
        if not self.symlink_path.exists():
            return False

        if self.symlink_path.is_symlink():
            return False

        return self.symlink_path.is_file()

    def backup_if_needed(self):
        if not self.should_backup():
            return

        self.echo(f"Moving existing {self.symlink_path} to {self.backup_path}…")
        self.backup_path.parent.mkdir(parents=True, exist_ok=True)
        if self.backup_path.exists():
            self.backup_path.unlink()
        move(self.symlink_path, self.backup_path)

    def __call__(self):
        self.backup_if_needed()
        if self.symlink_path.exists():
            self.symlink_path.unlink()

        self.echo(f"Creating symlink for {self.repo_path} at {self.symlink_path}…")
        self.symlink_path.parent.mkdir(parents=True, exist_ok=True)
        self.symlink_path.symlink_to(self.repo_path)


def main():
    parser = ArgumentParser(description=__doc__)
    parser.add_argument(
        "-q", "--quiet", action="store_true", help="Does not show any output"
    )
    args = parser.parse_args()

    symlinks = (
        Symlink(path, verbose=not args.quiet)
        for path in Path().glob("**/*")
        if is_valid(path)
    )
    for symlink in symlinks:
        symlink()


if __name__ == "__main__":
    main()
