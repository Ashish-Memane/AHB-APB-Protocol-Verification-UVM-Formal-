/////////////////////////////////////////////////////////////////////////////
// file name : ahb_agent.sv
// description : ahb agent
// Engineer : Ashish Memane
/////////////////////////////////////////////////////////////////////////////

class ahb_agent #(parameter int WIDTH = 32) extends uvm_agent;

        // factory registration
        `uvm_component_param_utils(ahb_agent#(WIDTH))

        // component handles
        ahb_driver#(WIDTH) drv;
        ahb_sequencer#(WIDTH) seqr;
        ahb_monitor#(WIDTH) mon;

        env_config m_cfg;

        // constructor
        function new(string name = "ahb_agent", uvm_component parent = null);
                super.new(name, parent);
        endfunction : new

        // build phase
        function void build_phase(uvm_phase phase);
                super.build_phase(phase);

                if(!uvm_config_db#(env_config)::get(this,"","env_config",m_cfg)) begin
                        `uvm_fatal(get_type_name(),"Cannot get the config")
                end

                // creating the components
                mon = ahb_monitor#(WIDTH)::type_id::create("mon", this);

                if(m_cfg.ahb_is_active == UVM_ACTIVE) begin
                        drv = ahb_driver#(WIDTH)::type_id::create("drv", this);
                        seqr = ahb_sequencer#(WIDTH)::type_id::create("seqr", this);
                end

        endfunction : build_phase

        // connect phase
        function void connect_phase(uvm_phase phase);
                super.connect_phase(phase);

                if(m_cfg.ahb_is_active == UVM_ACTIVE) begin
                        drv.seq_item_port.connect(seqr.seq_item_export);
                end

        endfunction : connect_phase

endclass : ahb_agent
