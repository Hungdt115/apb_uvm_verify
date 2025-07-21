// ============================================================================
//  Module      : apb_dut
//  Description : APB4-compliant module that instances apb_mem.
//                Retains original port list, with unused master ports driven to default.
//
//  Author      : hungdt110520@gmail.com
//  Date        : 2025-07-21
// ============================================================================

module apb_dut (
    input  logic         pclk,       // APB clock (from top)
    input  logic         presetn,    // APB resetn (from top)

    // APB4 Slave Interface (from APB master in testbench)
    input  logic         s_pwrite,
    input  logic         s_psel,
    input  logic         s_penable,
    input  logic [31:0]  s_paddr,
    input  logic [31:0]  s_pwdata,
    input  logic [3:0]   s_pstrb,
    input  logic [2:0]   s_pprot, // unused by apb_mem

    output logic         s_pready,
    output logic         s_pslverr,
    output logic [31:0]  s_prdata,

    // APB4 Master Interface (to APB slave in testbench, now unused)
    output logic         m_pwrite,
    output logic         m_psel,
    output logic         m_penable,
    output logic [31:0]  m_paddr,
    output logic [31:0]  m_pwdata,
    output logic [3:0]   m_pstrb,
    output logic [2:0]   m_pprot,
    input  logic         m_pready,  // Unused by apb_mem
    input  logic         m_pslverr, // Unused by apb_mem
    input  logic [31:0]  m_prdata   // Unused by apb_mem
    );

    // Drive unused master outputs to default values
    assign m_pwrite   = 1'b0;
    assign m_psel     = 1'b0;
    assign m_penable  = 1'b0;
    assign m_paddr    = 32'b0;
    assign m_pwdata   = 32'b0;
    assign m_pstrb    = 4'b0;
    assign m_pprot    = 3'b0;

    // Instance of apb_mem
    // Connect apb_dut's slave interface to apb_mem's interface
    apb_mem i_apb_mem (
        .PCLK   (pclk),
        .PRESETn(presetn),
        .PSEL   (s_psel),
        .PENABLE(s_penable),
        .PWRITE (s_pwrite),
        .PADDR(s_paddr),
        .PWDATA(s_pwdata),
        .PSTRB(s_pstrb),
        .PPROT(s_pprot),
        .PREADY(s_pready),
        .PRDATA(s_prdata),
        .PSLVERR(s_pslverr)
    );

endmodule
