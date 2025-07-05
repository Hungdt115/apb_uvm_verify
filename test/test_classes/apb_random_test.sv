//--------------------------------------------------------------------
//-- Class: apb_random_test
//-- Description: A random test that executes a random sequence of
//--              operations for regression testing.
//--------------------------------------------------------------------
class apb_random_test extends apb_base_test;
  `uvm_component_utils(apb_random_test)

  //--------------------------------------------------------------------
  //-- Methods
  //--------------------------------------------------------------------

  //-- Constructor
  function new(string name = "apb_random_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //-- Build Phase: Create the random sequence
  function void build_phase(uvm_phase phase);
    apb_random_sequence random_seq;
    super.build_phase(phase);

    //-- Create the main random sequence
    random_seq = apb_random_sequence::type_id::create("random_seq");

    //-- Assign the random sequence to the main sequence handle
    m_sequence = random_seq;
  endfunction

endclass
