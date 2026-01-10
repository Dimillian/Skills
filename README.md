[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-live-2ea44f?logo=github)](https://dimillian.github.io/Skills/)

# Skills Public

A collection of specialized skills for iOS and Swift development workflows.

## Overview

This repository contains a set of focused skills designed to assist with common iOS development tasks, from generating release notes to debugging apps and maintaining code quality.

## Installation

### Claude Code

For **project-level skills** (recommended), clone or symlink this repo and the skills in `.claude/skills/` will be automatically available:

```bash
# Clone into your project directory
git clone https://github.com/dimillian/Skills.git .claude-skills
# Or symlink specific skills
ln -s /path/to/Skills/.claude/skills/swiftui-ui-patterns .claude/skills/swiftui-ui-patterns
```

For **personal skills** (available across all projects):

```bash
# Copy skills to your personal Claude Code skills directory
cp -r .claude/skills/* ~/.claude/skills/
```

**Currently available for Claude Code:**
- `swiftui-ui-patterns` - SwiftUI view patterns and component guidance
- `swift-concurrency-expert` - Swift 6.2+ concurrency review and fixes
- `swiftui-liquid-glass` - iOS 26+ Liquid Glass API implementation

### OpenAI Codex

Place these skill folders under `$CODEX_HOME/skills/public` (or symlink this repo there).

### Optional

Enable the pre-commit hook to keep `docs/skills.json` in sync:
`git config core.hooksPath scripts/git-hooks`

## Skills

### 📝 App Store Changelog

**Purpose**: Generate user-facing App Store release notes from git history.

Automatically collects commits and changes since the last git tag (or a specified ref) and transforms them into clear, benefit-focused release notes suitable for the App Store. Filters out internal-only changes and groups user-visible improvements by theme.

**Key Features**:
- Collects commits and touched files since the last tag
- Identifies user-visible changes vs internal work
- Generates concise, benefit-focused bullet points
- Validates changes map back to actual commits

**Use When**: You need to create App Store "What's New" text or release notes based on git history.

---

### 🐛 iOS Debugger Agent

**Purpose**: Build, run, and debug iOS projects on simulators using XcodeBuildMCP.

Provides a comprehensive workflow for building iOS apps, launching them on simulators, interacting with the UI, and capturing logs. Handles simulator discovery, session setup, and runtime debugging.

**Key Features**:
- Discovers and manages booted simulators
- Builds and runs apps on simulators
- Interacts with UI (tap, type, swipe, gestures)
- Captures and analyzes app logs
- Screenshots and UI inspection

**Use When**: You need to run an iOS app, interact with the simulator UI, inspect on-screen state, or diagnose runtime behavior.

---

### 🧭 GH Issue Fix Flow

**Purpose**: Resolve GitHub issues end-to-end using `gh`, local edits, builds/tests, and git push.

Provides a structured flow for reading issues, implementing fixes, validating with XcodeBuildMCP, and shipping changes with a closing commit.

**Key Features**:
- Fetches full issue context with `gh issue view`
- Guides code discovery and focused edits
- Runs targeted builds/tests via XcodeBuildMCP
- Commits with closing message and pushes

**Use When**: You need to take an issue number, inspect it with `gh`, implement a fix, run tests, and push.

---

### ⚡ Swift Concurrency Expert

**Purpose**: Review and fix Swift Concurrency issues for Swift 6.2+ codebases.

Applies actor isolation, Sendable safety, and modern concurrency patterns to resolve compiler errors and improve concurrency compliance. Focuses on minimal behavior changes while ensuring data-race safety.

**Key Features**:
- Identifies actor context and isolation issues
- Applies safe fixes preserving existing behavior
- Handles UI-bound types, protocols, and background work
- Ensures Sendable compliance

**Use When**: You need to review Swift Concurrency usage, improve concurrency compliance, or fix Swift concurrency compiler errors.

---

### 💎 SwiftUI Liquid Glass

**Purpose**: Implement and review SwiftUI features using iOS 26+ Liquid Glass API.

Helps adopt the native Liquid Glass API in SwiftUI interfaces, ensuring correct usage, performance, and design alignment. Supports both new implementations and refactoring existing features.

**Key Features**:
- Uses native `glassEffect` and `GlassEffectContainer` APIs
- Ensures proper modifier ordering and composition
- Handles iOS 26+ availability with fallbacks
- Implements interactive glass for tappable elements
- Supports morphing transitions

**Use When**: You need to adopt Liquid Glass in new SwiftUI UI, refactor existing features to Liquid Glass, or review Liquid Glass usage for correctness.

---

### 🧩 SwiftUI UI Patterns

**Purpose**: Best practices and example-driven guidance for building SwiftUI views and components.

Provides a structured approach to view composition, state ownership, and component selection, with references to common patterns and scaffolding guidance.

**Key Features**:
- Component references for TabView, NavigationStack, Sheets, and more
- Scaffolding guidance for new app wiring
- Emphasis on SwiftUI-native state and composition
- Guidance for consistent, maintainable view structure

**Use When**: You need help designing SwiftUI UI, composing screens, or selecting component patterns.

---

### 🔧 SwiftUI View Refactor

**Purpose**: Refactor SwiftUI view files for consistent structure and dependency patterns.

Applies standardized ordering, Model-View (MV) patterns, and correct Observation usage to SwiftUI views. Focuses on making views lightweight, composable, and maintainable.

**Key Features**:
- Enforces consistent view ordering (Environment → State → init → body → helpers)
- Promotes MV patterns over view models when possible
- Handles view models safely (non-optional when possible)
- Ensures correct `@Observable` and `@State` usage
- Supports dependency injection via `@Environment`

**Use When**: You need to clean up a SwiftUI view's structure, handle view models safely, or standardize dependency injection and Observation usage.

---

### 🚀 SwiftUI Performance Audit

**Purpose**: Audit and improve SwiftUI runtime performance from code review and architecture.

Focuses on identifying common SwiftUI performance pitfalls in view code and data flow, recommending targeted refactors, and guiding user-run Instruments profiling when code review is not enough.

**Key Features**:
- Code-first review for slow rendering, janky scrolling, and excessive updates
- Targets common SwiftUI pitfalls (unstable identity, heavy `body`, layout thrash)
- Provides remediation guidance and refactor suggestions
- Offers a user-run Instruments workflow when needed

**Use When**: You need to diagnose SwiftUI performance issues, improve view/update efficiency, or get guidance on profiling with Instruments.

---

### 🧰 macOS SwiftPM App Packaging (No Xcode)

**Purpose**: Scaffold, build, and package SwiftPM-based macOS apps without an Xcode project.

Bootstraps a minimal SwiftPM macOS app folder, then uses shell scripts to build, assemble the .app bundle, sign, and optionally notarize or generate Sparkle appcasts.

**Key Features**:
- Bootstrap template for a SwiftPM macOS app layout
- Packaging script to assemble a .app bundle without Xcode
- Dev loop script to package and launch the app
- Optional release signing/notarization and appcast tooling

**Use When**: You need a from-scratch macOS app layout and packaging flow without Xcode.

---

## Usage

Each skill is self-contained with its own documentation. Refer to the `SKILL.md` file in each skill's directory for detailed workflows, guidelines, and examples.

## Contributing

Skills are designed to be focused and reusable. When adding new skills, ensure they:
- Have a clear, single purpose
- Include comprehensive documentation
- Follow consistent patterns with existing skills
- Include reference materials when applicable
