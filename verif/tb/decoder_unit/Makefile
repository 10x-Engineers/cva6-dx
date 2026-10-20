ROOT := ../../..
BUILD := .build/zicbom_permissions_test

SOURCES := \
	$(ROOT)/design/include/config_pkg.sv \
	$(ROOT)/design/cfg/cv64a6_imafdch_sv39_config_pkg.sv \
	$(ROOT)/design/include/build_config_pkg.sv \
	$(ROOT)/design/include/cva6dx_riscv_pkg.sv \
	$(ROOT)/design/include/cva6dx_pkg.sv \
	$(ROOT)/design/decode/cva6dx_decoder.sv \
	zicbom_permissions_test.sv

.PHONY: zicbom_permissions_test
zicbom_permissions_test:
	mkdir -p .build
	verilator --binary --assert --timing \
		-Wno-fatal \
		-Wno-PINMISSING \
		-Wno-UNOPTFLAT \
		-Wno-WIDTHTRUNC \
		-Wno-WIDTHEXPAND \
		-I$(ROOT)/design/include \
		--top-module zicbom_permissions_test \
		--Mdir $(BUILD) \
		$(SOURCES)
	$(BUILD)/Vzicbom_permissions_test
