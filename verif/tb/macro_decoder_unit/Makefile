ROOT := ../../..
BUILD := .build/macro_decoder_issue_ack_test

SOURCES := \
	$(ROOT)/design/include/config_pkg.sv \
	$(ROOT)/design/cfg/cv32a6_imac_sv32_config_pkg.sv \
	$(ROOT)/design/include/build_config_pkg.sv \
	$(ROOT)/design/include/cva6dx_riscv_pkg.sv \
	$(ROOT)/design/decode/cva6dx_macro_decoder.sv \
	macro_decoder_issue_ack_test.sv

.PHONY: all macro_decoder_issue_ack_test clean

all: macro_decoder_issue_ack_test

macro_decoder_issue_ack_test:
	mkdir -p .build
	verilator \
		--binary \
		--assert \
		--timing \
		-Wno-fatal \
		-Wno-PINMISSING \
		-Wno-WIDTHTRUNC \
		-Wno-WIDTHEXPAND \
		-I$(ROOT)/design/include \
		--top-module macro_decoder_issue_ack_test \
		--Mdir $(BUILD) \
		$(SOURCES)
	$(BUILD)/Vmacro_decoder_issue_ack_test

clean:
	rm -rf .build
