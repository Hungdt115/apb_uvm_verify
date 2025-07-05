//--------------------------------------------------------------------
//-- Class: apb_base_test
//-- Description: Base class for all APB tests. It builds the common
//--              testbench environment. The actual test sequence is
//--              controlled by derived test classes.
//--------------------------------------------------------------------
class apb_base_test extends uvm_test;
  `uvm_component_utils(apb_base_test)

  //-- Environment handle
  apb_env env;

  //-- The sequence that will be run by this test
  uvm_sequence #(apb_transaction) m_sequence;

  //--------------------------------------------------------------------
  //-- Methods
  //--------------------------------------------------------------------

  //-- Constructor
  function new(string name = "apb_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //-- Build Phase: constructs the environment
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    env = apb_env::type_id::create("env", this);
  endfunction

  //-- End of Elaboration Phase: prints the testbench topology
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(get_full_name(), "Printing testbench topology...", UVM_LOW)
    uvm_top.print_topology();
  endfunction

  //-- Run Phase: starts the main sequence
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    //-- The actual sequence is created and assigned in the derived test
    if (m_sequence == null) begin
      `uvm_fatal(get_full_name(), "m_sequence not created in derived test class")
    end
    m_sequence.start(env.wagent.sqr);
    #50; //-- Add some delay for simulation to end gracefully
    phase.drop_objection(this);
  endtask

endclass
