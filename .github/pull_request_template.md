# Pull Request

## Summary

<!-- What does this PR do, and why? Keep it short but complete. -->

Fixes # <!-- link related issue(s), or delete this line -->

## Type of change

<!-- Check all that apply. -->

- [ ] Bug fix (corrects incorrect behavior)
- [ ] New feature / new science functionality
- [ ] No functional change (refactoring, cleanup, comments, performance, build/CI, docs)
- [ ] Change to existing input file(s) or input variables
- [ ] New input file(s) or input variables
- [ ] Change to existing output file(s) or output variables
- [ ] New output file(s) or output variables

## Input / output changes

<!-- Delete this section if no input or output files are affected.
     List every affected file and variable so users and interface tools
     (QSWAT+, SWAT+ Editor, SWAT+ Toolbox) can track format changes. -->

| File | New or changed? | What changed (variables added/removed/renamed, units, column order, defaults) |
|------|-----------------|-------------------------------------------------------------------------------|
|      |                 |                                                                               |

- [ ] Existing model setups (project datasets) still run without modification
- [ ] Existing setups require changes — describe what users must update:

## Effect on simulation results

<!-- Check one. Even a pure bug fix usually changes numbers — say so explicitly. -->

- [ ] Results are identical to the current head (results-neutral)
- [ ] Results change, and the change is intended/justified — briefly explain the expected direction and magnitude, and which outputs are affected:

## Testing

<!-- How did you verify the change? -->

- Dataset(s)/scenario(s) run:
- Compiler(s) and OS used:
- [ ] Code compiles without new warnings
- [ ] Outputs compared against a baseline run (e.g., `test/spcheck.py` or manual diff)
- [ ] Reference dataset (`refdata`) needs a revision update because expected outputs changed

## Documentation

- [ ] Not needed
- [ ] Input/output documentation needs updating (SWAT+ I/O docs, header comments, `doc/`)
- [ ] Updated in this PR

## Additional notes

<!-- Anything else reviewers should know: known limitations, follow-up work, related PRs. -->
