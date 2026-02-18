# Design Review Command

Review recent code changes for design quality and structural issues.

## Instructions

1. Identify files modified in the current session (check git diff or recent edits)
2. For each modified file, analyze:

### Responsibility Check
- Does any class/function have more than one reason to change?
- Are high-level concepts mixed with low-level implementation details?
- Should any class be a function (or vice versa)?

### Dependency Check
- Are there circular dependencies between modules?
- Do low-level modules depend on high-level abstractions?
- Are imports going in the wrong direction?

### Abstraction Check
- Is the abstraction level consistent within each module?
- Are domain relationships clear and correctly modeled?
- Does the code leak implementation details?

### Structure Check
- Are there god classes or god functions doing too much?
- Is there code duplication that suggests missing abstraction?
- Are there long chains of method calls (Law of Demeter violations)?

3. Report findings with severity:
   - **Critical**: Must fix before committing (bugs, broken design)
   - **Warning**: Should fix soon (technical debt, code smell)
   - **Suggestion**: Nice to have (style, minor improvement)

4. For each issue, provide:
   - File and line reference
   - What the problem is
   - Why it matters
   - Suggested fix (don't implement, just describe)

## Output Format

```
## Design Review Summary

### Critical Issues
- [file:line] Description → Suggested fix

### Warnings
- [file:line] Description → Suggested fix

### Suggestions
- [file:line] Description → Suggested fix

### What's Good
- Positive observations about the design
```

Do NOT implement fixes. Only report findings.
