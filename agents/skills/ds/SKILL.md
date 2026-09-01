---
name: ds
description: Zapfy Design System
title: Ds
---

Every UI element used in Zapfy should use the following elements.
/Users/jadercorrea/workspace/zapfy/connect/design-system

**CRITICAL: Page Layout & Header Hierarchy**
Whenever building or modifying internal/authenticated pages, you MUST adhere to the structural constraints (such as `page-layout` and `.z-card` containers for CMD headers) outlined in the `/ds-guides` workflow. Failure to wrap `.cmd` headers in a proper card container will break the UI metrics and contrast. Run `/ds-guides` and view the "Page Layout Foundations" section.

DISCLAIMER:
If you did add a new component or change that needs a new version of the DS to be used in your implementation, you need to commit/push the connect repository AND run zapfy ds release to get the correct version you need to set in your change, otherwise it wont work.
