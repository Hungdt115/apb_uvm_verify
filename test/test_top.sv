//--------------------------------------------------------------------
//-- File: test_top.sv
//-- Description: Includes all test-related classes and sequences
//--              for the APB UVM environment. This file is included
//--              by the main apb_top.sv module.
//--------------------------------------------------------------------

//--------------------------------------------------------------------
//-- Sequence Includes
//--------------------------------------------------------------------
`include "sequences/apb_write_read_sequence.sv"
`include "sequences/apb_write_read_b2b_sequence.sv"
`include "sequences/apb_error_addr_sequence.sv"
`include "sequences/apb_error_write_sequence.sv"
`include "sequences/apb_error_read_sequence.sv"
`include "sequences/apb_burst_write_read_sequence.sv"
`include "sequences/apb_burst_diff_data_sequence.sv"
`include "sequences/apb_max_wr_addr_sequence.sv"
`include "sequences/apb_max_burst_sequence.sv"
`include "sequences/apb_directed_sequence.sv"
`include "sequences/apb_random_sequence.sv"

//--------------------------------------------------------------------
//-- Test Class Includes
//--------------------------------------------------------------------
`include "test_classes/apb_base_test.sv"
`include "test_classes/apb_directed_test.sv"
`include "test_classes/apb_random_test.sv"
