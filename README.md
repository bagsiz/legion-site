# Legion

Run several Claude Code sessions side by side in one terminal, each in its own git worktree and branch — with a shared task board, a commander session that splits big goals into tasks, inter-session messages and file locks, and diff/merge with conflict warnings.

Site: https://bagsiz.github.io/legion-site/

## Install (macOS, Linux)

```sh
curl -fsSL https://bagsiz.github.io/legion-site/install.sh | sh
```

or download a binary from [Releases](https://github.com/bagsiz/legion-site/releases) (checksums in `checksums.txt`).

Requires git ≥ 2.38 and [Claude Code](https://docs.claude.com/claude-code). Then, inside a git repository:

```sh
claude          # once: "Yes, I trust this folder"
legion init
legion          # Ctrl+\ then n starts a session; Ctrl+\ ? shows all keys
```

Non-US keyboard (e.g. Turkish)? `Ctrl+4` works as the prefix too. Run `legion keytest` to see which keys your terminal sends.

Update: run the install command again.

This repository hosts the website and release binaries. The source code is private.
