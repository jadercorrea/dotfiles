---
name: design-review
description: Conduct thorough UI/UX and design-system reviews focusing on hierarchy, consistency, accessibility, and product intent. Prioritizes issues by severity and provides actionable feedback.
title: Design Review
---

## Summary

- **Ship / Block / Ship with fixes**
- Required changes (if any)
- DS components/tokens impacted
- Follow-ups (optional)
```

---

## Things to Avoid

- No “trend chasing” (only propose changes that improve clarity, consistency, accessibility, or DS governance)
- No redesigning the entire screen unless the current intent is clearly broken
- No “what if it scales” speculation—review what’s in the change
- No over-abstraction—promote DS components only when patterns repeat

## Preserve Developer & Product Intent

Recommend pragmatic changes that preserve intent (conversion vs productivity). Push back hard only when:
- the flow is broken,
- DS rules are violated repeatedly,
- accessibility is compromised,
- or the UI undermines trust (especially in Fiscal/Payments).
