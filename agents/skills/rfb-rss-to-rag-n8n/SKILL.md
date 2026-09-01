---
name: rfb-rss-to-rag-n8n
description: Pipeline N8N para injetar notícias da Receita Federal (RFB) via RSS no RAG AI Vector DB (Xata PostgreSQL)
title: Rfb Rss To Rag N8N
---

# N8N RFB RSS to RAG Workflow

Este workflow automatiza a leitura de novas notícias institucionais e normativas da Receita Federal do Brasil (RFB) e as disponibiliza nativamente para pesquisa semântica do agente.

## 1. Estrutura da Ferramenta e Pipeline
- **Onde roda:** Na instância hospedada em `https://zapfy-n8n.fly.dev` (zapfy-n8n).
- **Como verificar?** Você pode conferir a API em `/api/v1/workflows` usando `X-N8N-API-KEY` (originada da secret `N8N_API_KEY`).
- **Onde o workflow entra:** Foi criado e injetado o blueprint `RFB RSS -> RAG AI (Xata)`.

## 2. Passo a Passo do Workflow no N8N
1. **Schedule Trigger:** Acionado ciclicamente.
2. **RSS Read (gov.br):** Lê o XML base de notícias da Receita Federal.
3. **If Database Check:** Pesquisa na tabela `documents` (Xata) através do Node Postgres se a URL base do RSS já existe na base, evitando indexar coisas duplicadas.
4. **Scraping de HTML (HTTP Request + HTML Extract):** Consulta a respectiva URL de notícia do RSS e extrai **somente** o div de conteúdo (`#content-core`) usando a opção HTML node do N8N.
5. **Geração de Embeddings:** Faz uma requisição HTTP via Node para a `https://openrouter.ai/api/v1/embeddings` usando `text-embedding-3-small`.
6. **Inserção Postgres (Documents & Chunks):** Utiliza as credenciais nativas cadastradas em N8N (Xata DB/rag_api) para persistir o cabeçalho e os blocos semânticos vetoriais nos slugs `reforma-tributaria` ou `tax-reform-kb`.

## 3. Manutenibilidade e Expansão
- Se os agentes precisarem de outros diários oficiais (exclusivos para estados ou prefeituras), deve-se replicar esse template de workflow customizando a URL do RSS.
- A credencial para uso de chamadas de OpenRouter API precisa estar cadastrada localmente no workflow.
- Sempre verifique o ID do Workflow e ative-o na UI caso deseje disparar atualizações retroativas.
