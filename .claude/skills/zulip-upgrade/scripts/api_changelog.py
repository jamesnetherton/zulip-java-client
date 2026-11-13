#!/usr/bin/env python3
"""Extract the Zulip API changelog for a release and map each change to client classes.

Usage:
    python3 -I api_changelog.py <version> [--repo <client-root>] [--changelog <file>] [--ref <git-ref>]

<version> is a major ("13") or point ("12.4") release. For a major, every
"Changes in Zulip <major>.x" section is included, so backported point-release
changes show up too.

For each /api/<slug> link in a change, the script lists the client source files
whose javadoc references https://zulip.com/api/<slug>, or marks it NOT IMPLEMENTED.
"""

import argparse
import re
import sys
import urllib.request
from pathlib import Path

CHANGELOG_URL = "https://raw.githubusercontent.com/zulip/zulip/{ref}/api_docs/changelog.md"
SECTION_RE = re.compile(r"^## Changes in Zulip (\d+)\.(\d+)\s*$")
FL_RE = re.compile(r"^\*\*Feature level (\d+)\*\*\s*$")
API_LINK_RE = re.compile(r"\]\(/api/([a-z0-9-]+)\)")
JAVADOC_LINK_RE = re.compile(r"zulip\.com/api/([a-z0-9-]+)")


def load_changelog(path, ref):
    if path:
        return Path(path).read_text(encoding="utf-8")
    url = CHANGELOG_URL.format(ref=ref)
    with urllib.request.urlopen(url, timeout=30) as resp:
        return resp.read().decode("utf-8")


def extract(text, major, minor):
    """Return [(section_title, [(feature_level, [bullet_text])])]."""
    sections = []
    current = None
    fl = None
    bullet = None
    for line in text.splitlines():
        m = SECTION_RE.match(line)
        if m or line.startswith("## ") or line.startswith("# "):
            if m and int(m.group(1)) == major and (minor is None or int(m.group(2)) == minor):
                current = (line[3:].strip(), [])
                sections.append(current)
            else:
                current = None
            fl = bullet = None
            continue
        if current is None:
            continue
        m = FL_RE.match(line)
        if m:
            fl = (int(m.group(1)), [])
            current[1].append(fl)
            bullet = None
            continue
        if fl is None:
            continue
        if line.startswith("* "):
            bullet = [line[2:].strip()]
            fl[1].append(bullet)
        elif line.strip() and bullet is not None:
            bullet.append(line.strip())
        elif line.strip() and bullet is None:
            bullet = [line.strip()]
            fl[1].append(bullet)
    return [(title, [(n, [" ".join(b) for b in bs]) for n, bs in fls]) for title, fls in sections]


def index_client(repo):
    src = Path(repo) / "src" / "main" / "java"
    index = {}
    for f in src.rglob("*.java"):
        for slug in set(JAVADOC_LINK_RE.findall(f.read_text(encoding="utf-8"))):
            index.setdefault(slug, []).append(f.stem)
    return {k: sorted(v) for k, v in index.items()}


def main():
    p = argparse.ArgumentParser()
    p.add_argument("version")
    p.add_argument("--repo", default=".")
    p.add_argument("--changelog", help="local changelog.md instead of downloading")
    p.add_argument("--ref", default="main", help="zulip/zulip git ref to fetch the changelog from")
    a = p.parse_args()

    parts = a.version.split(".")
    major = int(parts[0])
    # "13" or "13.0" means the whole major series; "12.4" means just that point release
    minor = int(parts[1]) if len(parts) > 1 and parts[1] != "0" else None

    sections = extract(load_changelog(a.changelog, a.ref), major, minor)
    if not sections:
        sys.exit(f"No 'Changes in Zulip {a.version}' section found")

    index = index_client(a.repo)
    for title, fls in sections:
        levels = [n for n, _ in fls]
        rng = f" (feature levels {min(levels)}-{max(levels)})" if levels else ""
        print(f"# {title}{rng}\n")
        for n, bullets in fls:
            print(f"## Feature level {n}\n")
            for b in bullets:
                print(f"- {b}")
                for slug in dict.fromkeys(API_LINK_RE.findall(b)):
                    classes = index.get(slug)
                    if not classes:
                        where = "NOT IMPLEMENTED"
                    elif len(classes) > 5:
                        where = ", ".join(classes[:5]) + f" (+{len(classes) - 5} more)"
                    else:
                        where = ", ".join(classes)
                    print(f"    - `{slug}` -> {where}")
            print()


if __name__ == "__main__":
    main()
