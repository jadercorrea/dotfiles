---
name: modal
description: Zapfy Premium Modal Patterns
title: Modal
---

Every modal in Zapfy should follow the layout, flow, and visual pattern outlined below.
Original file: /Users/jadercorrea/workspace/zapfy/docs/prod/concepts/modal-pattern.md

# Premium Modal Pattern — Product Form Reference

Standard visual pattern applied to the **products** and **clients** creation modals.
Use this as the reference when applying the same treatment to other creation forms.

---

## 1. Glow Bleed Fix (AI/Automation enrichment)

**Problem:** `.field-locked { opacity: 0.6 }` makes the entire input semi-transparent, letting the `.glow` conic-gradient bleed through as a spotlight inside the field.

### CSS — 3 rules needed

```css
/* ① Strip .input base class glass effects inside portal modals */
.modal-portal .input,
.modal-portal .input--portal,
.modal-portal textarea.input,
.modal-portal select.input {
    background: rgba(255, 255, 255, 0.04) !important;
    box-shadow: none !important;
}

/* ② Opaque background + no transition for inputs inside .glow */
.glow>.input,
.glow>.input--portal,
.glow>select.input,
.glow>textarea.input,
.glow>textarea.input--portal {
    background: var(--card-solid, #1a1a1a) !important;
    box-shadow: none !important;
    border: none;
    transition: none !important;  /* prevents 0.2s flash from .input transition:all */
}

/* ③ field-locked: text dimming instead of opacity */
.field-locked {
    color: rgba(255, 255, 255, 0.35) !important;
    pointer-events: none;
}
```

### CSS — Glow wrapper sizing (form context)

```css
.form-group .glow {
    display: flex;
    width: 100%;
    flex: 1;
    min-width: 0;
    border-radius: var(--radius-xl);
}

.form-group .glow>* {
    border-radius: calc(var(--radius-xl) - 1px);
    width: 100%;
}
```

---

## 2. Sticky Header + Footer (scrollable body)

**Problem:** `overflow-y: auto` on the modal div scrolls the page behind it.

### HTML structure

```html
<div class="modal-overlay" id="XXX-modal">
  <div class="modal modal-lg modal-portal" style="max-height:90vh;display:flex;flex-direction:column;">
    <div class="modal-header">...</div>

    <!-- Progress bar — flush, no label -->
    <div class="XXX-progress" id="XXX-progress">
      <div class="progress progress-sm" style="flex:1;">
        <div class="progress-bar" id="progress-bar" style="width:0"></div>
      </div>
    </div>

    <form id="XXX-form" novalidate>
      <div class="modal-body">
        <!-- form fields -->
      </div>
      <div class="modal-footer">
        <!-- buttons -->
      </div>
    </form>
  </div>
</div>
```

### CSS

```css
/* Modal flex layout */
#XXX-modal .modal-portal {
    display: flex;
    flex-direction: column;
}

/* Form fills remaining space */
#XXX-form {
    display: flex;
    flex-direction: column;
    flex: 1;
    overflow: hidden;
}

/* Body scrolls, header/footer stick */
#XXX-modal .modal-body {
    flex: 1;
    overflow-y: auto;
    padding-right: 8px;
}

#XXX-modal .modal-footer {
    position: sticky;
    bottom: 0;
    background: var(--card-solid, #1a1a1a);
    border-top: 1px solid rgba(255, 255, 255, 0.08);
    z-index: 2;
}

/* Progress bar — flush, no padding */
.XXX-progress {
    padding: 0;
}

.XXX-progress.progress-success .progress-bar {
    background: var(--success, #22c55e);
}
```

---

## 3. Progress Bar (no label)

**Before:** `<span class="progress-label">0/5</span>` — takes space, less elegant.
**After:** Label removed. Bar fills full width edge-to-edge under the header.

### JS — `updateProgress()` simplified

```js
function updateProgress() {
    const fields = [/* required field IDs */];
    const filled = fields.filter(f => document.getElementById(f)?.value?.trim()).length;
    const pct = Math.round((filled / fields.length) * 100);
    const bar = document.getElementById('progress-bar');
    const wrap = document.getElementById('XXX-progress');
    if (bar) bar.style.width = pct + '%';
    if (filled === fields.length) {
        wrap?.classList.add('progress-success');
    } else {
        wrap?.classList.remove('progress-success');
    }
}
```

Call `updateProgress()` on modal open (after populating fields).

---

## 4. AI / Automation Field Pattern (✨ vs ⚡)

**Principle:** Every auto-filled field should communicate _what fills it_ and _how_ — through the placeholder alone. No verbose banners or info blocks inside the form.

### Two types

| Signal | Icon | Meaning | Placeholder pattern |
|--------|------|---------|-------------------|
| **AI** (Sparkle) | ✨ | Filled by AI/copilot (GPT, RAG) | `✨ Preenchido pelo copiloto fiscal` |
| **Automation** (Lightning) | ⚡ | Filled by deterministic logic (lookup, calc) | `⚡ Identificado automaticamente` |

### Rules

1. **Placeholder = the only explainer.** No `<div>` banner saying "NCM preenchido automaticamente". The placeholder _is_ the guide.
2. **Premium language.** Never mention data sources (CPF, CNPJ) or vendor names. Use elegant verbs: _Identificado_, _Classificado_, _Gerado_, _Sugerido_.
3. **No provider names.** Don't say "BrasilAPI", "Receita Federal", etc. The system is Zapfy — the user doesn't need to know the plumbing.
4. **Badge on fill.** When a field IS filled by AI/Automation, show the sparkle/lightning AI badge next to the label (existing `showFieldAiBadge()` / `showAutoBadge()`).
5. **Glow on enrichment.** When enrichment is running, wrap the input in `.glow` + `.glow--pulse`. When done, resolve with `resolveField()`.

### Reference: Products form fields

| Field | Signal | Placeholder |
|-------|--------|-------------|
| Descrição SEO | ✨ AI | `✨ Gerada automaticamente` |
| Keywords | ✨ AI | `✨ Otimizadas para SEO, ASO, AAIO, AEO, GEO, RAG e E-E-A-T` |
| Categoria sugerida | ✨ AI | `✨ Sugerida automaticamente` |
| Marca | ⚡ Auto | `⚡ Identificada automaticamente` |
| SKU | ⚡ Auto | `⚡ Gerado automaticamente` |
| Código barras | ⚡ Auto | `⚡ Buscado automaticamente` |
| NCM | ✨ AI | `✨ Preenchido pelo copiloto fiscal` |

### Reference: Clients form fields (CPF/CNPJ lookup)

| Field | Signal | Placeholder |
|-------|--------|-------------|
| All auto-filled fields | ⚡ Auto | `⚡ Identificado automaticamente` |

### Reference: Suppliers form fields (CNPJ lookup)

| Field | Signal | Placeholder |
|-------|--------|-------------|
| Razão Social | ⚡ Auto | `⚡ Identificado automaticamente` |
| Nome Fantasia | ⚡ Auto | `⚡ Identificado automaticamente` |
| Inscrição Estadual | ⚡ Auto | `⚡ Identificado automaticamente` |

---

## 5. Checklist for applying to a new form

- [ ] Modal div: `style="max-height:90vh;display:flex;flex-direction:column;"`
- [ ] Add `modal-portal` class to modal div
- [ ] Progress bar: no `<span class="progress-label">`, bar with `style="width:0"`
- [ ] Progress wrapper: `padding: 0` (flush)
- [ ] `<form>` flex layout CSS (flex:1, overflow:hidden)
- [ ] `.modal-body` scroll CSS (flex:1, overflow-y:auto)
- [ ] `.modal-footer` sticky CSS (position:sticky, background:card-solid)
- [ ] Glow inputs: opaque background + transition:none + !important
- [ ] `.field-locked`: color dimming, NOT opacity
- [ ] `updateProgress()` called on modal open, no label references
