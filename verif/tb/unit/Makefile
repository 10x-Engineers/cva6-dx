VERILATOR ?= verilator
ROOT := ../../..
BUILD_ROOT ?= .build
TESTS := $(patsubst %.sv,%,$(notdir $(wildcard *_test.sv)))

.PHONY: all clean $(TESTS)

all: $(TESTS)

trigger_loadaddr_test:
	mkdir -p $(BUILD_ROOT)
	$(VERILATOR) --binary --assert --timing -Wno-fatal -Wno-WIDTHTRUNC -Wno-WIDTHEXPAND -Wno-MULTIDRIVEN --top-module $@ --Mdir $(BUILD_ROOT)/$@ $(ROOT)/design/include/config_pkg.sv $(ROOT)/design/cfg/cv64a6_imafdc_sv39_config_pkg.sv $(ROOT)/design/include/build_config_pkg.sv $(ROOT)/design/include/cva6dx_riscv_pkg.sv $(ROOT)/design/include/cva6dx_pkg.sv $(ROOT)/design/include/cva6dx_triggers_pkg.sv $(ROOT)/design/csr/cva6dx_trigger_module.sv $@.sv
	$(BUILD_ROOT)/$@/V$@

trigger_dmode_test:
	mkdir -p $(BUILD_ROOT)
	$(VERILATOR) --binary --assert --timing -Wno-fatal -Wno-WIDTHTRUNC -Wno-WIDTHEXPAND -Wno-MULTIDRIVEN --top-module $@ --Mdir $(BUILD_ROOT)/$@ $(ROOT)/design/include/config_pkg.sv $(ROOT)/design/cfg/cv64a6_imafdc_sv39_config_pkg.sv $(ROOT)/design/include/build_config_pkg.sv $(ROOT)/design/include/cva6dx_riscv_pkg.sv $(ROOT)/design/include/cva6dx_pkg.sv $(ROOT)/design/include/cva6dx_triggers_pkg.sv $(ROOT)/design/csr/cva6dx_trigger_module.sv $@.sv
	$(BUILD_ROOT)/$@/V$@

trigger_napot_test:
	mkdir -p $(BUILD_ROOT)
	$(VERILATOR) --binary --assert --timing --top-module $@ --Mdir $(BUILD_ROOT)/$@ $(ROOT)/design/include/cva6dx_triggers_pkg.sv $@.sv
	$(BUILD_ROOT)/$@/V$@

clean:
	rm -rf $(BUILD_ROOT)
