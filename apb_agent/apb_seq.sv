///////////////////////////////////////////////////////////////////
// file name : apb_seq.sv
// description : apb dummy sequence
// Engineer : Ashish Memane
///////////////////////////////////////////////////////////////////

class apb_dummy_seq #(parameter int WIDTH = 32, int SLAVE = 4) extends uvm_sequence #(apb_xtn#(WIDTH,SLAVE));

        // factory registration
        `uvm_object_param_utils(apb_dummy_seq#(WIDTH, SLAVE))

        // construtor
        function new(string name = "apb_dummy_seq");
                super.new(name);
        endfunction : new

        // task body
        task body();

                forever begin
                        req = apb_xtn#(WIDTH,SLAVE)::type_id::create("req");
                        start_item(req);

                        // randomize the read data
                        if(!req.randomize()) begin
                                `uvm_fatal(get_type_name(),"Randomization failed")
                        end

                        finish_item(req);
                end
        endtask : body

endclass : apb_dummy_seq
