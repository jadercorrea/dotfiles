# dotfiles

My personal development environment for macOS and Linux.

This repository contains the shell, editor and terminal configuration I use for day-to-day software engineering, with an emphasis on developer productivity, automation and AI-assisted workflows.

## Highlights

- Zsh configuration
- Neovim setup
- Shell aliases and utilities
- Git configuration
- New machine bootstrap scripts
- AI-assisted development workflow
- Shared agent skills
- Keychain-backed agent credentials

## Philosophy

The goal is to keep a fast, reproducible and keyboard-driven development environment that can be installed on a new machine with minimal manual setup.

## Structure

```
bash/
agents/
bin/
new_mac_setup/
vim/
zsh/
```

## Agent skills

The canonical user-level skills live in `agents/skills/`. Running:

```bash
~/.dotfiles/agents/install.sh
```

links the supported agent directories to that source. Codex, Kimi Code and Warp
use `~/.agents/skills` directly; OpenCode, Claude, Gemini, Antigravity, Cursor
and Qoder use symlinks created by the installer.

Platform-provided or plugin-managed skills remain outside this repository.

## Secrets

Credential values are stored in macOS Keychain under:

```text
dev.jadercorrea.agent-secrets.v2
```

The repository contains only their names in `agents/secrets.manifest`.

```bash
agent-secret list
agent-secret has OPENAI_API_KEY
agent-secret set OPENAI_API_KEY

with-agent-secrets OPENAI_API_KEY -- command-that-needs-it
```

`with-agent-secrets` injects only the requested values into one child process.
Do not commit environment files or place literal credentials in skills.

The repository pre-commit hook runs `scan-secrets --staged`. Run a full scan
manually with:

```bash
scan-secrets --all
```

## Status

This repository evolves together with my daily workflow and receives updates whenever my development environment changes.
