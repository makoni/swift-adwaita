# Validating finished work with the project subagents

This repository has review subagents (see `.opencode/agents/`). Use them to
validate your own work before you report a task as done.

## When to validate

Validate when the task changed files under `Sources/`, `Tests/`, `Tools/`,
`Package.swift` or `.github/workflows/`, and you believe the task is complete.

Skip validation when:
- nothing in the repository changed (questions, explanations, research);
- only documentation or comments changed — then run only `pre-pr-check`;
- the user explicitly says to skip it.

## Hard rule: one subagent at a time

- Launch exactly ONE subagent per message. Never put two `task` calls in the
  same message, even if they look independent.
- Wait for that subagent's result and read it before you launch the next one.
- Do not run subagents in the background.

## Which subagents, in this order

Go down the list and launch only those whose condition matches the change:

1. `swift-reviewer` — any Swift file under `Sources/` changed.
2. `architecture-reviewer` — public API changed, a file or target was added,
   or `Sources/Adwaita/Generated/`, `Tools/AdwaitaCodeGen/`,
   `Sources/CAdwaita/shim.h` or `Package.swift` changed.
3. `test-reviewer` — anything under `Tests/` changed, or the task was a bug fix
   (a bug fix needs a regression test).
4. `security-reviewer` — `shim.h`, `CWebKit`/`AdwaitaWebKit`, signal
   trampolines, URI launching, clipboard, file dialogs or markup handling
   changed.
5. `regression-hunter` — the task was a bug fix.

Then:

6. Fix every **blocker** and **major** finding. Fix **minor** findings when the
   fix is small and in scope; otherwise list them in your final report.
7. If you fixed anything, launch `final-verifier` with the numbered list of
   findings you addressed.
8. Launch `pre-pr-check` last, as the gate (build, tests under Xvfb, lint).
   If it reports a FAIL, fix it and launch `pre-pr-check` again.

Do at most two fix-and-verify rounds. If findings remain after that, stop and
report them to the user instead of looping.

## What to tell each subagent

Subagents start with no context. In every `task` prompt include:

- one or two sentences on what the task was and why;
- that the changes may be uncommitted, so they must review the working tree
  against `main`: `git status --short`, `git diff origin/main` (plus reading
  any untracked files), not only `git diff origin/main...HEAD`;
- the list of changed files;
- for `final-verifier`: the findings, numbered, and what you changed for each.

## Final report

When you report the task as done, add a short validation section: which
subagents ran, their verdicts, what you fixed, and anything left open.
