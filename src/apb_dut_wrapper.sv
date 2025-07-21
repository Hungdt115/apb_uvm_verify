// ============================================================================
//  Module      : apb_dut_wrapper
//  Description : Wrapper module for the APB DUT passthrough
//                - Instantiates `apb_dut_passthrough`
//                - Connects APB master and slave interfaces transparently
//
//  Author      : hungdt110520@gmail.com
//  Date        : 2025-07-21
// ============================================================================

module apb_dut_wrapper (
    input  logic         pclk,
    input  logic         presetn,

    // Slave interface (connected to APB master)
    input  logic         s_pwrite,
    input  logic         s_psel,
    input  logic         s_penable,
    input  logic [31:0]  s_paddr,
    input  logic [31:0]  s_pwdata,
    input  logic [3:0]   s_pstrb,
    input  logic [2:0]   s_pprot,

    output logic         s_pready,
    output logic         s_pslverr,
    output logic [31:0]  s_prdata,

    // Master interface (connected to APB slave)
    output logic         m_pwrite,
    output logic         m_psel,
    output logic         m_penable,
    output logic [31:0]  m_paddr,
    output logic [31:0]  m_pwdata,
    output logic [3:0]   m_pstrb,
    output logic [2:0]   m_pprot,
    input  logic         m_pready,
    input  logic         m_pslverr,
    input  logic [31:0]  m_prdata
);

    // Instantiate DUT passthrough
    apb_dut dut (
        .pclk      (pclk),
        .presetn   (presetn),

        .s_pwrite  (s_pwrite),
        .s_psel    (s_psel),
        .s_penable (s_penable),
        .s_paddr   (s_paddr),
        .s_pwdata  (s_pwdata),
        .s_pstrb   (s_pstrb),
        .s_pprot   (s_pprot),

        .s_pready  (s_pready),
        .s_pslverr (s_pslverr),
        .s_prdata  (s_prdata),

        .m_pwrite  (m_pwrite),
        .m_psel    (m_psel),
        .m_penable (m_penable),
        .m_paddr   (m_paddr),
        .m_pwdata  (m_pwdata),
        .m_pstrb   (m_pstrb),
        .m_pprot   (m_pprot),
        .m_pready  (m_pready),
        .m_pslverr (m_pslverr),
        .m_prdata  (m_prdata)
    );

endmodule
