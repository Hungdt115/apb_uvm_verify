//--------------------------------------------------------------------
//-- Class: apb_base_test
//-- Description: Base class for all APB tests. It builds the common
//--              testbench environment. The actual test sequence is
//--              controlled by derived test classes.
//--------------------------------------------------------------------
class apb_base_test extends uvm_test;
  `uvm_component_utils(apb_base_test)

  //---- Number of transactions to generate
  rand int sequence_length;

  //---- Constraint: sequence_length must be less than 100
  constraint length_c {
    sequence_length inside {[1:99]};
  }

  //---- Flag to track whether config_db provided sequence_length
  bit status = 0;
  
  //-- Environment handle
  apb_env env;

  //-- The sequence that will be run by this test
  uvm_sequence #(apb_transaction) m_sequence;
  
  virtual apb_if vif;  


  function new(string name = "apb_base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase - Construct the env class and pass virtual interface
  function void build_phase(uvm_phase phase);    
    super.build_phase(phase);   
    
    env = apb_env::type_id::create("env", this);
    
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("build_phase", "No virtual interface specified for this test instance")
    end 
    
    uvm_config_db#(virtual apb_if)::set(this, "env", "vif", vif);
    
    // Get number of transactions from config_db
    if (uvm_config_db#(int)::get(this, "*", "sequence_length", sequence_length)) begin
      status = 1;
      `uvm_info(get_full_name(), $sformatf("sequence_length configured as: %0d", sequence_length), UVM_LOW)
    end
    else begin
      `uvm_info(get_full_name(), "sequence_length not set via config_db. Will randomize in body()", UVM_LOW)
    end    
  endfunction
  
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    if (!status) begin
      assert(this.randomize());
      `uvm_info(get_full_name(), $sformatf("Randomized sequence_length = %0d", sequence_length), UVM_LOW)
    end
  endfunction

  
  //-- End of Elaboration Phase: prints the testbench topology
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(get_full_name(), "Printing testbench topology...", UVM_LOW)
    uvm_top.print_topology();
  endfunction

  //-- Run Phase: starts the main sequence
  /* task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    //-- The actual sequence is created and assigned in the derived test
    if (m_sequence == null) begin
      `uvm_fatal(get_full_name(), "m_sequence not created in derived test class")
    end
    m_sequence.start(env.agt.sqr);
    #50; //-- Add some delay for simulation to end gracefully
    phase.drop_objection(this);
  endtask */

endclass

