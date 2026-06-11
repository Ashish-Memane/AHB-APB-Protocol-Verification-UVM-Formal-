///////////////////////////////////////////////////////////////////////////
// file name : apb_sequencer.sv
// description : apb sequencer
// Engineer : Ashish Memane
///////////////////////////////////////////////////////////////////////////

class apb_sequencer #(parameter int WIDTH = 32, int SLAVE = 4) extends uvm_sequencer #(apb_xtn);

        // factory registraion
        `uvm_component_param_utils(apb_sequencer#(WIDTH, SLAVE))

        // constructor
        function new(string name = "apb_sequencer", uvm_component parent = null);
                super.new(name,parent);
        endfunction : new

endclass : apb_sequencer
