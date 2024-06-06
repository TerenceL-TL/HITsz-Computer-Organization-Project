// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Wed Feb 21 15:23:30 2024
// Host        : ZMJ-miniPC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/ZMJ-miniPC/Desktop/comp2008/axi_lite/axi_lite.srcs/sources_1/ip/fifo_generator_1/fifo_generator_1_stub.v
// Design      : fifo_generator_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tfgg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_3,Vivado 2018.3" *)
module fifo_generator_1(clk, din, wr_en, rd_en, dout, full, empty)
/* synthesis syn_black_box black_box_pad_pin="clk,din[37:0],wr_en,rd_en,dout[37:0],full,empty" */;
  input clk;
  input [37:0]din;
  input wr_en;
  input rd_en;
  output [37:0]dout;
  output full;
  output empty;
endmodule
