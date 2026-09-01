---
name: db.rag.vacuum
description: Run VACUUM ANALYZE on production RAG database (Xata)
title: DB RAG Vacuum
---

This skill executes a database vacuum analyze on the production RAG database.
It vacuums all tables by default, or accepts an optional table name parameter (e.g. `leads`).

Run this command in the terminal:
zapfy db rag-vacuum [table]
