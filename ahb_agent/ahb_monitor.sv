//////////////////////////////////////////////////////////////////////////////////
// file name : ahb_monitor.sv
// description : ahb monitor
// Engineer : Ashish Memane
//////////////////////////////////////////////////////////////////////////////////

class ahb_monitor #(parameter int WIDTH = 32) extends uvm_monitor;

        // factory registration
        `uvm_component_param_utils(ahb_monitor#(WIDTH))

        // virtual interface
        virtual ahb_if#(WIDTH) vif;

        ahb_xtn#(WIDTH) xtn;

        // monitor port
        uvm_analysis_port #(ahb_xtn#(WIDTH)) monitor_port;

        int ahb_mon_pkts = 0;

        // CONSTRUCTOR
        function new(string name = "ahb_monitor", uvm_component parent = null);
                super.new(name, parent);
                monitor_port = new("monitor_port",this);
        endfunction : new

        // build phase
        function void build_phase(uvm_phase phase);
                super.build_phase(phase);

                if(!uvm_config_db#(virtual ahb_if#(WIDTH))::get(this,"","ahb_if", vif)) begin
                        `uvm_fatal(get_type_name(),"Cannot get the vif")
                end
        endfunction : build_phase

        // run phase
        task run_phase (uvm_phase phase);
                forever begin
                        // 1. Wait for the clock edge defined in the clocking block
                        @(vif.ahb_mon_cb);

                        // 2. Check the condition using a standard IF statement
                        if (vif.ahb_mon_cb.Hreadyout == 1 && vif.ahb_mon_cb.Htrans == 2'b10) begin
                                collect_data();
                        end
                end
        endtask : run_phase

        // task collect data
        task collect_data();
                xtn = ahb_xtn#(WIDTH)::type_id::create("xtn");

                // --- 1. CAPTURE ADDRESS PHASE (Beat 0) ---
                xtn.Haddr  = vif.ahb_mon_cb.Haddr;
                xtn.Hwrite = vif.ahb_mon_cb.Hwrite;
                xtn.Hsize  = vif.ahb_mon_cb.Hsize;
                xtn.Hburst = vif.ahb_mon_cb.Hburst;

                // --- 2. DECODE THE BURST LENGTH ---
                case(xtn.Hburst)
                        3'b000: xtn.length = 1;  // SINGLE
                        3'b010, 3'b011: xtn.length = 4;  // WRAP4 / INCR4
                        3'b100, 3'b101: xtn.length = 8;  // WRAP8 / INCR8
                        3'b110, 3'b111: xtn.length = 16; // WRAP16 / INCR16
                        default: xtn.length = 1; // Default fallback
                endcase

                // --- 3. ALLOCATE THE ARRAYS ---
                xtn.Hwdata = new[xtn.length];
                xtn.Hrdata = new[xtn.length];
                xtn.Hresp  = new[xtn.length];

                // --- 4. PIPELINED CAPTURE LOOP ---
                for(int i = 0; i < xtn.length; i++) begin
                        @(vif.ahb_mon_cb);
                        wait(vif.ahb_mon_cb.Hreadyout == 1);

                        // We are now in the Data Phase for beat 'i'
                        if(xtn.Hwrite == 1) begin
                                xtn.Hwdata[i] = vif.ahb_mon_cb.Hwdata;
                        end else begin
                                xtn.Hrdata[i] = vif.ahb_mon_cb.Hrdata;
                        end
                        xtn.Hresp[i] = vif.ahb_mon_cb.Hresp;
                end

                // --- 5. BROADCAST ---
                `uvm_info(get_type_name(), $sformatf("AHB MONITOR CAUGHT BURST:\n%s", xtn.sprint()), UVM_LOW)
                monitor_port.write(xtn);
                ahb_mon_pkts++;

        endtask : collect_data

        // report phase
        function void report_phase(uvm_phase phase);
                `uvm_info(get_type_name(),$sformatf("AHB MON PKTS : %0d", ahb_mon_pkts),UVM_LOW)
        endfunction : report_phase

endclass : ahb_monitor
