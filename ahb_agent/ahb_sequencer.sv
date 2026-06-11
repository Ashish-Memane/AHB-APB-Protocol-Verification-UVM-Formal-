//////////////////////////////////////////////////////////////////
// file name : ahb_sequencer.sv
// description : ahb sequencer component
// Engineer : Ashish Memane
//////////////////////////////////////////////////////////////////

class ahb_sequencer #(parameter int WIDTH = 32) extends uvm_sequencer;

        // factory registration
        `uvm_component_param_utils(ahb_sequencer#(WIDTH))

        // constructor
        function new(string name = "ahb_sequencer", uvm_component parent);
                super.new(name, parent);
        endfunction : new

endclass : ahb_sequencer
