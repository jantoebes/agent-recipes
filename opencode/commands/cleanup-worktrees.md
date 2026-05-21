---
description: Remove all worktrees except main and branches with open PRs
---

1. Run `wt list --format json` to get all worktrees.
2. Run `gh pr list --state open --json headRefName --jq '.[].headRefName'` to get branches with open PRs.
3. Remove all worktrees except `main` and branches with an open PR using `wt remove --force --yes <branch>`.
4. For branches where `wt remove` reports "unmerged", also run `wt remove -D <branch>` to force-delete the local branch.
5. Report which worktrees were removed and which were kept (and why).
