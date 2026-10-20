// Copyright 2018 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the "License"); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
// Author: Florian Zaruba, ETH Zurich
// Date: 12.11.2017

// --------------
// AXI Arbiter
// --------------
//
// Description: Arbitrates access to AXI refill/bypass
//
module cva6dx_axi_adapter_arbiter #(
    parameter NR_PORTS = 4,
    parameter MAX_OUTSTANDING_REQ = 0,
    parameter type req_t = cva6dx_std_cache_pkg::bypass_req_t,
    parameter type rsp_t = cva6dx_std_cache_pkg::bypass_rsp_t
) (
    input  logic                clk_i,   // Clock
    input  logic                rst_ni,  // Asynchronous reset active low
    // Master ports
    input  req_t [NR_PORTS-1:0] req_i,
    output rsp_t [NR_PORTS-1:0] rsp_o,
    // Slave port
    output req_t                req_o,
    input  rsp_t                rsp_i
);

  localparam MAX_OUTSTANDING_CNT_WIDTH = $clog2(
      MAX_OUTSTANDING_REQ + 1
  ) > 0 ? $clog2(
      MAX_OUTSTANDING_REQ + 1
  ) : 1;

  typedef logic [MAX_OUTSTANDING_CNT_WIDTH-1:0] outstanding_cnt_t;

  enum logic {
    IDLE,
    SERVING
  }
      state_d, state_q;

  req_t req_d, req_q;
  logic [NR_PORTS-1:0] sel_d, sel_q;
  outstanding_cnt_t outstanding_cnt_d, outstanding_cnt_q;

  logic [NR_PORTS-1:0] req_flat;
  logic any_unselected_port_valid;

  for (genvar i = 0; i < NR_PORTS; i++) begin : gen_req_flat
    assign req_flat[i] = req_i[i].req;
  end
  assign any_unselected_port_valid = |(req_flat & ~(1 << sel_q));


  always_comb begin
    sel_d = sel_q;
    outstanding_cnt_d = outstanding_cnt_q;

    state_d = state_q;
    req_d = req_q;

    req_o = req_q;

    rsp_o = '0;
    rsp_o[sel_q].rdata = rsp_i.rdata;

    case (state_q)

      IDLE: begin
        // wait for incoming requests
        for (int unsigned i = 0; i < NR_PORTS; i++) begin
          if (req_i[i].req == 1'b1) begin
            sel_d   = i[$bits(sel_d)-1:0];
            state_d = SERVING;
            break;
          end
        end

        req_d = req_i[sel_d];
        req_o = req_i[sel_d];
        rsp_o[sel_d].gnt = req_i[sel_d].req;

        // Count outstanding transactions, i.e. requests which have been
        // granted but response hasn't arrived yet
        if (req_o.req && rsp_i.gnt) begin
          req_d.req = 1'b0;
          outstanding_cnt_d += 1;
        end
      end

      SERVING: begin
        // We can accept multiple outstanding transactions from same port.
        // To ensure fairness, we allow this only if all other ports are idle
        if ((!req_o.req) && !any_unselected_port_valid &&
          (outstanding_cnt_q != (MAX_OUTSTANDING_REQ - 1))) begin
          if (req_i[sel_q].req) begin
            req_d = req_i[sel_q];
            req_o = req_i[sel_q];
            rsp_o[sel_q].gnt = 1'b1;
            state_d = SERVING;
          end
        end

        // Count outstanding transactions, i.e. requests which have been
        // granted but response hasn't arrived yet
        if (req_o.req && rsp_i.gnt) begin
          req_d.req = 1'b0;
          outstanding_cnt_d += 1;
        end
        if (rsp_i.valid) begin
          outstanding_cnt_d -= 1;
          rsp_o[sel_q].valid = 1'b1;

          if ((outstanding_cnt_d == 0) && (!req_o.req || rsp_i.gnt)) state_d = IDLE;
        end
      end

      default:  /* default */;
    endcase
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (~rst_ni) begin
      state_q           <= IDLE;
      sel_q             <= '0;
      req_q             <= '0;
      outstanding_cnt_q <= '0;
    end else begin
      state_q           <= state_d;
      sel_q             <= sel_d;
      req_q             <= req_d;
      outstanding_cnt_q <= outstanding_cnt_d;
    end
  end
  // ------------
  // Assertions
  // ------------

  //pragma translate_off
`ifndef VERILATOR
  // make sure that we eventually get an rvalid after we received a grant
  assert property (@(posedge clk_i) rsp_i.gnt |-> ##[1:$] rsp_i.valid)
  else begin
    $error("There was a grant without a rvalid");
    $stop();
  end
  // assert that there is no grant without a request or outstanding transactions
  assert property (@(negedge clk_i) rsp_i.gnt |-> req_o.req)
  else begin
    $error("There was a grant without a request.");
    $stop();
  end
  // assert that the address does not contain X when request is sent
  assert property (@(posedge clk_i) (req_o.req) |-> (!$isunknown(req_o.addr)))
  else begin
    $error("address contains X when request is set");
    $stop();
  end

`endif
  //pragma translate_on
endmodule
