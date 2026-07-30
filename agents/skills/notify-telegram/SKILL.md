---
name: notify-telegram
description: Send Telegram notification when a long task or process completes. Supports fire-and-forget and bidirectional (wait for response) modes.
title: Notify Telegram
---

# Telegram Task Notification

Use this workflow at the end of long-running implementations or processes to notify the user via Telegram.

## Prerequisites

The file `~/.zapfy-telegram.env` must exist with:
```
TELEGRAM_BOT_TOKEN=<bot-token>
TELEGRAM_CHAT_ID=<chat-id>
SUPABASE_URL=<gptcode-project-url>
SUPABASE_KEY=<gptcode-service-role-key>
```

## Modes

### Fire-and-forget (default)
Send a notification only. User sees it but cannot respond via Telegram.

// turbo
```bash
/Users/jadercorrea/workspace/zapfy/ops/scripts/notify-telegram.sh \
  "✅ <Title>" "<Summary>" "<Next step>"
```

### Bidirectional (`--wait`)
Send notification with inline buttons (✅ Continuar / ⏭ Pular / ❌ Parar).
Script polls Supabase until the user clicks a button. Returns the response.

// turbo
```bash
/Users/jadercorrea/workspace/zapfy/ops/scripts/notify-telegram.sh --wait \
  "✅ <Title>" "<Summary>" "<Next step>"
```

**Run as background command** and use `command_status` with `WaitDurationSeconds=300` to wait:
- stdout outputs: `continue`, `skip`, `stop`, or `timeout`
- stderr shows status messages

## When to Use

- **`--wait`**: User may be away from computer (long implementations, multi-step refactors)
- **default**: Quick notifications where user is already in conversation

## Architecture

1. Script sends Telegram message (with or without inline buttons)
2. Script creates a `pending` signal in Supabase `agent_signals` table
3. User clicks a button → N8N callback handler updates Supabase
4. Script detects the update and returns the response
5. Signal row is auto-deleted after reading
