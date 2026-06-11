//////////////////////////////////////////////////////////////////////
// file name : apb_xtn.sv
// description : apb transaction object
// Engineer : Ashish Memane
//////////////////////////////////////////////////////////////////////
// `timescale 1ns / 1ps

class apb_xtn #(parameter int WIDTH = 32, int SLAVE = 4) extends uvm_sequence_item;

        // property declaraions
        logic [WIDTH-1:0] Paddr;
        logic Pwrite;
        logic [SLAVE-1:0] Pselx;
        logic Penable;
        logic [WIDTH-1:0] Pwdata;

        rand logic [WIDTH-1:0] Prdata;

        // factory registraion
        `uvm_object_param_utils_begin(apb_xtn#(WIDTH, SLAVE))
        `uvm_field_int(Paddr, UVM_ALL_ON)
        `uvm_field_int(Pwrite, UVM_ALL_ON)
        `uvm_field_int(Pselx, UVM_ALL_ON)
        `uvm_field_int(Penable, UVM_ALL_ON)
        `uvm_field_int(Pwdata, UVM_ALL_ON)
        `uvm_field_int(Prdata, UVM_ALL_ON)
        `uvm_object_utils_end

        // consntructor
        function new(string name = "apb_xtn");
                super.new(name);
        endfunction : new

endclass : apb_xtn
