# CLAUDE.md — agent instructions for CVA6-DX

This repository is **CVA6-DX**, a 2-wide in-order RV64 application core (RVA23 with a vector
unit, Linux/Ubuntu-capable) evolved from openhwgroup/cva6 at commit `81245a47f`
(HPDcache `e8f072e`). Branch `dx/main` carries all DX work.

Yazan Hussnain (10xEngineers) is the engineer and design authority. Agents implement under his
review. These instructions are binding for every agent session.

## 1. Two repositories

| Repository | Visibility | Local checkout | Content |
|---|---|---|---|
| `10x-Engineers/cva6-dx` (this one) | public | `cva6-dx/` | RTL (`design/`), IP, platform, verification, scripts, these rules |
| `10x-Engineers/cva6-dx-docs` | **private** | `../cva6-dx-docs/` (or `$CVA6DX_DOCS`) | specification v3.1, implementation plan, ADRs, notebook, evidence |

**Never copy specification text, plan content, decision briefs or notebook material into this
public repository** — not in files, commit messages or PR descriptions. Reference them by ID
(task M02.01, row PD-218, ADR-DX-005) only.

## 2. Sources of truth (in the docs repository)

1. `plan/CVA6-DX_Implementation_Plan.xlsx` — the plan (master). Read its **README** sheet
   completely; the AGENT PROTOCOL and DEFINITION OF DONE are binding.
2. `spec/` — CVA6-DX Consolidated Architecture v3.1. Part VI (Chapters 34–51) is the
   module-level spec; Appendix J = findings (DF), Appendix K = proposed details (PD).
3. `adr/` — decisions taken during implementation; the Decisions sheet mirrors them.
4. Baseline RTL: `git show 81245a47f:<path>`. Spec and plan quote baseline paths and names;
   translate them with `util/dx/rename_map.csv` (this repository).

## 3. Session start check (every session)

1. Read `notebook/00_INDEX.md`, the latest `notebook/handoff/*.md` and `notebook/KNOWLEDGE.md`
   in the docs repository.
2. Compare the remembered state with the workbook (task Status, open decisions) and with both
   repositories (branch, last commit, CI state). If anything is missing or does not match,
   **stop and tell Yazan** before doing anything else.

## 4. Rules

- Architecture and parameters are frozen by v3.1 plus the Decisions sheet. Never pick an option
  for an Open decision unless Yazan delegates it explicitly; then record it as decided by
  delegation, with the rationale.
- If the spec is ambiguous or contradicts the RTL: stop, add a Decisions row
  (Type = NEW, Status = Open) and ask Yazan.
- Coding: `CONTRIBUTING-DX.md` — lowRISC style **plus** the design authority's rules:
  no single-character names, functions only for parameter calculation, never `$countones`.
- Every feature sits behind a `cva6_user_cfg_t` field; no `` `ifdef ``; parachute rule (field
  off ⇒ bit-identical, no extra logic); `design/` compiles stand-alone.
- Every number carries an evidence tag: `[RTL] file:lines@commit`, `[CITED] source`,
  `[MEASURED] run/log`, `[ESTIMATE] <derivation>`. Never invent numbers.
- Do not change behaviour outside the task's scope.
- Never push to upstream openhwgroup/cva6 or open upstream PRs without Yazan's approval.
- Yazan reviews all generated RTL before a task is marked Done.

## 5. How to work

- Core track: take the first Tasks row with Status = "Not started" whose "Depends on" tasks are
  all Done, in sheet order.
- Per task: load its Spec refs and every Decided row for its chapters → show Yazan the plan
  (files, modules, config fields, tests) **before writing RTL** → implement → meet the
  Acceptance criteria and the Definition of Done → record results with evidence in Notes.
- Tasks owned by "Yazan" (Decide tasks): prepare a decision brief in the docs repository
  (`notebook/briefs/`) and wait for his decisions.
- After each task: update the workbook (Status, Actual end, Notes), write
  `notebook/handoff/<task-id>.md` (state, files changed, test results, open items, next task),
  append one line to `notebook/00_INDEX.md`, and commit both repositories.
- Stop after each milestone gate: report each exit criterion with evidence (met / not met),
  decisions taken, new DF/NEW rows, effort actual vs. plan, schedule impact; wait for Yazan's
  confirmation before the next milestone.

## 6. Editing the workbook

- Edit with `openpyxl`, then always recalculate:
  `python3 plan/tools/recalc_workbook.py <xlsx> <xlsx>` (LibreOffice headless; restores the
  frozen panes LibreOffice drops). Check that no cell holds an error value afterwards.
- Edit input cells only (Status, Actual end, Notes, Decision, Date, new rows); never formula
  cells. When appending rows, extend the ranges that end at the last row (validation,
  conditional formatting, Milestones `COUNTIFS`). Keep each session's editing script under
  `notebook/evidence/<task-id>/`.

## 7. Build quick reference

```bash
export CVA6_REPO_DIR=$PWD TARGET_CFG=cv64a6_imafdc_sv39 HPDCACHE_DIR=$PWD/ip/hpdcache
verilator --lint-only --no-timing verilator_config.vlt -f design/cva6dx_core.f \
  --top-module cva6dx_core -Wall -Wno-fatal          # stand-alone core lint
make verilate target=cv64a6_imafdc_sv39 SPIKE_INSTALL_DIR=$PWD/tools/spike RISCV=$PWD/tools/spike
```
