#!/usr/bin/env python3
"""Parse claude.txt for cloneable GitHub repos; assign unique root folder names."""
from __future__ import annotations

import re
import sys
from pathlib import Path

REPO_URL = re.compile(
    r"https://github\.com/([A-Za-z0-9_.-]+)/([A-Za-z0-9_.-]+)(?:\.git)?/?(?:\s|$)",
)


def main() -> int:
    txt_path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("claude.txt")
    text = txt_path.read_text(encoding="utf-8", errors="replace")
    seen: dict[str, tuple[str, str]] = {}
    for m in REPO_URL.finditer(text):
        owner, repo = m.group(1), m.group(2)
        if owner in {"search", "orgs", "topics", "settings", "marketplace"}:
            continue
        url = f"https://github.com/{owner}/{repo}"
        # claude.txt lists gtanczyk/gstack; canonical repo is garrytan/gstack
        if owner == "gtanczyk" and repo == "gstack":
            url = "https://github.com/garrytan/gstack"
            owner, repo = "garrytan", "gstack"
        seen[url] = (owner, repo)

    # Resolve folder names: prefer repo basename; suffix with owner if duplicate repo name
    by_repo: dict[str, list[tuple[str, str, str]]] = {}
    for url, (owner, repo) in sorted(seen.items()):
        by_repo.setdefault(repo.lower(), []).append((url, owner, repo))

    rows: list[tuple[str, str, str, str]] = []
    for _key, group in sorted(by_repo.items(), key=lambda x: x[0]):
        if len(group) == 1:
            url, owner, repo = group[0]
            rows.append((repo, url, owner, repo))
        else:
            for url, owner, repo in group:
                folder = f"{repo}-{owner}".replace("/", "-")
                rows.append((folder, url, owner, repo))

    rows.sort(key=lambda r: r[0].lower())
    for folder, url, owner, repo in rows:
        print(f"{folder}\t{url}\t{owner}\t{repo}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
