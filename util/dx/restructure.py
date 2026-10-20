#!/usr/bin/env python3
# Copyright 2026 10xEngineers.
# SPDX-License-Identifier: Apache-2.0
"""One-time restructure of the upstream CVA6 tree (81245a47f) into the CVA6-DX layout.

Decision ADR-DX-007 / Decisions row NEW-07 (option B): core RTL moves from core/ to
design/<unit>/, one module per file, file name = module name, every core module and package
renamed with the cva6dx_ prefix; vendored IP (HPDcache, CVFPU) moves to ip/; the CV-X-IF
example coprocessor to examples/cvxif/; the PMP unit test to verif/tb/pmp/.

The change is purely mechanical (paths and identifiers). Run once from the repository root on
a clean tree:   python3 util/dx/restructure.py --apply
Without --apply it only writes util/dx/rename_map.csv and prints the plan.
"""
import argparse
import csv
import os
import re
import subprocess
import sys

P = 'cva6dx_'
D = 'design'

# old file -> (unit directory under design/ ('' = design/ itself), new module name or None)
UNIT = {
    'core/cva6.sv': ('', P + 'core'),
    'core/commit_stage.sv': ('commit', None), 'core/controller.sv': ('commit', None),
    'core/frontend/frontend.sv': ('frontend', None), 'core/frontend/bht.sv': ('frontend', None),
    'core/frontend/bht2lvl.sv': ('frontend', None), 'core/frontend/btb.sv': ('frontend', None),
    'core/frontend/ras.sv': ('frontend', None), 'core/frontend/instr_queue.sv': ('frontend', None),
    'core/frontend/instr_scan.sv': ('frontend', None), 'core/instr_realign.sv': ('frontend', None),
    'core/id_stage.sv': ('decode', None), 'core/decoder.sv': ('decode', None),
    'core/compressed_decoder.sv': ('decode', None), 'core/macro_decoder.sv': ('decode', None),
    'core/zcmt_decoder.sv': ('decode', None),
    'core/cva6_accel_first_pass_decoder_stub.sv': ('decode', P + 'accel_first_pass_decoder'),
    'core/issue_stage.sv': ('issue', None), 'core/issue_read_operands.sv': ('issue', None),
    'core/scoreboard.sv': ('issue', None), 'core/raw_checker.sv': ('issue', None),
    'core/ariane_regfile_ff.sv': ('issue', P + 'regfile_ff'),
    'core/ariane_regfile_fpga.sv': ('issue', P + 'regfile_fpga'),
    'core/ex_stage.sv': ('execute', None), 'core/alu.sv': ('execute', None),
    'core/alu_wrapper.sv': ('execute', None), 'core/branch_unit.sv': ('execute', None),
    'core/mult.sv': ('execute', None), 'core/multiplier.sv': ('execute', None),
    'core/serdiv.sv': ('execute', None), 'core/fpu_wrap.sv': ('execute', None),
    'core/aes.sv': ('execute', None), 'core/csr_buffer.sv': ('execute', None),
    'core/load_store_unit.sv': ('lsu', P + 'lsu'), 'core/load_unit.sv': ('lsu', None),
    'core/store_unit.sv': ('lsu', None), 'core/store_buffer.sv': ('lsu', None),
    'core/amo_buffer.sv': ('lsu', None), 'core/lsu_bypass.sv': ('lsu', None),
    'core/axi_shim.sv': ('cache', None),
    'core/cva6_mmu/cva6_mmu.sv': ('mmu', None), 'core/cva6_mmu/cva6_ptw.sv': ('mmu', None),
    'core/cva6_mmu/cva6_tlb.sv': ('mmu', None), 'core/cva6_mmu/cva6_shared_tlb.sv': ('mmu', None),
    'core/pmp/src/pmp.sv': ('mmu', None), 'core/pmp/src/pmp_entry.sv': ('mmu', None),
    'core/pmp/src/pmp_data_if.sv': ('mmu', None),
    'core/csr_regfile.sv': ('csr', None), 'core/trigger_module.sv': ('csr', None),
    'core/perf_counters.sv': ('pmu', None),
    'core/cvxif_fu.sv': ('cvxif', None), 'core/acc_dispatcher.sv': ('cvxif', None),
    'core/cvxif_compressed_if_driver.sv': ('cvxif', None),
    'core/cvxif_issue_register_commit_if_driver.sv': ('cvxif', None),
    'core/cva6_fifo_v3.sv': ('prim', None),
    'core/cva6_rvfi.sv': ('rvfi', None), 'core/cva6_rvfi_probes.sv': ('rvfi', None),
}
# packages: names kept where v3.1, the plan and the project rules use them
PKG_KEEP = {'config_pkg', 'build_config_pkg', 'cva6_config_pkg', 'l15_pkg', 'cvxif_instr_pkg'}
PKG_NEW = {'ariane_pkg': P + 'pkg', 'riscv': P + 'riscv_pkg', 'aes_pkg': P + 'aes_pkg',
           'instr_tracer_pkg': P + 'instr_tracer_pkg', 'triggers_pkg': P + 'triggers_pkg',
           'std_cache_pkg': P + 'std_cache_pkg', 'wt_cache_pkg': P + 'wt_cache_pkg'}
# directories (and other non-.sv items), old prefix -> new prefix
DIRS = [
    ('core/cache_subsystem/hpdcache', 'ip/hpdcache'),
    ('core/cvfpu', 'ip/cvfpu'),
    ('core/cvxif_example', 'examples/cvxif'),
    ('core/include/deprecated_packages', f'{D}/cfg/deprecated'),
    ('core/pmp/include/riscv.sv', 'verif/tb/pmp/include/riscv.sv'),
    ('core/pmp/tb', 'verif/tb/pmp/tb'),
    ('core/pmp/Bender.yml', 'verif/tb/pmp/Bender.yml'),
    ('core/pmp/Makefile', 'verif/tb/pmp/Makefile'),
    ('core/pmp/formal.sby', 'verif/tb/pmp/formal.sby'),
    ('core/pmp/README.md', 'verif/tb/pmp/README.md'),
    ('core/pmp/src', f'{D}/mmu'),
    ('core/pmp', 'verif/tb/pmp'),
    ('core/include/cvxif_types.svh', f'{D}/include/cvxif_types.svh'),
    ('core/include/rvfi_types.svh', f'{D}/include/rvfi_types.svh'),
    ('core/include', f'{D}/include'),
    ('core/frontend', f'{D}/frontend'),
    ('core/cva6_mmu', f'{D}/mmu'),
    ('core/cache_subsystem', f'{D}/cache'),
    ('core/Flist.cva6_gate', f'{D}/cva6dx_core_gate.f'),
    ('core/Flist.cva6', f'{D}/cva6dx_core.f'),
]
CFG_RE = re.compile(r'^[^\s"\'/]*config_pkg[^\s"\'/]*\.sv')
DECL = re.compile(r'^\s*(module|package|interface)\s+([A-Za-z0-9_]+)', re.M)


def new_name(old):
    return P + old[len('cva6_'):] if old.startswith('cva6_') else P + old


def build_map():
    """Rows: old_path, old_name, new_path, new_name, kind."""
    rows = []
    for root, _, files in os.walk('core'):
        if root.startswith(('core/cache_subsystem/hpdcache', 'core/cvfpu', 'core/pmp/tb',
                            'core/cvxif_example', 'core/cva6_mmu/xsim.dir')):
            continue
        for f in sorted(files):
            if not f.endswith('.sv'):
                continue
            path = os.path.join(root, f)
            for kind, name in DECL.findall(open(path, encoding='utf-8').read()):
                if path.startswith('core/include/') and kind == 'package':
                    nn = name if name in PKG_KEEP else PKG_NEW[name]
                    if name == 'cva6_config_pkg':
                        sub = 'cfg/deprecated' if 'deprecated_packages' in path else 'cfg'
                        rows.append((path, name, f'{D}/{sub}/{f}', nn, 'cfg'))
                    else:
                        fn = f if nn == name else nn + '.sv'
                        rows.append((path, name, f'{D}/include/{fn}', nn, 'package'))
                elif path == 'core/pmp/include/riscv.sv':
                    rows.append((path, name, 'verif/tb/pmp/include/riscv.sv', PKG_NEW[name],
                                 'package'))
                elif path.startswith('core/cache_subsystem/'):
                    nn = new_name(name)
                    rows.append((path, name, f'{D}/cache/{nn}.sv', nn, kind))
                else:
                    unit, nn = UNIT[path]
                    nn = nn or new_name(name)
                    d = f'{D}/{unit}/' if unit else f'{D}/'
                    rows.append((path, name, f'{d}{nn}.sv', nn, kind))
    names = [r[3] for r in rows if r[4] != 'cfg' and not r[2].startswith('verif/')]
    dup = sorted({n for n in names if names.count(n) > 1})
    if dup:
        sys.exit(f'duplicate new names: {dup}')
    return rows


def path_pairs(rows):
    files = {}
    for r in rows:  # first declaration of a file decides its new path
        files.setdefault(r[0], r[2])
    dirs = {}
    for o, n in DIRS:
        (files if os.path.isfile(o) else dirs).setdefault(o, n)
    key = lambda x: -len(x[0])
    return sorted(files.items(), key=key), sorted(dirs.items(), key=key)


PATH_RE = re.compile(r'(?<![A-Za-z0-9_-]/)(?<![A-Za-z0-9_.])core/([A-Za-z0-9_./*\\${}()-]*)')


CONT = re.compile(r'[A-Za-z0-9_.-]')


def rewrite_paths(text, pairs, unmatched):
    """pairs = (file_pairs, dir_pairs), each sorted longest first."""
    file_pairs, dir_pairs = pairs

    def hit(full, o):
        return full == o or (full.startswith(o) and not CONT.match(full[len(o)]))

    def sub(m):
        rest = m.group(1)
        full = 'core/' + rest
        for o, n in file_pairs:
            if hit(full, o):
                return n + full[len(o):]
        if rest.startswith('include/') and CFG_RE.match(rest[len('include/'):]):
            return f'{D}/cfg/' + rest[len('include/'):]
        for o, n in dir_pairs:
            if hit(full, o):
                return n + full[len(o):]
        if rest == '' or rest.startswith('*'):
            return f'{D}/' + rest
        unmatched.add(full)
        return m.group(0)
    return PATH_RE.sub(sub, text)


def rewrite_names(text, modules, packages):
    mod_alt = '|'.join(sorted(modules, key=len, reverse=True))
    # declarations and end labels
    text = re.sub(r'(\b(?:module|interface)\s+)(' + mod_alt + r')\b',
                  lambda m: m.group(1) + modules[m.group(2)], text)
    text = re.sub(r'(\bend(?:module|interface)\s*:\s*)(' + mod_alt + r')\b',
                  lambda m: m.group(1) + modules[m.group(2)], text)
    # instantiations: <type> #(  or  <type> <inst> [ranges] (
    inst = re.compile(r'(^[ \t]*)(' + mod_alt + r')\b(?=\s*#|\s+[A-Za-z_]\w*\s*(?:\[[^\]]*\]\s*)*\()',
                      re.M)
    text = inst.sub(lambda m: m.group(1) + modules[m.group(2)], text)
    # packages: every identifier use (declaration, import, scope, end label)
    pkg_alt = '|'.join(sorted(packages, key=len, reverse=True))
    text = re.sub(r'(?<![A-Za-z0-9_$])(' + pkg_alt + r')(?=\s*::)',
                  lambda m: packages[m.group(1)], text)
    text = re.sub(r'(\b(?:package|import|endpackage\s*:)\s+)(' + pkg_alt + r')\b',
                  lambda m: m.group(1) + packages[m.group(2)], text)
    return text


def tracked_files():
    out = subprocess.run(['git', 'ls-files', '-s'], capture_output=True, text=True, check=True)
    files = []
    for line in out.stdout.splitlines():
        mode, _, _, path = line.split(None, 3)
        if mode != '160000':  # skip submodule entries
            files.append(path)
    return files


SKIP_TEXT = ('.gitmodules', 'CHANGELOG.md')
SKIP_DIRS = ('util/dx/', 'vendor/')


def skipped(path):
    if path in SKIP_TEXT or path.startswith(SKIP_DIRS):
        return True
    return path.startswith('docs/') and not path.startswith('docs/scripts/')
SV_EXT = ('.sv', '.svh', '.v', '.vh')


def split_miss_handler():
    """miss_handler.sv declares two modules; move axi_adapter_arbiter to its own file."""
    src = f'{D}/cache/{P}miss_handler.sv'
    lines = open(src, encoding='utf-8').read().split('\n')
    cut = lines.index('// AXI Arbiter') - 1
    assert lines[cut] == '// --------------', lines[cut]
    lic = lines[:lines.index('// Description: Handles cache misses.')]
    first = '\n'.join(lines[:cut]).rstrip('\n') + '\n'
    second = '\n'.join(lic) + '\n\n' + '\n'.join(lines[cut:])
    open(src, 'w', encoding='utf-8').write(first)
    open(f'{D}/cache/{P}axi_adapter_arbiter.sv', 'w', encoding='utf-8').write(second)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--apply', action='store_true')
    args = ap.parse_args()
    rows = build_map()
    os.makedirs('util/dx', exist_ok=True)
    with open('util/dx/rename_map.csv', 'w', newline='') as f:
        w = csv.writer(f)
        w.writerow(['old_path', 'old_name', 'new_path', 'new_name', 'kind'])
        w.writerows(rows)
    modules = {r[1]: r[3] for r in rows if r[4] in ('module', 'interface') and r[1] != r[3]}
    packages = {r[1]: r[3] for r in rows if r[4] == 'package' and r[1] != r[3]}
    pairs = path_pairs(rows)
    print(f'{len(rows)} declarations, {len(modules)} module renames, {len(packages)} package renames')
    if not args.apply:
        return

    # 1. moves (git mv keeps history; submodules handled by git mv)
    moved = set()
    def mv(old, new):
        os.makedirs(os.path.dirname(new) or '.', exist_ok=True)
        subprocess.run(['git', 'mv', old, new], check=True)
        moved.add(old)
    mv('core/cache_subsystem/hpdcache', 'ip/hpdcache')
    mv('core/cvfpu', 'ip/cvfpu')
    first_of = {}
    for r in rows:
        first_of.setdefault(r[0], r)
    for old, r in first_of.items():
        if old == 'core/cache_subsystem/miss_handler.sv':
            mv(old, f'{D}/cache/{P}miss_handler.sv')
        else:
            mv(old, r[2])
    for o, n in DIRS:
        tracked = subprocess.run(['git', 'ls-files', o], capture_output=True, text=True).stdout
        if tracked.strip() and o not in moved:
            mv(o, n)
    subprocess.run(['git', 'rm', '-r', '-q', '--cached', 'core/cva6_mmu/xsim.dir'], check=False)
    subprocess.run(['rm', '-rf', 'core/cva6_mmu/xsim.dir'], check=True)

    # 2. text rewrite of every tracked non-submodule file
    unmatched = set()
    changed = 0
    for path in tracked_files():
        if skipped(path) or not os.path.isfile(path):
            continue
        try:
            text = open(path, encoding='utf-8').read()
        except UnicodeDecodeError:
            continue
        new = rewrite_paths(text, pairs, unmatched) if 'core/' in text else text
        if path.endswith(SV_EXT) or path.endswith('.vlt'):
            new = rewrite_names(new, modules, packages)
        if new != text:
            open(path, 'w', encoding='utf-8').write(new)
            changed += 1
    split_miss_handler()

    # 3. flow files that name the top module
    for path, old, new in [('pd/synth/Makefile', 'DESIGN_NAME          ?= cva6\n',
                            'DESIGN_NAME          ?= cva6dx_core\n'),
                           ('spyglass/Makefile', 'TOP= cva6\n', 'TOP= cva6dx_core\n')]:
        t = open(path).read()
        if old in t:
            open(path, 'w').write(t.replace(old, new))
    subprocess.run(['git', 'add', '-A', D, 'ip', 'examples', 'verif', 'util/dx'], check=True)
    print(f'rewrote {changed} files; unmatched core/ references: {len(unmatched)}')
    for u in sorted(unmatched):
        print('  unmatched:', u)


if __name__ == '__main__':
    main()
