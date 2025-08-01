
class apb_test extends uvm_test;

  //Register with factory
  `uvm_component_utils(apb_test)

  apb_env env;
  virtual apb_if vif;

  function new(string name = "apb_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //Build phase - Construct the env class using factory
  //Get the virtual interface handle from Test and then set it config db for the env component
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = apb_env::type_id::create("env", this);

    if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("build_phase", "No virtual interface specified for this test instance")
    end
    uvm_config_db#(virtual apb_if)::set(this, "env", "vif", vif);
  endfunction

  //Run phase - Create an abp_sequence and start it on the apb_sequencer
  task run_phase(uvm_phase phase);
    apb_sequence apb_seq;
    apb_seq = apb_sequence::type_id::create("apb_seq");
    phase.raise_objection(this, "Starting apb_base_seqin main phase");
    $display("%t Starting sequence apb_seq run_phase", $time);
    apb_seq.start(env.agt.sqr);
    #100ns;
    phase.drop_objection(this, "Finished apb_seq in main phase");
  endtask


endclass
