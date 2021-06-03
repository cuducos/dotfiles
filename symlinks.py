from pathlib import Path


TMP = Path("/tmp").absolute()
HOME = Path.home().absolute()


def backup(relative_path):
    source, target = HOME / relative_path, TMP / relative_path
    print(f"Moving existing {source.absolute()} to {target.absolute()}…")
    target.parent.mkdir(parents=True, exist_ok=True)
    source.replace(target)


def main():
    for path in Path(".config").glob("**/*"):
        if not path.is_file():
            continue

        symlink = HOME / path
        if symlink.exists():
            if symlink.is_file():
                backup(str(path))
            if symlink.is_symlink():
                symlink.unlink()

        print(f"Creating symlink for {path.absolute()} at {symlink.absolute()}…")
        symlink.parent.mkdir(parents=True, exist_ok=True)
        symlink.symlink_to(path.absolute())


if __name__ == "__main__":
    main()
