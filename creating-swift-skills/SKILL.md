---
name: creating-swift-skills
description: Guide for creating Swift/iOS skills. Use when contributing new skills to ensure consistent format and quality.
---

# Creating Swift Skills

## Overview

Create focused, actionable skills for Swift and iOS development following repository conventions.

## Structure

```
skill-name/
├── SKILL.md              # Main entry point
├── references/           # Optional deep-dives
│   └── topic.md
└── assets/templates/     # Optional starter files
    └── bootstrap/
```

## Workflow

### 1. Define scope

Choose a specific topic:
- Framework or API (Swift Testing, SwiftUI patterns, Concurrency)
- Workflow (debugging, performance audit, refactoring)
- Migration path (XCTest to Swift Testing)

Avoid duplicating Apple docs without adding value.

### 2. Copy the template

```bash
cp -r assets/templates/skill-template my-skill-name
```

### 3. Write frontmatter

```yaml
---
name: skill-name
description: What it does + when to invoke it.
---
```

### 4. Add Overview and Workflow

- Overview: One to two sentences
- Workflow: Numbered steps with code examples

### 5. Add references (optional)

Create `references/*.md` for detailed content. One topic per file.

### 6. Run quality checklist

See `references/quality-checklist.md` before submitting.

## Reference material

- See `references/skill-structure.md` for file anatomy.
- See `references/writing-guidelines.md` for tone and style.
- See `references/quality-checklist.md` for pre-submission review.
- See `assets/templates/skill-template/` for starter template.
