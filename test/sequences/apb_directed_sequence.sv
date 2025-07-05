//--------------------------------------------------------------------
//-- Class: apb_directed_sequence
//-- Description: Executes a specific, ordered list of sub-sequences.
//--              This sequence is used for directed, deterministic tests.
//--------------------------------------------------------------------
class apb_directed_sequence extends uvm_sequence#(apb_transaction);
  `uvm_object_utils(apb_directed_sequence)

  //-- Array to hold the sequences to be executed
  uvm_sequence #(apb_transaction) sequences[$];

  //--------------------------------------------------------------------
  //-- Methods
  //--------------------------------------------------------------------

  //-- Constructor
  function new(string name = "apb_directed_sequence");
    super.new(name);
  endfunction

  //-- Body: Executes each sequence in the 'sequences' array
  virtual task body();
    `uvm_info(get_full_name(), "Starting directed sequence...", UVM_LOW)
    foreach (sequences[i]) begin
      sequences[i].start(m_sequencer);
    end
    `uvm_info(get_full_name(), "Finished directed sequence.", UVM_LOW)
  endtask

endclass
