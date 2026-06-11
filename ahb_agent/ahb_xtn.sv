////////////////////////////////////////////////////////////////////////////
// file name : ahb_xtn.sv
// description : ahb transaction object
// Engineer : Ashish Memane
////////////////////////////////////////////////////////////////////////////
//`timescale 1ns / 1ps

class ahb_xtn #(parameter int WIDTH = 32) extends uvm_sequence_item;


        // property declarations
        rand logic [WIDTH-1:0] Haddr;
        rand logic [WIDTH-1:0] Hwdata[];
        rand logic Hwrite;
        rand logic [2:0] Hsize;
        rand logic [1:0] Htrans;
        rand logic [2:0] Hburst;
        logic [WIDTH-1:0] Hrdata[];
        logic [1:0] Hresp[];

        rand int length;

        // constraints
        constraint c_burst_length {
                (Hburst == 3'b000) -> length == 1;  // SINGLE
                (Hburst == 3'b010 || Hburst == 3'b011) -> length == 4;  // WRAP4 / INCR4
                (Hburst == 3'b100 || Hburst == 3'b101) -> length == 8;  // WRAP8 / INCR8
                (Hburst == 3'b110 || Hburst == 3'b111) -> length == 16; // WRAP16 / INCR16
                (Hburst == 3'b001) -> length inside {[1:16]}; // INCR (Undefined length, keeping it reasonable)
        }

        constraint c_data_size {
                Hwdata.size() == length;
        }

        constraint c_trans_type { Htrans inside {2'b00, 2'b10}; }

        constraint c_addr_alignment {
                (Hsize == 3'b001) -> (Haddr % 2 == 0); // halfword
                (Hsize == 3'b010) -> (Haddr % 4 == 0); // word
        }

        // 1KB Boundary Constraint (Optional but professional)
        constraint c_1kb_boundary {
                ((Haddr % 1024) + (length * (1 << Hsize))) <= 1024;
        }

        `uvm_object_param_utils_begin(ahb_xtn#(WIDTH))
        `uvm_field_int(Haddr,  UVM_ALL_ON)
        `uvm_field_array_int(Hwdata, UVM_ALL_ON)
        `uvm_field_int(Hwrite, UVM_ALL_ON)
        `uvm_field_int(Hsize,  UVM_ALL_ON)
        `uvm_field_int(Htrans, UVM_ALL_ON)
        `uvm_field_int(Hburst, UVM_ALL_ON)
        `uvm_field_array_int(Hrdata, UVM_ALL_ON)
        `uvm_field_array_int(Hresp,  UVM_ALL_ON)
        `uvm_object_utils_end

        // constructor
        function new(string name = "ahb_xtn");
                super.new(name);
        endfunction : new

endclass : ahb_xtn
