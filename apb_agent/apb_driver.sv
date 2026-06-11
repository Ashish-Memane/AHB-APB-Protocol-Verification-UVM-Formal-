////////////////////////////////////////////////////////////////////////////////////////////////
// file name : apb_driver.sv
// description : apb driver
// Engineer : Ashish Memane
////////////////////////////////////////////////////////////////////////////////////////////////

class apb_driver #(parameter int WIDTH = 32, int SLAVE = 4) extends uvm_driver #(apb_xtn#(WIDTH,SLAVE));

        // factory registration
        `uvm_component_param_utils(apb_driver#(WIDTH,SLAVE))

        // interface declaration
        virtual apb_if#(WIDTH, SLAVE) vif;

        int apb_drv_pkts = 0;

        //constructor
        function new(string name = "apb_driver", uvm_component parent = null);
                super.new(name,parent);
        endfunction : new

        // build phase
        function void build_phase(uvm_phase phase);
                super.build_phase(phase);

                if(!uvm_config_db#(virtual apb_if#(WIDTH,SLAVE))::get(this,"","apb_if", vif)) begin
                        `uvm_fatal(get_type_name(),"Cannot get the vif")
                end
        endfunction : build_phase

        // task run phase
        task run_phase(uvm_phase phase);
                forever begin
                        // 1. Wake up on every clock edge
                        @(vif.apb_drv_cb);

                        // 2. Check if we are in the APB Setup Phase (PSEL is high, PENABLE is low)
                        if (vif.apb_drv_cb.Pselx != 0 && vif.apb_drv_cb.Penable == 0) begin

                                // READ operation: We need random data from the sequence to drive Prdata
                                if (vif.apb_drv_cb.Pwrite == 0) begin
                                        seq_item_port.get_next_item(req);
                                        send_to_dut(req);
                                        seq_item_port.item_done();
                                end
                                // WRITE operation: Slave just absorbs data, no sequence item needed
                                else begin
                                        send_to_dut(null);
                                end
                        end
                end
        endtask : run_phase

        // task send to dut
        task send_to_dut(apb_xtn #(WIDTH,SLAVE) xtn);
                @(vif.apb_drv_cb);

                if( vif.apb_drv_cb.Pwrite == 0 && xtn != null) begin
                        vif.apb_drv_cb.Prdata <= xtn.Prdata;
                        `uvm_info(get_type_name(), $sformatf("APB SLAVE: Responded with Read Data = %0h", xtn.Prdata), UVM_LOW)
                end
                apb_drv_pkts++;

        endtask : send_to_dut

        // report phase
        function void report_phase(uvm_phase phase);
                `uvm_info(get_type_name(),$sformatf("APB DRIVER PACKETS : %0d", apb_drv_pkts),UVM_LOW)
        endfunction : report_phase


endclass : apb_driver
