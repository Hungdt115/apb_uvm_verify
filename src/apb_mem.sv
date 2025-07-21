//--------------------------------------------------------------------
//-- Module: apb_mem
//-- Description:
//--  This module implements a simple APB (Advanced Peripheral Bus) slave device.
//--  It features a state machine to handle APB transfers (IDLE, SETUP, ACCESS)
//--  and an internal 32-word (32-bit each) memory for read/write operations.
//--  The module responds to APB signals and manages the PREADY signal.
//--------------------------------------------------------------------
module apb_mem(
    //--------------------------------------------------------------------------
    // APB Interface Ports
    //--------------------------------------------------------------------------
    input  logic        PCLK,     // APB clock
    input  logic        PRESETn,  // APB active-low reset
    input  logic        PSEL,     // APB select
    input  logic        PENABLE,  // APB enable
    input  logic        PWRITE,   // APB write/read control
    input  logic [31:0] PADDR,    // APB address
    input  logic [31:0] PWDATA,   // APB write data
    input  logic [ 3:0] PSTRB,    // APB byte write strobe
    input  logic [ 2:0] PPROT,
    output logic        PREADY,   // APB ready signal
    output logic [31:0] PRDATA,   // APB read data
    output logic        PSLVERR   // APB slave error
);



  logic [31:0] mem [0:256];
  logic [1:0] apb_st;
  const logic [1:0] SETUP=0;
  const logic [1:0] W_ENABLE=1;
  const logic [1:0] R_ENABLE=2;

  always @(posedge PCLK or negedge PRESETn) begin
    if (PRESETn==0) begin
      apb_st <=0;
      PRDATA <=0;
      PREADY <=1;
      for(int i=0;i<256;i++) mem[i]=i;
    end
    else begin
      case (apb_st)
        SETUP: begin
          PRDATA <= 0;
          if (PSEL && !PENABLE) begin
            if (PWRITE) begin
              apb_st <= W_ENABLE;
            end
            else begin
              apb_st <= R_ENABLE;
              PRDATA <= mem[PADDR];
            end
          end
        end
        W_ENABLE: begin
          if (PSEL && PENABLE && PWRITE) begin
            mem[PADDR] <= PWDATA;
          end
          apb_st <= SETUP;
        end
        R_ENABLE: begin
          apb_st <= SETUP;
        end
      endcase
    end
  end
/*
  always @(posedge clock)
  begin
    `uvm_info("", $sformatf("DUT received cmd=%b, addr=%d, data=%d",
                            cmd, addr, data), UVM_MEDIUM)
  end
*/
endmodule