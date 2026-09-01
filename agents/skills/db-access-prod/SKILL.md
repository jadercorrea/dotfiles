---
name: db-access-prod
description: Access production databases with credentials scoped from macOS Keychain
title: Db Access Prod
---

# Production database access

Never execute a write operation without the user's explicit authorization.
Never print, log, or paste a database password or connection URL.

## RAG API production

An existing tunnel is expected at `localhost:15432`.

- Database: `rag_api`
- User: `rag_api`
- Keychain name: `RAG_API_DB_PASSWORD`

```bash
with-agent-secrets RAG_API_DB_PASSWORD -- \
  sh -c 'PGPASSWORD="$RAG_API_DB_PASSWORD" exec psql \
    --host localhost --port 15432 --username rag_api --dbname rag_api'
```

## Remote production databases

The complete PostgreSQL connection URLs are stored in Keychain:

- RAG AI: `RAG_AI_DATABASE_URL`
- ML AI: `ML_AI_DATABASE_URL`
- Neon ML: `NEON_ML_DATABASE_URL`

Connect with only the required URL in the child process:

```bash
with-agent-secrets RAG_AI_DATABASE_URL -- \
  sh -c 'exec psql "$RAG_AI_DATABASE_URL"'
```

Use the corresponding Keychain name for the other database. Do not place a
connection URL in shell history, a prompt, a log, or a committed file.
