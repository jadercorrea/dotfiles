---
name: git-worktree-workflow
description: Isolate software implementation, bug fixes, refactors, and investigations that may change repository files in a dedicated Git worktree and branch. Use before editing code, tests, configuration, or repository documentation, and for safe post-merge base synchronization and worktree housekeeping.
---

# Git Worktree Workflow

Protect the repository's shared state while allowing concurrent work. Any implementation, correction, refactor, or investigation that may produce repository changes must use a dedicated worktree and a descriptive task branch. Pure read-only inspection may remain in the current checkout; load this workflow before the first edit.

## Terms

- **Primary directory:** the repository path the user or environment treats as the main checkout. Its active branch may differ from the base branch.
- **Base branch:** the default branch discovered from the remote, never assumed to be `main` or `master`.
- **Canonical base worktree:** the stable, explicit worktree where the local base branch is open. It must not use `/private/tmp` as its permanent location.
- **Task worktree:** the isolated worktree and branch owned by one demand or agent. It may use the workspace's established temporary-worktree convention.

## Required preflight

Before editing, inspect without changing branches or files:

```bash
git status --short --branch
git worktree list --porcelain
git remote -v
git fetch --prune origin
git symbolic-ref --quiet --short refs/remotes/origin/HEAD
```

Use the symbolic remote HEAD to derive the base branch. If `refs/remotes/origin/HEAD` is unavailable or ambiguous, inspect the remote's HEAD explicitly, for example with `git remote show origin` or `git ls-remote --symref origin HEAD`. Stop rather than guessing a branch name.

After discovering `<base>`, record and compare the local and remote references:

```bash
git rev-parse --verify <base>
git rev-parse --verify origin/<base>
git rev-list --left-right --count <base>...origin/<base>
git worktree list --porcelain
```

Locate the worktree that owns the local base branch and confirm that it is the stable canonical base worktree. If the local base branch does not exist, establish it from `origin/<base>` at an explicit stable location only after confirming that no worktree already owns that branch; never create the canonical base worktree under `/private/tmp`.

If the local base is only behind the remote, and its canonical worktree is clean and on `<base>`, advance it with `git merge --ff-only origin/<base>` and verify equality before creating the task worktree. If the local base is dirty, ahead, behind with local work, or divergent, preserve it and report the exact blocked synchronization state. Do not repair it with a divergent merge, rebase, reset, branch switch, or file replacement. New task work may still start from the freshly fetched `origin/<base>` without disturbing that state.

## Isolation invariants

- Never implement directly in the primary directory, canonical base worktree, or base branch.
- Create a descriptive branch and a dedicated task worktree for every demand. Start ordinary new work from the freshly fetched `origin/<base>` unless the user explicitly identifies another starting ref.
- Before creating or opening a branch, use `git worktree list --porcelain` to check whether it is already attached elsewhere. Git does not allow one branch to be open in multiple worktrees. If it is attached, use that worktree only when it belongs to the same demand and agent; otherwise coordinate with its owner or choose a new branch. Never force a checkout.
- Never switch branches, overwrite files, or reuse a worktree owned by another demand or agent.
- If the primary directory is on another branch or contains changes, preserve it exactly. Create the task branch and worktree without switching or cleaning the primary directory.
- Preserve all unrelated branches, worktrees, staged files, unstaged files, and untracked files. Stage only task-owned paths.
- Keep the canonical base worktree at a stable, explicit path. A temporary task worktree may follow the workspace convention, but `/private/tmp` is not a permanent home for the base branch.

A typical creation command, after validating the names and path, is:

```bash
git worktree add -b <task-branch> <task-worktree-path> origin/<base>
```

Run implementation, tests, review fixes, commit preparation, and delivery checks inside `<task-worktree-path>`.

## Integration and canonical base synchronization

Commit and push only within the task worktree and only with the authorization required by the active workflow. Integrate through the repository's official PR/MR, CI, and deployment process; do not substitute a local merge into the base branch.

After the remote merge:

1. Fetch and prune `origin` again.
2. Locate the worktree that owns the local base branch.
3. Confirm that worktree is on `<base>` and completely clean.
4. If it is dirty, on another branch, locally ahead, or divergent, stop and preserve it.
5. Advance it only with `git merge --ff-only origin/<base>`.
6. Verify that `git rev-parse <base>` and `git rev-parse origin/<base>` return the same commit.

Never use a divergent local merge, rebase, reset, branch switch, file overwrite, or worktree removal while changes are unpreserved.

## Safe housekeeping

Worktree and branch removal is explicit housekeeping, never automatic cleanup. Remove a completed task worktree only after confirming all of the following:

- `git status --short` is empty in that worktree;
- all intended changes are committed and pushed;
- the PR/MR is integrated through the official flow;
- the remote base contains the integrated result;
- no other agent or process is using the worktree.

Only then remove the exact task worktree path. Delete the task branch separately, with a non-forcing command, after confirming it is integrated. If any check is uncertain, leave both in place and report the pending housekeeping. Never use forced worktree removal or forced branch deletion to bypass safety checks.

## Required state report

Do not summarize the repository merely as “main/master is updated.” Report these separately:

1. active branch and status of the primary directory;
2. commit of the local base branch;
3. commit of `origin/<base>`;
4. path of the worktree where the base branch is open;
5. task branch and task worktree path;
6. whether the local and remote base commits are equal, and any blocked synchronization or housekeeping.

## Operational flow

1. Inspect the repository and all worktrees.
2. Update remote references.
3. Discover and validate the remote default base branch, then fast-forward the clean canonical base worktree when safe.
4. Create the demand's branch and dedicated worktree.
5. Implement, test, and review inside the task worktree.
6. Commit and push as authorized.
7. Integrate through the official PR/CI/CD flow.
8. Fast-forward the clean canonical base worktree.
9. Verify equality between the local base and `origin/<base>`.
10. Perform explicit, safe housekeeping for completed worktrees.
