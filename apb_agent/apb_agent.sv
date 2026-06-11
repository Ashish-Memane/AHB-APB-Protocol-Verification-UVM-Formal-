///////////////////////////////////////////////////////////////////////////////
// file name : apb_agent.sv
// description : apb agent wraper
// Engineer : Ashish Memane
///////////////////////////////////////////////////////////////////////////////

class apb_agent #(parameter int WIDTH = 32, int SLAVE = 4) extends uvm_agent;

        // factory registration
        `uvm_component_param_utils(apb_agent#(WIDTH,SLAVE))

        // component handles
        apb_driver#(WIDTH, SLAVE) drv;
        apb_monitor#(WIDTH, SLAVE) mon;
        apb_sequencer#(WIDTH, SLAVE) seqr;

        // config object handle
        env_config m_cfg;

        // constructor
        function new(string name = "apb_agent", uvm_component parent = null);
                super.new(name, parent);
        endfunction : new

        // build phase
        function void build_phase(uvm_phase phase);
                super.build_phase(phase);

                if(!uvm_config_db#(env_config)::get(this,"","env_config",m_cfg)) begin
                        `uvm_fatal(get_type_name(),"Cannot get the config object");
                end

                mon = apb_monitor#(WIDTH, SLAVE)::type_id::create("mon", this);

                if(m_cfg.apb_is_active == UVM_ACTIVE) begin
                        drv = apb_driver#(WIDTH, SLAVE)::type_id::create("drv", this);
                        seqr = apb_sequencer#(WIDTH, SLAVE)::type_id::create("seqr", this);
                end

        endfunction : build_phase


        // connect phase
        function void connect_phase(uvm_phase phase);
                super.connect_phase(phase);

                if(m_cfg.apb_is_active == UVM_ACTIVE) begin
                        drv.seq_item_port.connect(seqr.seq_item_export);
                end
        endfunction : connect_phase

endclass : apb_agent
