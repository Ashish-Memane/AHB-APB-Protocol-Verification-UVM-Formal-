////////////////////////////////////////////////////////////////////
// file name : ahb_driver.sv
// description : ahb driver
// Engineer : Ashish Memane
////////////////////////////////////////////////////////////////////

class ahb_driver #(parameter int WIDTH = 32) extends uvm_driver #(ahb_xtn#(WIDTH));

        // factory registraion
        `uvm_component_param_utils(ahb_driver#(WIDTH))

        // virtual interface
        virtual ahb_if#(WIDTH) vif;

        int ahb_drv_pkts = 0;

        int i;

        // constructor
        function new(string name = "ahb_driver", uvm_component parent = null);
                super.new(name,parent);
        endfunction : new

        // build phase
        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                // getting virtual interface
                if(!uvm_config_db#(virtual ahb_if#(WIDTH))::get(this,"","ahb_if",vif)) begin
                        `uvm_fatal(get_type_name(),"Cannot the the virtual interface")
                end
        endfunction : build_phase

        // task run phase
        task run_phase(uvm_phase phase);
                forever begin
                        seq_item_port.get_next_item(req);
                        send_to_dut(req);
                        seq_item_port.item_done();
                end
        endtask : run_phase


        task send_to_dut(ahb_xtn#(WIDTH) xtn);

                // 1. Variable declaration must be at the very top
                logic [WIDTH-1:0] current_addr;
                current_addr = xtn.Haddr;

                `uvm_info(get_type_name(), $sformatf("AHB DRIVER : \n%s", xtn.sprint()), UVM_LOW)

                // --- 1st ADDRESS PHASE (Beat 0) ---
                @(vif.ahb_drv_cb);
                wait(vif.ahb_drv_cb.Hreadyout == 1);

                vif.ahb_drv_cb.Haddr    <= current_addr;
                vif.ahb_drv_cb.Hwrite   <= xtn.Hwrite;
                vif.ahb_drv_cb.Hsize    <= xtn.Hsize;
                vif.ahb_drv_cb.Hburst   <= xtn.Hburst;
                vif.ahb_drv_cb.Htrans   <= 2'b10; // NONSEQ for the first beat
                vif.ahb_drv_cb.Hreadyin <= 1'b1;

                // --- PIPELINED LOOP ---
                for(int i = 0; i < xtn.length; i++) begin
                        @(vif.ahb_drv_cb);
                        wait(vif.ahb_drv_cb.Hreadyout == 1);

                        // 1. DATA PHASE for the CURRENT beat (i)
                        if(xtn.Hwrite) begin
                                vif.ahb_drv_cb.Hwdata <= xtn.Hwdata[i]; // Array indexing!
                        end

                        // 2. ADDRESS PHASE for the NEXT beat (i+1)
                        // (Only do this if we haven't reached the end of the burst)
                        if(i < (xtn.length - 1)) begin
                                current_addr = current_addr + (1 << xtn.Hsize); // Math!
                                vif.ahb_drv_cb.Haddr  <= current_addr;
                                vif.ahb_drv_cb.Htrans <= 2'b11; // SEQ for subsequent beats
                        end else begin
                                // If this is the last beat, drop the bus to IDLE
                                vif.ahb_drv_cb.Htrans <= 2'b00;
                        end
                end

                ahb_drv_pkts++;
        endtask : send_to_dut


        // report phase
        function void report_phase(uvm_phase phase);
                `uvm_info(get_type_name(),$sformatf("AHB DRIVER PACKETS : %d", ahb_drv_pkts),UVM_LOW)
        endfunction : report_phase

endclass : ahb_driver
