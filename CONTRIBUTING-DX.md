# Contributing to CVA6-DX

These rules apply to all work on the `dx/*` branches. They come from the CVA6-DX architecture
specification (implementation guide and parachute rule), the implementation plan and the design
authority's coding rules. The upstream rules in `CONTRIBUTING.md` still apply to anything offered
upstream.

## Repository layout

| Path | Content |
|---|---|
| `design/` | synthesizable core RTL, one directory per unit (`frontend/ decode/ issue/ execute/ lsu/ cache/ mmu/ commit/ csr/ pmu/ cvxif/ prim/ rvfi/`, later `vector/`); top `design/cva6dx_core.sv`; packages in `design/include/`; named configurations in `design/cfg/`; file list `design/cva6dx_core.f` |
| `ip/` | third-party IP as git submodules: `hpdcache/`, `cvfpu/` |
| `vendor/` | vendored PULP IP (common_cells, axi, …), unchanged |
| `examples/cvxif/` | example CV-X-IF coprocessor |
| `corev_apu/` | APU platform: test harness, FPGA, peripherals (upstream layout, to be reorganised with the CI work) |
| `verif/` | verification (upstream layout; `verif/tb/pmp/` holds the PMP unit test) |
| `util/dx/` | CVA6-DX scripts; `rename_map.csv` maps every baseline (81245a47f) path and name to the current one |

Design documents (specification, plan, decision records, notebook) are in the private companion
repository `10x-Engineers/cva6-dx-docs`.

## Naming rules

1. Every core module is `cva6dx_<name>`. The file is named `<module>.sv`; one module per file.
2. Every package ends in `_pkg`; core packages are `cva6dx_pkg` and `cva6dx_<name>_pkg`.
3. Kept unchanged because the specification and the plan use them: `config_pkg`,
   `build_config_pkg`, `cva6_user_cfg_t`, `cva6_cfg_t`, the `CVA6Cfg` parameter, the
   `cva6_config_pkg` selection mechanism, the configuration file names (`TARGET_CFG` /
   `target=` values), `l15_pkg` (mirrors OpenPiton) and all third-party IP.
4. To translate a path or name from the specification, the plan or a `[RTL] …@81245a47f`
   evidence tag, use `util/dx/rename_map.csv`.

## RTL rules

1. **Style.** lowRISC SystemVerilog style guide
   (<https://github.com/lowRISC/style-guides/blob/master/VerilogCodingStyle.md>), together with
   the rules 2–4 below. Where they differ, rules 2–4 win.
2. **No single-character signal names.** Every signal, port, variable, struct field and
   parameter uses a full descriptive name (`valid`, `address`, `write_enable`, not `v`, `a`,
   `we`-style single letters). This includes loop and generate indices
   (`for (int unsigned port_idx = 0; …)`, `genvar way_idx`).
3. **Functions only for parameter calculation.** A `function` may only compute
   elaboration-time constants (`localparam`, `parameter`, `build_config()`-style
   derivations). All logic is written in `always_comb` / `always_ff` / `assign` or in a module.
   No function or task is called from run-time logic.
4. **Never use `$countones`** (nor `$onehot`, `$onehot0`, `$countbits` in synthesizable logic).
   Write population counts and one-hot checks as explicit logic or with a common_cells
   primitive (e.g. `popcount`, `onehot_to_bin`). (System functions inside SVA assertions are
   allowed.)
5. **Format.** Format every changed file under `design/` with `verible-verilog-format`,
   version `v0.0-4084-gf3e4d98b`, default options, except `design/cfg/*_config_pkg.sv`; no
   formatting suggestions allowed. Also run `util/sanitize/systemverilog/xlen_misuse.sh`.
6. **Configuration.** Every feature sits behind a field of `cva6_user_cfg_t`
   (`design/include/config_pkg.sv`), derived in `build_config()` and checked in `check_cfg()`.
   No `` `ifdef `` / `` `define `` for features.
7. **Parachute rule.** With the field at its parachute value, the design is bit-identical to the
   baseline and contains no extra logic. Use `generate` branches whose parachute side is the
   existing RTL, unchanged. New interfaces are tied off in the parachute. All existing
   configuration packages keep building and passing with the new field off.
8. **Stand-alone core.** `design/` compiles stand-alone (Verilator lint of
   `design/cva6dx_core.f` with `--top-module cva6dx_core`) for every configuration package.
9. **Reuse.** Prefer common_cells, `cva6dx_pkg`, CVFPU, HPDcache and the H-extension RTL over
   new code.
10. **Spec fidelity.** Architecture and parameters are frozen by the specification and the
    Decisions sheet. If the spec is ambiguous or contradicts the RTL, do not choose: record an
    Open decision and ask the design authority.
11. **Human review.** All generated RTL is reviewed by the design authority before the task is
    marked Done.

Rules 2–4 bind all new and modified code. Existing upstream code that does not meet them yet is
brought into compliance as decided by the design authority (Decisions row NEW-08).

## Definition of Done (every RTL task)

- Lint clean: Verilator `-Wall` (no new warnings against the baseline log) and verible.
- Unit testbench and SVA for the structure; the chapter's verification-point tests in the unit
  testbench and CI.
- riscv-arch-test pass; Spike tandem clean on riscv-dv seeds; Linux boot regression in Verilator.
- Parachute regression: all existing configurations bit-identical with the new field off.
- PMU events of the structure wired.
- Area/timing of the block checked against the physical-design budget when the block is on a
  critical path.
- Human review done.

## Evidence

Every number in a commit message, report or note carries a tag: `[RTL] file:lines@commit`,
`[CITED] source`, `[MEASURED] run/log`, `[ESTIMATE] <derivation>`. Logs that back a
`[MEASURED]` number are kept in the docs repository under `notebook/evidence/<task-id>/`.

## Commits and branches

- `dx/main` is the integration branch. One task = one topic branch `dx/<task-id>-<slug>`,
  merged into `dx/main` after review.
- Commit subject: `<task-id>: <imperative summary>` (e.g. `M02.01: add DX config package`).
- Nothing is pushed to upstream openhwgroup/cva6 and no upstream PR is opened without the
  design authority's approval.
