//--------------------------------------------------------------------
//-- Class: apb_directed_test
//-- Description: A directed test that executes a specific sequence of
//--              operations to verify a particular feature.
//--------------------------------------------------------------------
class apb_directed_test extends apb_base_test;
  `uvm_component_utils(apb_directed_test)

  //--------------------------------------------------------------------
  //-- Methods
  //--------------------------------------------------------------------

  //-- Constructor
  function new(string name = "apb_directed_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //-- Build Phase: Create the directed sequence and its sub-sequences
  function void build_phase(uvm_phase phase);
    apb_directed_sequence directed_seq;
    apb_write_read_sequence wrs;
    apb_burst_write_read_sequence bwrs;

    super.build_phase(phase);

    //-- Create the main directed sequence
    directed_seq = apb_directed_sequence::type_id::create("directed_seq");

    //-- Create the sub-sequences to be executed
    wrs = apb_write_read_sequence::type_id::create("wrs");
    bwrs = apb_burst_write_read_sequence::type_id::create("bwrs");

    //-- Add sub-sequences to the directed sequence queue
    directed_seq.sequences.push_back(wrs);
    directed_seq.sequences.push_back(bwrs);

    //-- Assign the directed sequence to the main sequence handle
    m_sequence = directed_seq;
  endfunction

endclass
