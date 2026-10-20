//////////////////////////////////////////////////////////////////////////////
//
// Copyright 2021 OpenHW Group
//
// Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://solderpad.org/licenses/
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.0
//
///////////////////////////////////////////////////////////////////////////////
//
// Manifest for the CVA6 CORE RTL model.
//   - This is a CORE-ONLY manifest.
//   - Relevant synthesis and simulation scripts/Makefiles must set the shell
//     ENV variable CVA6_REPO_DIR.
//
///////////////////////////////////////////////////////////////////////////////

//FPGA memories
${CVA6_REPO_DIR}/vendor/pulp-platform/fpga-support/rtl/SyncDpRam.sv
${CVA6_REPO_DIR}/vendor/pulp-platform/fpga-support/rtl/AsyncDpRam.sv
${CVA6_REPO_DIR}/vendor/pulp-platform/fpga-support/rtl/AsyncThreePortRam.sv
${CVA6_REPO_DIR}/vendor/pulp-platform/fpga-support/rtl/SyncThreePortRam.sv
${CVA6_REPO_DIR}/vendor/pulp-platform/fpga-support/rtl/SyncDpRam_ind_r_w.sv

+incdir+${CVA6_REPO_DIR}/design/include/
+incdir+${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/include/
+incdir+${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/
+incdir+${CVA6_REPO_DIR}/vendor/pulp-platform/axi/include/
+incdir+${CVA6_REPO_DIR}/common/local/util/
+incdir+${HPDCACHE_DIR}/rtl/src/utils/ecc

// Floating point unit
${CVA6_REPO_DIR}/ip/cvfpu/src/fpnew_pkg.sv
${CVA6_REPO_DIR}/ip/cvfpu/src/fpnew_cast_multi.sv
${CVA6_REPO_DIR}/ip/cvfpu/src/fpnew_classifier.sv
${CVA6_REPO_DIR}/ip/cvfpu/vendor/opene906/E906_RTL_FACTORY/gen_rtl/clk/rtl/gated_clk_cell.v
${CVA6_REPO_DIR}/ip/cvfpu/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_ctrl.v
${CVA6_REPO_DIR}/ip/cvfpu/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_ff1.v
${CVA6_REPO_DIR}/ip/cvfpu/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_pack_single.v
${CVA6_REPO_DIR}/ip/cvfpu/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_prepare.v
${CVA6_REPO_DIR}/ip/cvfpu/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_round_single.v
${CVA6_REPO_DIR}/ip/cvfpu/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_special.v
${CVA6_REPO_DIR}/ip/cvfpu/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_srt_single.v
${CVA6_REPO_DIR}/ip/cvfpu/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_top.v
${CVA6_REPO_DIR}/ip/cvfpu/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fpu/rtl/pa_fpu_dp.v
${CVA6_REPO_DIR}/ip/cvfpu/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fpu/rtl/pa_fpu_frbus.v
${CVA6_REPO_DIR}/ip/cvfpu/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fpu/rtl/pa_fpu_src_type.v
${CVA6_REPO_DIR}/ip/cvfpu/vendor/openc910/C910_RTL_FACTORY/gen_rtl/vfdsu/rtl/ct_vfdsu_ctrl.v
${CVA6_REPO_DIR}/ip/cvfpu/vendor/openc910/C910_RTL_FACTORY/gen_rtl/vfdsu/rtl/ct_vfdsu_double.v
${CVA6_REPO_DIR}/ip/cvfpu/vendor/openc910/C910_RTL_FACTORY/gen_rtl/vfdsu/rtl/ct_vfdsu_ff1.v
${CVA6_REPO_DIR}/ip/cvfpu/vendor/openc910/C910_RTL_FACTORY/gen_rtl/vfdsu/rtl/ct_vfdsu_pack.v
${CVA6_REPO_DIR}/ip/cvfpu/vendor/openc910/C910_RTL_FACTORY/gen_rtl/vfdsu/rtl/ct_vfdsu_prepare.v
${CVA6_REPO_DIR}/ip/cvfpu/vendor/openc910/C910_RTL_FACTORY/gen_rtl/vfdsu/rtl/ct_vfdsu_round.v
${CVA6_REPO_DIR}/ip/cvfpu/vendor/openc910/C910_RTL_FACTORY/gen_rtl/vfdsu/rtl/ct_vfdsu_scalar_dp.v
${CVA6_REPO_DIR}/ip/cvfpu/vendor/openc910/C910_RTL_FACTORY/gen_rtl/vfdsu/rtl/ct_vfdsu_srt_radix16_bound_table.v
${CVA6_REPO_DIR}/ip/cvfpu/vendor/openc910/C910_RTL_FACTORY/gen_rtl/vfdsu/rtl/ct_vfdsu_srt_radix16_with_sqrt.v
${CVA6_REPO_DIR}/ip/cvfpu/vendor/openc910/C910_RTL_FACTORY/gen_rtl/vfdsu/rtl/ct_vfdsu_srt.v
${CVA6_REPO_DIR}/ip/cvfpu/vendor/openc910/C910_RTL_FACTORY/gen_rtl/vfdsu/rtl/ct_vfdsu_top.v
${CVA6_REPO_DIR}/ip/cvfpu/src/fpnew_divsqrt_th_32.sv
${CVA6_REPO_DIR}/ip/cvfpu/src/fpnew_divsqrt_th_64_multi.sv
${CVA6_REPO_DIR}/ip/cvfpu/src/fpnew_divsqrt_multi.sv
${CVA6_REPO_DIR}/ip/cvfpu/src/fpnew_fma_multi.sv
${CVA6_REPO_DIR}/ip/cvfpu/src/fpnew_fma.sv
${CVA6_REPO_DIR}/ip/cvfpu/src/fpnew_noncomp.sv
${CVA6_REPO_DIR}/ip/cvfpu/src/fpnew_opgroup_block.sv
${CVA6_REPO_DIR}/ip/cvfpu/src/fpnew_opgroup_fmt_slice.sv
${CVA6_REPO_DIR}/ip/cvfpu/src/fpnew_opgroup_multifmt_slice.sv
${CVA6_REPO_DIR}/ip/cvfpu/src/fpnew_rounding.sv
${CVA6_REPO_DIR}/ip/cvfpu/src/fpnew_top.sv
${CVA6_REPO_DIR}/ip/cvfpu/src/fpu_div_sqrt_mvp/hdl/defs_div_sqrt_mvp.sv
${CVA6_REPO_DIR}/ip/cvfpu/src/fpu_div_sqrt_mvp/hdl/control_mvp.sv
${CVA6_REPO_DIR}/ip/cvfpu/src/fpu_div_sqrt_mvp/hdl/div_sqrt_top_mvp.sv
${CVA6_REPO_DIR}/ip/cvfpu/src/fpu_div_sqrt_mvp/hdl/iteration_div_sqrt_mvp.sv
${CVA6_REPO_DIR}/ip/cvfpu/src/fpu_div_sqrt_mvp/hdl/norm_div_sqrt_mvp.sv
${CVA6_REPO_DIR}/ip/cvfpu/src/fpu_div_sqrt_mvp/hdl/nrbd_nrsc_mvp.sv
${CVA6_REPO_DIR}/ip/cvfpu/src/fpu_div_sqrt_mvp/hdl/preprocess_mvp.sv

${CVA6_REPO_DIR}/design/include/config_pkg.sv
${CVA6_REPO_DIR}/design/cfg/${TARGET_CFG}_config_pkg.sv
${CVA6_REPO_DIR}/design/include/cva6dx_riscv_pkg.sv
// Note: depends on fpnew_pkg, above
${CVA6_REPO_DIR}/design/include/cva6dx_pkg.sv
${CVA6_REPO_DIR}/vendor/pulp-platform/axi/src/axi_pkg.sv

// Packages
${CVA6_REPO_DIR}/design/include/cva6dx_wt_cache_pkg.sv
${CVA6_REPO_DIR}/design/include/cva6dx_std_cache_pkg.sv
${CVA6_REPO_DIR}/design/include/cva6dx_instr_tracer_pkg.sv
${CVA6_REPO_DIR}/design/include/build_config_pkg.sv
${CVA6_REPO_DIR}/design/include/cva6dx_aes_pkg.sv
${CVA6_REPO_DIR}/design/include/cva6dx_triggers_pkg.sv

//CVXIF
${CVA6_REPO_DIR}/design/cvxif/cva6dx_cvxif_compressed_if_driver.sv
${CVA6_REPO_DIR}/design/cvxif/cva6dx_cvxif_issue_register_commit_if_driver.sv
${CVA6_REPO_DIR}/examples/cvxif/include/cvxif_instr_pkg.sv
${CVA6_REPO_DIR}/design/cvxif/cva6dx_cvxif_fu.sv
${CVA6_REPO_DIR}/examples/cvxif/cvxif_example_coprocessor.sv
${CVA6_REPO_DIR}/examples/cvxif/instr_decoder.sv
${CVA6_REPO_DIR}/examples/cvxif/compressed_instr_decoder.sv
${CVA6_REPO_DIR}/examples/cvxif/copro_alu.sv

// Common Cells
${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/cf_math_pkg.sv
${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/fifo_v3.sv
${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/lfsr.sv
${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/lfsr_8bit.sv
${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/stream_arbiter.sv
${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/stream_arbiter_flushable.sv
${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/stream_mux.sv
${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/stream_demux.sv
${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/lzc.sv
${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/rr_arb_tree.sv
${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/shift_reg.sv
${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/unread.sv
${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/popcount.sv
${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/exp_backoff.sv

// Common Cells for example coprocessor
${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/counter.sv
${CVA6_REPO_DIR}/vendor/pulp-platform/common_cells/src/delta_counter.sv

// Top-level source files (not necessarily instantiated at the top of the cva6).
${CVA6_REPO_DIR}/design/cva6dx_core.sv
${CVA6_REPO_DIR}/design/rvfi/cva6dx_rvfi_probes.sv
${CVA6_REPO_DIR}/design/execute/cva6dx_alu.sv
${CVA6_REPO_DIR}/design/execute/cva6dx_alu_wrapper.sv
${CVA6_REPO_DIR}/design/execute/cva6dx_aes.sv
// Note: depends on fpnew_pkg, above
${CVA6_REPO_DIR}/design/execute/cva6dx_fpu_wrap.sv
${CVA6_REPO_DIR}/design/execute/cva6dx_branch_unit.sv
${CVA6_REPO_DIR}/design/decode/cva6dx_compressed_decoder.sv
${CVA6_REPO_DIR}/design/decode/cva6dx_macro_decoder.sv
${CVA6_REPO_DIR}/design/commit/cva6dx_controller.sv
${CVA6_REPO_DIR}/design/decode/cva6dx_zcmt_decoder.sv
${CVA6_REPO_DIR}/design/execute/cva6dx_csr_buffer.sv
${CVA6_REPO_DIR}/design/csr/cva6dx_csr_regfile.sv
${CVA6_REPO_DIR}/design/csr/cva6dx_trigger_module.sv
${CVA6_REPO_DIR}/design/decode/cva6dx_decoder.sv
${CVA6_REPO_DIR}/design/execute/cva6dx_ex_stage.sv
${CVA6_REPO_DIR}/design/frontend/cva6dx_instr_realign.sv
${CVA6_REPO_DIR}/design/decode/cva6dx_id_stage.sv
${CVA6_REPO_DIR}/design/issue/cva6dx_issue_read_operands.sv
${CVA6_REPO_DIR}/design/issue/cva6dx_issue_stage.sv
${CVA6_REPO_DIR}/design/lsu/cva6dx_load_unit.sv
${CVA6_REPO_DIR}/design/lsu/cva6dx_lsu.sv
${CVA6_REPO_DIR}/design/lsu/cva6dx_lsu_bypass.sv
${CVA6_REPO_DIR}/design/execute/cva6dx_mult.sv
${CVA6_REPO_DIR}/design/execute/cva6dx_multiplier.sv
${CVA6_REPO_DIR}/design/execute/cva6dx_serdiv.sv
${CVA6_REPO_DIR}/design/pmu/cva6dx_perf_counters.sv
${CVA6_REPO_DIR}/design/issue/cva6dx_regfile_ff.sv
${CVA6_REPO_DIR}/design/issue/cva6dx_regfile_fpga.sv
// NOTE: scoreboard.sv modified for DSIM (unchanged for other simulators)
${CVA6_REPO_DIR}/design/issue/cva6dx_scoreboard.sv
${CVA6_REPO_DIR}/design/issue/cva6dx_raw_checker.sv
${CVA6_REPO_DIR}/design/lsu/cva6dx_store_buffer.sv
${CVA6_REPO_DIR}/design/lsu/cva6dx_amo_buffer.sv
${CVA6_REPO_DIR}/design/lsu/cva6dx_store_unit.sv
${CVA6_REPO_DIR}/design/commit/cva6dx_commit_stage.sv
${CVA6_REPO_DIR}/design/cache/cva6dx_axi_shim.sv
${CVA6_REPO_DIR}/design/decode/cva6dx_accel_first_pass_decoder.sv
${CVA6_REPO_DIR}/design/cvxif/cva6dx_acc_dispatcher.sv
${CVA6_REPO_DIR}/design/prim/cva6dx_fifo_v3.sv

// What is "frontend"?
${CVA6_REPO_DIR}/design/frontend/cva6dx_btb.sv
${CVA6_REPO_DIR}/design/frontend/cva6dx_bht.sv
${CVA6_REPO_DIR}/design/frontend/cva6dx_bht2lvl.sv
${CVA6_REPO_DIR}/design/frontend/cva6dx_ras.sv
${CVA6_REPO_DIR}/design/frontend/cva6dx_instr_scan.sv
${CVA6_REPO_DIR}/design/frontend/cva6dx_instr_queue.sv
${CVA6_REPO_DIR}/design/frontend/cva6dx_frontend.sv

// Cache subsystem
${CVA6_REPO_DIR}/design/cache/cva6dx_wt_dcache_ctrl.sv
${CVA6_REPO_DIR}/design/cache/cva6dx_wt_dcache_mem.sv
${CVA6_REPO_DIR}/design/cache/cva6dx_wt_dcache_missunit.sv
${CVA6_REPO_DIR}/design/cache/cva6dx_wt_dcache_wbuffer.sv
${CVA6_REPO_DIR}/design/cache/cva6dx_wt_dcache.sv
${CVA6_REPO_DIR}/design/cache/cva6dx_icache.sv
${CVA6_REPO_DIR}/design/cache/cva6dx_wt_cache_subsystem.sv
${CVA6_REPO_DIR}/design/cache/cva6dx_wt_axi_adapter.sv
${CVA6_REPO_DIR}/design/cache/cva6dx_tag_cmp.sv
${CVA6_REPO_DIR}/design/cache/cva6dx_axi_adapter.sv
${CVA6_REPO_DIR}/design/cache/cva6dx_miss_handler.sv
${CVA6_REPO_DIR}/design/cache/cva6dx_axi_adapter_arbiter.sv
${CVA6_REPO_DIR}/design/cache/cva6dx_cache_ctrl.sv
${CVA6_REPO_DIR}/design/cache/cva6dx_icache_axi_wrapper.sv
${CVA6_REPO_DIR}/design/cache/cva6dx_std_cache_subsystem.sv
${CVA6_REPO_DIR}/design/cache/cva6dx_std_nbdcache.sv
-F ${HPDCACHE_DIR}/rtl/hpdcache.Flist
${HPDCACHE_DIR}/rtl/src/utils/ecc/prim_secded_36_29_dec.sv
${HPDCACHE_DIR}/rtl/src/utils/ecc/prim_secded_36_29_enc.sv
${HPDCACHE_DIR}/rtl/src/utils/ecc/prim_secded_39_32_dec.sv
${HPDCACHE_DIR}/rtl/src/utils/ecc/prim_secded_39_32_enc.sv
${HPDCACHE_DIR}/rtl/src/utils/ecc/prim_secded_55_48_dec.sv
${HPDCACHE_DIR}/rtl/src/utils/ecc/prim_secded_55_48_enc.sv
${HPDCACHE_DIR}/rtl/src/utils/ecc/prim_secded_72_64_dec.sv
${HPDCACHE_DIR}/rtl/src/utils/ecc/prim_secded_72_64_enc.sv
${HPDCACHE_DIR}/rtl/src/utils/ecc/prim_secded_pkg.sv
${HPDCACHE_DIR}/rtl/src/utils/hpdcache_mem_resp_demux.sv
${HPDCACHE_DIR}/rtl/src/utils/hpdcache_mem_to_axi_read.sv
${HPDCACHE_DIR}/rtl/src/utils/hpdcache_mem_to_axi_write.sv
${CVA6_REPO_DIR}/design/include/dummy_l15_pkg.sv
${CVA6_REPO_DIR}/design/cache/cva6dx_hpdcache_subsystem.sv
${CVA6_REPO_DIR}/design/cache/cva6dx_hpdcache_subsystem_axi_arbiter.sv
${CVA6_REPO_DIR}/design/cache/cva6dx_hpdcache_if_adapter.sv
${CVA6_REPO_DIR}/design/cache/cva6dx_hpdcache_wrapper.sv
${HPDCACHE_DIR}/rtl/src/common/macros/behav/hpdcache_sram_1rw.sv
${HPDCACHE_DIR}/rtl/src/common/macros/behav/hpdcache_sram_wbyteenable_1rw.sv
${HPDCACHE_DIR}/rtl/src/common/macros/behav/hpdcache_sram_wmask_1rw.sv
${HPDCACHE_DIR}/rtl/src/common/macros/behav/hpdcache_sram_ecc_1rw.sv
${HPDCACHE_DIR}/rtl/src/common/macros/behav/hpdcache_sram_wbyteenable_ecc_1rw.sv
${HPDCACHE_DIR}/rtl/src/common/macros/behav/hpdcache_sram_wmask_ecc_1rw.sv

// Physical Memory Protection
// NOTE: pmp.sv modified for DSIM (unchanged for other simulators)
${CVA6_REPO_DIR}/design/mmu/cva6dx_pmp.sv
${CVA6_REPO_DIR}/design/mmu/cva6dx_pmp_entry.sv
${CVA6_REPO_DIR}/design/mmu/cva6dx_pmp_data_if.sv

// Tracer (behavioral code, not RTL)
${CVA6_REPO_DIR}/common/local/util/instr_tracer.sv
${CVA6_REPO_DIR}/common/local/util/tc_sram_wrapper.sv
${CVA6_REPO_DIR}/common/local/util/tc_sram_wrapper_cache_techno.sv
${CVA6_REPO_DIR}/vendor/pulp-platform/tech_cells_generic/src/rtl/tc_sram.sv
${CVA6_REPO_DIR}/common/local/util/sram.sv
${CVA6_REPO_DIR}/common/local/util/sram_cache.sv

// MMU 
${CVA6_REPO_DIR}/design/mmu/cva6dx_mmu.sv
${CVA6_REPO_DIR}/design/mmu/cva6dx_ptw.sv
${CVA6_REPO_DIR}/design/mmu/cva6dx_tlb.sv
${CVA6_REPO_DIR}/design/mmu/cva6dx_shared_tlb.sv

// end of manifest
