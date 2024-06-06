// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Mon Mar 25 12:11:15 2024
// Host        : ZMJ-miniPC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/Users/ZMJ-miniPC/Desktop/comp2008/miniRV_axi/miniRV_axi.srcs/sources_1/ip/blk_mem_gen_1/blk_mem_gen_1_stub.v
// Design      : blk_mem_gen_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tfgg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_2,Vivado 2018.3" *)
module blk_mem_gen_1(clka, wea, addra, dina, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[5:0],dina[133:0],douta[133:0]" */;
  input clka;
  input [0:0]wea;
  input [5:0]addra;
  input [133:0]dina;
  output [133:0]douta;
endmodule
