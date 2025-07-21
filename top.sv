
//-- UVM Package and Macros
import uvm_pkg::*;
`include "uvm_macros.svh"

//-- Core Environment Includes
`include "env/apb_transaction.sv"
`include "env/apb_sequencer.sv"
`include "env/apb_wdriver.sv"
`include "env/apb_wmonitor.sv"
`include "env/apb_rmonitor.sv"
`include "env/apb_wagent.sv"
`include "env/apb_ragent.sv"
`include "env/apb_scoreboard.sv"
`include "env/apb_coverage_model.sv"
`include "env/apb_env.sv"
`include "apb_if.sv"

//-- Test-related Includes
`include "test/test_top.sv"


//--------------------------------------------------------------------
//-- Module: top_test
//-- Description: 
//--  Top-level module for the APB UVM testbench.
//--  his module instantiates the DUT, the APB interface,
//--  and starts the UVM test.
//--------------------------------------------------------------------
module top_test();

  //-- APB Interface Instance  
  apb_if vif();

  //-- DUT Instance
  apb_dut dut (
    .PCLK   (vif.PCLK),
    .PRESETn (vif.PRESETn),
    .PADDR  (vif.PADDR),
    .PWRITE (vif.PWRITE),
    .PSEL   (vif.PSEL),
    .PENABLE(vif.PENABLE),
    .PWDATA (vif.PWDATA),
    .PRDATA (vif.PRDATA),
    .PREADY (vif.PREADY),
    .PSTRB  (vif.PSTRB),
    //.PPROT  (vif.PPROT),
    
    .PSLVERR(vif.PSLVERR)
  );

  //--------------------------------------------------------------------
  //-- Clock Generation
  //--------------------------------------------------------------------
  initial begin
    vif.PCLK = 1'b0;
    forever #5 vif.PCLK = ~vif.PCLK;
  end

  //--------------------------------------------------------------------
  //-- Reset Generation
  //--------------------------------------------------------------------
  initial begin
    vif.PRESETn = 1'b1;
    `uvm_info("APB_TOP", "Applying reset", UVM_LOW);
    #15;
    vif.PRESETn = 1'b0;
    `uvm_info("APB_TOP", "Releasing reset", UVM_LOW);
  end

  //--------------------------------------------------------------------
  //-- UVM Test Execution
  //--------------------------------------------------------------------
  initial begin
    //-- Set the virtual interface in the config database for the testbench
    uvm_config_db#(virtual apb_if)::set(null, "*", "vif", vif);

    //-- Set the number of transactions for the test
    uvm_config_db#(int)::set(null, "*", "num_transactions", 5); // Example: 20 transactions

    //-- Run the desired UVM test
    run_test(); // Or "apb_directed_test"
  end

  //--------------------------------------------------------------------
  //-- Waveform Dumping
  //--------------------------------------------------------------------
  initial begin
    $dumpfile("waveform.vcd");
    $dumpvars;
  end

endmodule
//====================================================================
