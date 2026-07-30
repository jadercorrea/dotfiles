---
name: services-access-prod
description: Access production services using credentials stored in macOS Keychain without exposing values in skills, logs, or prompts.
title: Services Access Prod
---

# Production service access

Production configuration is stored in macOS Keychain under the service
`dev.jadercorrea.agent-secrets.v2`. This skill must never contain credential
values.

The complete, value-free inventory is in `../../secrets.manifest`.

## Mandatory rules

1. Never print, paste, log, or return a secret value.
2. Never add a literal credential to a command, skill, environment file, Git
   diff, issue, chat, or prompt.
3. Check availability with `agent-secret has NAME`.
4. Inject only the required values into one child process:

   ```bash
   with-agent-secrets NAME_A NAME_B -- command arg1 arg2
   ```

5. Do not export the full inventory into an interactive shell.
6. `agent-secret get NAME` writes the value to stdout and is reserved for
   controlled shell composition. Do not invoke it as a visible agent action.

## Common operations

### N8N

List workflows:

```bash
with-agent-secrets N8N_API_KEY N8N_BASE_URL -- \
  sh -c 'curl --fail --silent --show-error \
    -H "X-N8N-API-KEY:$N8N_API_KEY" \
    "$N8N_BASE_URL/api/v1/workflows"'
```

Operational context:

- N8N Postgres credential: `xata-rag-ai`
- Support workflow: `WlMBJgccbY3Ir0Mv`
- Ops Telegram workflows: `YI5pBbbBMTVsS5eX`, `bICN3fxSrahuCqFD`
- Workflow JSON files: `workspace/zapfy/n8n/workflows/`
- Chat MCP base: `https://chat.zapfy.ai/api/mcp/tools`
- Chat MCP authentication requires `BFF_SERVICE_TOKEN` and
  `x-merchant-id`

### BFF merchant JWT

Run the token generator with `JWT_SECRET` scoped to the Node process:

```bash
with-agent-secrets JWT_SECRET -- \
  node -e 'const jwt = require("jsonwebtoken");
    console.log(jwt.sign(
      {merchantId: process.argv[1]},
      process.env.JWT_SECRET,
      {expiresIn: "1h"}
    ))' "<MERCHANT_ID>"
```

Do not paste the generated JWT into a committed file or assistant response.

### Chat Copilot API

Routes:

- `POST /api/shop/chat`
- `POST /api/fiscal/chat`
- `POST /api/storefront/chat`
- `POST /widget/chat`

Authentication uses the signed enterprise API key in the `x-api-key` header.
Inject `RAG_API_ENTERPRISE_API_KEY` only into the request process.

### Stripe webhook replay

Use a scoped subshell so the Stripe credentials disappear when the command
finishes:

```bash
with-agent-secrets \
  ZAPFY_STRIPE_SECRET_KEY \
  ZAPFY_STRIPE_WEBHOOK_SECRET \
  -- sh -c '
    payload=$(curl --fail --silent --show-error \
      -u "$ZAPFY_STRIPE_SECRET_KEY:" \
      "https://api.stripe.com/v1/events/$1")
    timestamp=$(date +%s)
    signature=$(printf "%s.%s" "$timestamp" "$payload" |
      openssl dgst -sha256 -hmac "$ZAPFY_STRIPE_WEBHOOK_SECRET" |
      awk "{print \\$NF}")
    curl --fail --silent --show-error \
      -X POST "https://api.zapfy.ai/webhooks/stripe" \
      -H "stripe-signature: t=$timestamp,v1=$signature" \
      -d "$payload"
  ' sh "<EVENT_ID>"
```

## Maintenance

- Add or update a value interactively with `agent-secret set NAME`.
- List documented names with `agent-secret list`.
- Run `scan-secrets --all` before committing changes to this skill.
