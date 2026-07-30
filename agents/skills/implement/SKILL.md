---
name: implement
description: Full implementation cycle — TDD, code review, design review, Telegram notification, and next-step confirmation. Use for any feature, bugfix, or refactor.
title: Implement
---

# Implementation Workflow

Standard implementation cycle for all Zapfy work. Follow every step in order. Do not skip steps.

> **Useful Workflows:** If you need access to production data or services during implementation:
> - Run `/db-access-prod` for production database credentials and querying rules.
> - Run `/services-access-prod` for access info to third-party services (Stripe, Pagar.me, Woovi, etc.).

// turbo-all

## Phase 1 — Implement with TDD

1. Write a **failing test first** that captures the expected behavior.
2. Run the test suite to confirm it fails (Red).
3. Implement the minimum code to make the test pass (Green).
4. Refactor if needed, keeping tests green.
5. Run the **full lint and test suite** for the affected service:
   - Elixir: `mix format --check-formatted && mix credo && mix test`
   - Node/BFF: `npm run lint && npm test`
   - Python: `ruff check . && pytest`
   - Go: `go vet ./... && go test ./...`
6. Fix any lint or test failures before proceeding.

## Phase 2 — Code Review

7. Run the `/code-review` workflow against all changed files.
8. Fix **every issue** found, prioritizing by severity (security → logic → tests → style).
9. Re-run lints and tests after fixes.

## Phase 3 — Design Review (if UI was changed)

> Skip this phase if the change has no UI impact (backend-only, API, scripts, etc.)

10. Run the `/design-review` workflow against the affected screens/components.
11. Fix **every issue** found (hierarchy → DS compliance → accessibility → polish).
12. Re-run lints and tests after fixes.

## Phase 4 — Update Roadmap & Documentation

> **This step is mandatory.** Every completed implementation must be reflected in the roadmap.

13. Update the relevant `_roadmap.md` file to mark the completed item and add any new follow-ups discovered during implementation.
14. Update any affected docs in `/Users/jadercorrea/workspace/zapfy/docs` if the change impacts documented features, architecture, or processes.

## Phase 5 — Notify and Confirm Next Step

15. Determine the next step using this priority:
    1. **Current task list** (`task.md`) — if mid-implementation with pending items
    2. **Roadmap** (`_roadmap.md`) — for the next documented item in sequence
    3. **Docs** (`/Users/jadercorrea/workspace/zapfy/docs`) — for broader context on pending work

16. Send Telegram notification with buttons and **wait for user response**:
```bash
RESPONSE=$(/Users/jadercorrea/workspace/zapfy/ops/scripts/notify-telegram.sh --wait \
  "✅ <Title>" \
  "<Bullet summary of changes>" \
  "<Next planned step from priority list above>")
```

Run as a background command. Use `command_status` with `WaitDurationSeconds=300` to wait.

17. Read the response:
    - `continue` → proceed to the next step
    - `skip` → skip the proposed next step, ask user what to do instead
    - `stop` → stop work entirely
    - `timeout` → use `notify_user` to ask the user directly

> **Note:** The user can also respond here in the conversation at any time.
> Use `--wait` only for long-running sessions where the user may be away.
> For quick confirmations, just use `notify_user` directly.
