`timescale 1ns/10ps
`define PCKG_SZ 32 
`define BROADCAST {8{1'b1}}
`define DRVRS 4 
`define BITS 1
`define NUM_MSGS 100
`include "Library.sv"

interface bus_if #(BITS=1,DRVRS=4,PCKG_SZ=32)(input clk);
   logic reset;
   logic pndng[`BITS-1:0][`DRVRS-1:0];
   logic push[`BITS-1:0][`DRVRS-1:0];
   logic pop[`BITS-1:0][`DRVRS-1:0];
   logic [PCKG_SZ-1:0] D_pop[`BITS-1:0][`DRVRS-1:0];
   logic [PCKG_SZ-1:0] D_push[`BITS-1:0][`DRVRS-1:0];   
endinterface


module Tb_bus_top;
  
   reg clk;
   always #1 clk=~clk;
   bus_if uut_if(.clk(clk));
   
//#########################################################
//                   UUT DEFINITION
//#########################################################

 bs_gnrtr_n_rbtr #(`BITS,`DRVRS,`PCKG_SZ,`BROADCAST) uut(.clk(uut_if.clk),
							 .reset(uut_if.reset),
							 .pndng(uut_if.pndng),
							 .push(uut_if.push),
							 .pop(uut_if.pop),
							 .D_pop(uut_if.D_pop),
							 .D_push(uut_if.D_push));
   
endmodule