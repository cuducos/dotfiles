"""
Create symlinks in ~/.config pointing to the .config files in this repository.

Existing files in ~/.config are moved to /tmp (just in case).

The default behavior is to show which files are moved to /tmp and which
symlinks are created.
"""

from argparse import ArgumentParser
from dataclasses import dataclass
from pathlib import Path


HOME = Path.home().absolute()
TMP = Path("/tmp").absolute()


@dataclass
class Symlink:
    relative_path: Path
    verbose: bool = True

    def __post_init__(self):
        self.repo_path = self.relative_path.absolute()
        self.symlink_path = HOME / str(self.relative_path)
        self.backup_path = TMP / str(self.relative_path)

    def echo(self, *args, **kwargs):
        if not self.verbose:
            return
        print(*args, **kwargs)

    def should_backup(self):
        return self.symlink_path.exists() and self.symlink_path.is_file()

    def backup_if_needed(self):
        if not self.should_backup():
            return

        self.echo(f"Moving existing {self.symlink_path} to {self.backup_path}…")
        self.backup_path.parent.mkdir(parents=True, exist_ok=True)
        self.symlink_path.replace(self.backup_path)

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
        Symlink(p, verbose=not args.quiet)
        for p in Path(".config").glob("**/*")
        if p.is_file()
    )
    for symlink in symlinks:
        symlink()


if __name__ == "__main__":
    main()
