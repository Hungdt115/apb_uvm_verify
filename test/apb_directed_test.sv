//--------------------------------------------------------------------
//-- Class: apb_directed_test 
//-- Description: Base class for all APB tests. It builds the common
//--              testbench environment. The actual test sequence is
//--              controlled by derived test classes.
//--------------------------------------------------------------------
class apb_directed_test  extends apb_base_test;
  `uvm_component_utils(apb_directed_test )

  //---- Number of transactions to generate
  rand int sequence_length = 5;

  //---- Constraint: sequence_length must be less than 100
  constraint length_c {
    sequence_length inside {[1:99]};
  }

  //---- Flag to track whether config_db provided sequence_length
  bit status = 0;

  function new(string name = "apb_directed_test ", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Build phase - Construct the env class and pass virtual interface
  function void build_phase(uvm_phase phase);    
    super.build_phase(phase);
    
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


  //-- Run Phase: starts the main sequence
  task run_phase(uvm_phase phase);
    apb_master_directed_sequence seq;
    seq = apb_master_directed_sequence::type_id::create("seq");
    phase.raise_objection(this, "Starting apb_base_seqin main phase");

    $display("%t Starting sequence apb_seq run_phase",$time);
    seq.start(env.agt.sqr);
    #50ns;

    phase.drop_objection(this, "Finished apb_seq in main phase" );
  endtask

endclass

