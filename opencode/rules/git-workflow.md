# Git & PR

- Commit messages: short, in English, descriptive; no conventional commits (no `feat:`, `fix:`)
- Branch name: `DCA-short-description`
- PR title: identical to branch name
- No PR description
- Never force push

# Branches & Worktrees

- At the start of a task (only when on main), ask the user: worktree, regular branch, or directly on main?
- Regular branch: `git checkout -b <branch>`
- Worktree: `wt switch --create <branch> --base <base>` — never use `git worktree` manually
- Navigate worktrees: `wt switch <branch>`
- To clean up worktrees: `/cleanup-worktrees`
