# Skill structure

## Required files

```
skill-name/
├── SKILL.md              # Entry point, always required
└── references/           # Optional, for deep content
    └── topic.md
```

## SKILL.md anatomy

```markdown
---
name: skill-name
description: What it does + when to invoke it.
---

# Skill Title

## Overview

One to two sentences.

## Workflow

### 1. First step

Actionable instruction with code.

### 2. Next step

More instructions.

## Reference material

- See `references/topic.md` for details.
```

## References folder

One file per topic. Use when content is too detailed for SKILL.md.

| File | Purpose |
|------|---------|
| `basics.md` | Core concepts and usage |
| `advanced-patterns.md` | Complex scenarios |
| `migration.md` | Upgrade paths |

## Assets folder

Optional. Use for templates and scripts.

```
assets/templates/
├── bootstrap/        # Starter project files
└── scripts/          # Automation scripts
```

## Naming

- Skill folder: `kebab-case` (e.g., `swift-testing`)
- Files: `kebab-case.md`
- No prefixes like `swift-` unless disambiguating
