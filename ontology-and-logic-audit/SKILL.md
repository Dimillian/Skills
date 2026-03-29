---
name: ontology-and-logic-audit
description: Analyze a spec, argument, requirement set, prompt, or conceptual framework by validating ontology before logic. Use when the user asks for rigorous critique, category-mistake detection, hidden-assumption analysis, modality separation, or minimal repair of a draft whose core concepts may be confused.
---

# Ontology and Logic Audit

Audit a draft by checking whether its subject matter is being described under the right kind of thing before evaluating whether the reasoning is valid. Use this skill for specs, prompts, arguments, requirements, architecture write-ups, and conceptual frameworks where the user wants a stricter critique than a normal review.

## Core Principles

- Define the terms before judging the argument.
- Test ontology before logic: if the subject is misclassified, say so immediately.
- Do not rescue a broken ontology by charitable interpretation.
- Distinguish established claims from hypotheses.
- Keep hypotheses testable and repairs minimal.

## Workflow

### 1) Normalize the terms

- Extract the key terms the draft relies on.
- Define each term in plain working language before analyzing the reasoning.
- If the draft uses the same term in more than one sense, flag the shift and state the normalized meaning you will use.

Typical examples:

- thing vs property
- capability vs permission
- rule vs observation
- implementation detail vs architectural boundary
- empirical claim vs conceptual claim

### 2) Validate the ontology first

- Ask what kind of thing each central claim is about.
- Check whether the draft treats one category as if it were another.
- Look for category mistakes, collapsed distinctions, or a framework that conflicts with obvious real cases.

If the ontology fails:

- say so immediately
- give one concrete counterexample
- label the failure as `categorical` or `empirical`
- stop trying to save the original framing through reinterpretation

### 3) Audit the logic

Only after the ontology is sound enough to proceed:

- surface hidden assumptions
- test whether the conclusion follows from the premises
- check whether the draft changes modality mid-argument
- identify contradictions, unsupported leaps, or circular reasoning
- check for salvage by trivialization, where a strong claim only survives after being weakened into a tautology

### 4) Separate modalities

Call out the kinds of claim being made:

- conceptual necessity
- empirical possibility
- practical constraint
- policy requirement
- contingent implementation choice

If the draft slides from one modality to another, name the shift explicitly.

### 5) Present the audit as an argument

Structure the response in this order:

1. normalized terms
2. ontology verdict
3. premises
4. reasoning steps
5. conclusion
6. minimal repair, if needed

Prefer short, direct statements over rhetorical flourish.

## Output Expectations

Return a compact audit that includes:

1. `Term normalization`
   - the key terms and the meanings used for the audit

2. `Ontology verdict`
   - whether the framing is sound
   - the exact category mistake or empirical conflict, if present

3. `Logic findings`
   - hidden assumptions
   - invalid steps
   - contradictions or trivializations

4. `Modalities`
   - the types of necessity/possibility claims being made

5. `Minimal repair`
   - the smallest restatement that preserves the user's goal under a sound ontology

## Failure Shields

- Do not skip ontology and jump straight to stylistic or logical critique.
- Do not soften a category mistake into a vague “may need clarification”.
- Do not treat every disagreement as an ontology failure; distinguish conceptual errors from missing evidence.
- Do not inflate hypotheses into established conclusions.
- Do not rewrite the draft wholesale when a smaller repair will do.

## Good Fits

Use this skill when the user asks for:

- rigorous critique of a spec or proposal
- ontology-first review of a prompt or framework
- category-mistake detection
- hidden-assumption analysis
- separation of possibility, necessity, and policy claims
- a minimal repair of a conceptually confused draft

## Poor Fits

Prefer a different skill when the user wants:

- ordinary code review of a diff
- bug root-cause investigation
- broad brainstorming without a concrete draft to audit
- style-only copy editing
