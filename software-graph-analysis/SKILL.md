---
name: software-graph-analysis
description: Build and query Ontoly Software Graphs for deterministic codebase understanding. Use when asked to explain architecture, trace routes, find service ownership, inspect dependencies, assess impact, find configuration usage, or answer repository questions with graph evidence before source search.
---

# Software Graph Analysis

## Overview

Use Ontoly as the first evidence source for repository-understanding work. The goal is to answer from a deterministic Software Graph, then use source inspection only when the graph is missing coverage or has ambiguous evidence.

## Workflow

1. Locate the repository root.
2. Check for `.ontoly/SoftwareGraph.json` or another supplied graph path.
3. If no graph exists or it appears stale, run:

   ```bash
   npx ontoly build .
   ```

4. Review graph metadata, graph hash, diagnostics, statistics, framework detection, trust, and coverage before answering.
5. Query Ontoly CLI or MCP capabilities for the narrowest relevant graph concepts:
   - packages, modules, services, controllers, routes
   - functions, classes, interfaces, imports, exports
   - callers, callees, dependencies, consumers
   - configuration and environment-variable usage
   - diagnostics, dead code, unresolved imports, circular relationships
6. Cite nodes, edges, relationship types, source locations, diagnostics, and confidence in the final answer.
7. Inspect source files only when graph evidence is missing, ambiguous, or contradicted by diagnostics. Label source inspection as fallback evidence.

## Answer Template

```markdown
## Answer
{Direct answer.}

## Graph Evidence
| Kind | Evidence |
|------|----------|
| Node | `{node id}` ({kind}) |
| Edge | `{source} --RELATIONSHIP--> {target}` |
| Location | `{file}:{line}` |
| Diagnostic | `{code}: {message}` |

## Confidence
{High, Medium, or Low} because {specific graph evidence and diagnostics}.

## Gaps
{Missing coverage, ambiguous nodes, or fallback source inspection.}
```

## Use Cases

- Explain the repository architecture.
- Trace a route or request lifecycle.
- Find which service owns a capability.
- Determine what depends on a class, function, package, or module.
- Assess what breaks if a node changes.
- Locate configuration and environment variable usage.
- Validate graph quality before trusting an analysis.

## Guardrails

- Do not answer architecture or impact questions from source search until Ontoly graph evidence has been checked.
- Do not guess confidence; derive it from graph coverage, diagnostics, and connected evidence.
- Do not hide graph gaps. Missing nodes and missing relationships are useful findings.
- Do not modify the target repository unless the user explicitly asks for implementation work.
