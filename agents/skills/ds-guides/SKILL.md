---
name: ds-guides
description: Guidelines when evaluating extracting and naming new components
title: Ds Guides
---

We should try to reuse as much as possible but when creating a new component is needed, following those highlights is mandatory:

/Users/jadercorrea/workspace/zapfy/connect/design-system/guidelines.html
/Users/jadercorrea/workspace/zapfy/connect/design-system/naming.html# 1. Page Layout Foundations
When building internal/authenticated pages (Portals, Dashboards, CRUD screens), you MUST follow the **3-Block Rule** for structural hierarchy, wrapped in the standard `page-layout` container.

## 1.1 The Canvas (`page-layout`)
The root container for any authenticated page. It handles padding, constraints, and the atmospheric background.

```html
<main class="main-content page-layout">
    <!-- Content goes here -->
</main>
```

*(Note: Depending on the specific design, this is sometimes accompanied by `.bg-layer` elements for grain/glow effects placed directly before the main content).*

## 1.2 The CMD Header Container (`z-card`)
The CMD Header (Title, Subtitle, KPIs, Actions) MUST be wrapped in a container to elevate it from the background canvas. Agents frequently fail to provide the background, resulting in a dark/transparent header that clashes with the UI.

The standard premium container for this is often defined using `.z-card` or `.card-base` combined with `.container-premium`.

```html
<!-- MANDATORY: The CMD Header must live inside a card/container with a background -->
<div class="z-card animate-in">
    <div class="cmd">
        <div class="cmd__left">
            <h1 class="cmd__title page-header__title--accent">Page Title</h1>
            <p class="cmd__subtitle">Page description and context</p>
        </div>
        <div class="cmd__right">
            <!-- Actions (Buttons) and KPIs go here -->
        </div>
    </div>
</div>
```

**CRITICAL:** Never place a `.cmd` header directly on the `.page-layout` canvas. It must always be contained within a `.z-card`, `.card`, or `.container-premium` to ensure it has a proper background (e.g., `var(--card-solid)`).

## 1.3 The Grid Layout (`page-grid`)
Below the CMD Header, the content is typically structured using a CSS Grid or Flexbox, again with individual sections wrapped in `.z-card` containers.

```html
<section class="page-grid">
    <!-- Main Content Area -->
    <div class="page-grid__main">
        <div class="z-card z-card--tool animate-in">
            <div class="z-card-inner">
               <!-- Primary Content (Tables, Forms, Lists) -->
            </div>
        </div>
    </div>

    <!-- Aside/Sidebar Area (Optional) -->
    <aside class="page-grid__aside">
        <div class="z-card z-card--instrument animate-in">
            <div class="z-card-inner">
                <!-- Secondary Content (Metrics, Checklists, Guidance) -->
            </div>
        </div>
    </aside>
</section>
```
