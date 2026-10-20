ROOT := ../../..
BUILD := .build/mstatus_wpri_test

SOURCES := \
	$(ROOT)/design/include/config_pkg.sv \
	$(ROOT)/design/cfg/cv64a6_imafdc_sv39_config_pkg.sv \
	$(ROOT)/design/include/build_config_pkg.sv \
	$(ROOT)/design/include/cva6dx_riscv_pkg.sv \
	$(ROOT)/design/include/cva6dx_pkg.sv \
	$(ROOT)/design/include/cva6dx_triggers_pkg.sv \
	$(ROOT)/design/csr/cva6dx_trigger_module.sv \
	$(ROOT)/design/csr/cva6dx_csr_regfile.sv \
	mstatus_wpri_test.sv

.PHONY: mstatus_wpri_test
mstatus_wpri_test:
	mkdir -p .build
	verilator --binary --assert --timing -Wno-fatal -Wno-PINMISSING -Wno-WIDTHTRUNC -Wno-WIDTHEXPAND -Wno-MULTIDRIVEN -I$(ROOT)/design/include --top-module mstatus_wpri_test --Mdir $(BUILD) $(SOURCES)
	$(BUILD)/Vmstatus_wpri_test
