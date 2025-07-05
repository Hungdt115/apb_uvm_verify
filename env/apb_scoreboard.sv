//--------------------------------------------------------------------
//-- Class: apb_scoreboard
//-- Description: Verifies the correctness of the APB DUT. This scoreboard
//--              is designed to handle out-of-order and burst transactions
//--              by using an associative array to store pending writes.
//--------------------------------------------------------------------
class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_scoreboard)

  //-- TLM FIFOs to get transactions from monitors
  uvm_tlm_analysis_fifo #(apb_transaction) write_fifo;
  uvm_tlm_analysis_fifo #(apb_transaction) read_fifo;

  //-- Associative array to hold pending write data, keyed by address
  protected bit [31:0] pending_writes[bit [31:0]];

  //-- Scorekeeping variables
  int compare_pass = 0;
  int compare_fail = 0;

  //--------------------------------------------------------------------
  //-- Methods
  //--------------------------------------------------------------------

  //-- Constructor
  function new (string name = "apb_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction

  //-- Build Phase: Create the FIFOs
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    write_fifo = new("write_fifo", this);
    read_fifo  = new("read_fifo", this);
  endfunction

  //-- Run Phase: Fork two parallel processes for writes and reads
  task run_phase(uvm_phase phase);
    fork
      //-- Process 1: Handle incoming write transactions
      process_writes();
      //-- Process 2: Handle incoming read transactions
      process_reads();
    join_none
  endtask

  //-- Task to process write transactions
  virtual protected task process_writes();
    apb_transaction write_t;
    forever begin
      write_fifo.get(write_t);
      //-- Check if a write to this address is already pending
      if (pending_writes.exists(write_t.PADDR)) begin
        `uvm_warning("SCOREBOARD", $sformatf("Overwriting pending write at address 0x%0h without a read", write_t.PADDR))
      end
      //-- Store the write data, keyed by its address
      pending_writes[write_t.PADDR] = write_t.PWDATA;
      `uvm_info("SCOREBOARD", $sformatf("Logged write to Addr: 0x%0h, Data: 0x%0h", write_t.PADDR, write_t.PWDATA), UVM_HIGH)
    end
  endtask

  //-- Task to process read transactions
  virtual protected task process_reads();
    apb_transaction read_t;
    forever begin
      read_fifo.get(read_t);
      //-- Check if there was a corresponding write to this address
      if (pending_writes.exists(read_t.PADDR)) begin
        //-- Compare read data with the stored write data
        if (read_t.PRDATA == pending_writes[read_t.PADDR]) begin
          `uvm_info("COMPARE", $sformatf("Test OK! Addr: 0x%0h, Matched Data: 0x%0h", read_t.PADDR, read_t.PRDATA), UVM_LOW)
          compare_pass++;
        end else begin
          `uvm_error("COMPARE", $sformatf("Test FAIL! Addr: 0x%0h, Write Data: 0x%0h, Read Data: 0x%0h", read_t.PADDR, pending_writes[read_t.PADDR], read_t.PRDATA))
          compare_fail++;
        end
        //-- Remove the entry from the pending queue
        pending_writes.delete(read_t.PADDR);
      end else begin
        `uvm_error("COMPARE", $sformatf("Unexpected Read! Received read from address 0x%0h which was never written to or was already checked.", read_t.PADDR))
        compare_fail++;
      end
    end
  endtask

  //-- Report Phase: Check for any writes that were never read
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    //-- Check for any remaining entries in the pending writes queue
    if (pending_writes.num() > 0) begin
      `uvm_error("SCOREBOARD", $sformatf("Found %0d writes that were never read back!", pending_writes.num()))
      foreach (pending_writes[addr]) begin
        `uvm_info("SCOREBOARD", $sformatf("  - Unchecked write to Addr: 0x%0h, Data: 0x%0h", addr, pending_writes[addr]), UVM_LOW)
      end
    end

    `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    `uvm_info(get_type_name(), $sformatf("----       TEST PASS COUNTS: %0d     ----", compare_pass), UVM_NONE)
    `uvm_info(get_type_name(), $sformatf("----       TEST FAIL COUNTS: %0d     ----", compare_fail + pending_writes.num()), UVM_NONE)
    `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
  endfunction

endclass
