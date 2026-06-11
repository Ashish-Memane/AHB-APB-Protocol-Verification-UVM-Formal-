//////////////////////////////////////////////////////////////
// file name : ahb_seq_lib.sv
// description : sequences for ahb
// Engineer : Ashish Memane
//////////////////////////////////////////////////////////////
class ahb_base_seq #(parameter int WIDTH = 32) extends uvm_sequence #(ahb_xtn#(WIDTH));

        // factory registration
        `uvm_object_param_utils(ahb_base_seq#(WIDTH))

        // constructor
        function new(string name  = "ahb_base_seq");
                super.new(name);
        endfunction : new

endclass : ahb_base_seq

//////////////////////////////////////////////////////////////
// AHB single write sequence---------------------------------
class ahb_single_write_seq #(parameter int WIDTH = 32) extends ahb_base_seq#(WIDTH);

        // factory registration
        `uvm_object_param_utils(ahb_single_write_seq#(WIDTH))

        // constructor
        function new(string name = "ahb_single_write_seq");
                super.new(name);
        endfunction : new

        task body();
                req = ahb_xtn#(WIDTH)::type_id::create("req");

                start_item(req);

                // randomize for single write
                if(!req.randomize() with {
                        Hburst == 3'b000; // SINGLE
                        Hwrite == 1'b1;   // WRITE
                }) begin
                        `uvm_fatal(get_type_name(),"Randomization failed")
                end

                finish_item(req);

        endtask : body

endclass : ahb_single_write_seq

///////////////////////////////////////////////////////////////
// AHB Burst sequence ----------------------------------------
class ahb_incr4_seq #(parameter int WIDTH = 32) extends ahb_base_seq#(WIDTH);

        // factory registration
        `uvm_object_param_utils(ahb_incr4_seq#(WIDTH))

        // constructor
        function new(string name = "ahb_incr4_seq");
                super.new(name);
        endfunction : new

        // body
        task body();
                req = ahb_xtn#(WIDTH)::type_id::create("req");

                start_item(req);

                if(!req.randomize() with {
                        Hburst == 3'b011; // INCR4
                }) begin
                        `uvm_fatal(get_type_name(),"Randomization failed")
                end

        endtask : body

endclass : ahb_incr4_seq
