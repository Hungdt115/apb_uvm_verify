//--------------------------------------------------------------------
//-- Class: apb_random_sequence
//-- Description: Executes a random sequence from a predefined list.
//--              This is used for randomized regression testing.
//--------------------------------------------------------------------
class apb_random_sequence extends uvm_sequence#(apb_transaction);
  `uvm_object_utils(apb_random_sequence)

  //-- Sub-sequences to be randomized
  apb_write_read_sequence wrs;
  apb_burst_write_read_sequence bwrs;
  apb_error_addr_sequence eas;

  //--------------------------------------------------------------------
  //-- Methods
  //--------------------------------------------------------------------

  //-- Constructor
  function new(string name = "apb_random_sequence");
    super.new(name);
  endfunction

  //-- Body: Randomly selects and executes one sub-sequence
  virtual task body();
    `uvm_info(get_full_name(), "Starting random sequence...", UVM_LOW)

    //-- Create the sequence objects
    wrs = apb_write_read_sequence::type_id::create("wrs");
    bwrs = apb_burst_write_read_sequence::type_id::create("bwrs");
    eas = apb_error_addr_sequence::type_id::create("eas");

    //-- Randomly choose which sequence to run
    randcase
      1: wrs.start(m_sequencer);
      1: bwrs.start(m_sequencer);
      1: eas.start(m_sequencer);
    endcase

    `uvm_info(get_full_name(), "Finished random sequence.", UVM_LOW)
  endtask

endclass
