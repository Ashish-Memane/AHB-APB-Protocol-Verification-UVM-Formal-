//////////////////////////////////////////////////////////////////////////////////////
// file name : apb_monitor.sv
// description : apb monitor
// Engineer : Ashish Memane
//////////////////////////////////////////////////////////////////////////////////////

class apb_monitor #(parameter int WIDTH = 32, int SLAVE = 4) extends uvm_monitor;

        // factory registration
        `uvm_component_param_utils(apb_monitor#(WIDTH, SLAVE))

        // interface
        virtual apb_if#(WIDTH, SLAVE) vif;

        int apb_mon_pkts = 0;

        apb_xtn#(WIDTH,SLAVE) xtn;

        // analysis port
        uvm_analysis_port #(apb_xtn#(WIDTH,SLAVE)) monitor_port;

        // constructor
        function new(string name = "apb_monitor", uvm_component parent = null);
                super.new(name, parent);
                monitor_port = new("monitor_port",this);
        endfunction : new

        // build phase
        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(!uvm_config_db#(virtual apb_if#(WIDTH,SLAVE))::get(this,"","apb_if",vif))
                        `uvm_fatal(get_type_name(),"Cannot get the vif")
        endfunction : build_phase

        // run phase
        task run_phase(uvm_phase phase);
                forever begin
                        @(vif.apb_mon_cb);
                        if(vif.apb_mon_cb.Pselx != 0 && vif.apb_mon_cb.Penable == 1) begin
                                collect_data();
                        end
                end
        endtask : run_phase

        // collect data task
        task collect_data();
                xtn = apb_xtn#(WIDTH,SLAVE)::type_id::create("xtn");

                xtn.Paddr = vif.apb_mon_cb.Paddr;
                xtn.Pwrite = vif.apb_mon_cb.Pwrite;
                xtn.Pselx = vif.apb_mon_cb.Pselx;

                if(xtn.Pwrite == 1) begin
                        xtn.Pwdata = vif.apb_mon_cb.Pwdata;
                end else if(xtn.Pwrite == 0) begin
                        xtn.Prdata = vif.apb_mon_cb.Prdata;
                end

                `uvm_info(get_type_name(),$sformatf("APB MONITOR DATA : %s", xtn.sprint()),UVM_LOW)
                monitor_port.write(xtn);

                apb_mon_pkts++;

        endtask : collect_data

        // report phase
        function void report_phase(uvm_phase phase);
                `uvm_info(get_type_name(),$sformatf("APB MON PKTS : %0d",apb_mon_pkts),UVM_LOW)
        endfunction : report_phase


endclass : apb_monitor
