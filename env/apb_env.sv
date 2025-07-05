class apb_env extends uvm_env;
  `uvm_component_utils(apb_env)
  
  apb_wagent            wagent;
  apb_ragent            ragent;
  apb_scoreboard        scb;
  apb_coverage_model    cm;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    wagent = apb_wagent :: type_id :: create ("wagent", this);
    ragent = apb_ragent :: type_id :: create ("ragent", this);
    scb = apb_scoreboard:: type_id :: create("scb",this);
    cm = apb_coverage_model:: type_id :: create("cm",this);

endfunction
  
   function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     //-- Connect the write monitor to the scoreboard's write FIFO
     wagent.wmon.wap.connect(scb.write_fifo.analysis_export);
     `uvm_info("ENV", "Connected Write Monitor to Scoreboard FIFO", UVM_LOW)

     //-- Connect the read monitor to the scoreboard's read FIFO
     ragent.rmon.rap.connect(scb.read_fifo.analysis_export);
     `uvm_info("ENV", "Connected Read Monitor to Scoreboard FIFO", UVM_LOW)

     //-- Connect monitors to the coverage model
     wagent.wmon.wap.connect(cm.cm_export_write);
     ragent.rmon.rap.connect(cm.cm_export_read);
     `uvm_info("ENV", "Connected Monitors to Coverage Model", UVM_LOW)
   endfunction
endclass
