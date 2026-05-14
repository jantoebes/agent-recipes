---
description: Remove all merged worktrees in the current directory
---

Look at all subdirectories in the current working directory. For each directory that has a `.git` file (not a folder) — meaning it's a worktree — check via the GitHub CLI (`gh pr list --repo <repo> --head <branch> --state merged`) whether the branch has a merged PR. Collect all worktrees with a merged PR.

Then remove each merged worktree using `git worktree remove --force <path>` on the main repo (derive the main repo path from the `.git` file contents: `gitdir: <path>/.git/worktrees/<name>` → strip `/.git/worktrees/<name>`).

After cleanup, report which worktrees were removed and which ones were kept (not merged).
