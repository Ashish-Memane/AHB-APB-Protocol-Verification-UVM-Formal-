/////////////////////////////////////////////////////////////////////////
// file name : env.sv
// description : ahb apb env class
/////////////////////////////////////////////////////////////////////////

class env #(parameter int WIDTH = 32, SLAVE = 4) extends uvm_env;

        // factory registration
        `uvm_component_param_utils(env#(WIDTH, SLAVE))

        // component handles
        ahb_agent#(WIDTH) ahb_agt;
        apb_agent#(WIDTH, SLAVE) apb_agt;

        scoreboard #(WIDTH, SLAVE) sb;

        env_config m_cfg;

        // constructor
        function new(string name = "env", uvm_component parent = null);
                super.new(name, parent);
        endfunction : new

        // build phase
        function void build_phase(uvm_phase phase);
                super.build_phase(phase);

                // get env config
                if(!uvm_config_db#(env_config)::get(this,"","env_config",m_cfg)) begin
                        `uvm_fatal(get_type_name(),"Cannot get the config object")
                end

                // creating the component
                ahb_agt = ahb_agent#(WIDTH)::type_id::create("ahb_agt", this);
                apb_agt = apb_agent#(WIDTH, SLAVE)::type_id::create("apb_agt", this);

                sb = scoreboard#(WIDTH, SLAVE)::type_id::create("sb", this);

                // setting the env config
                uvm_config_db#(env_config)::set(this,"*","env_config",m_cfg);

        endfunction : build_phase

        // connect phase
        function void connect_phase(uvm_phase phase);
                super.connect_phase(phase);
                ahb_agt.mon.monitor_port.connect(sb.ahb_fifo.analysis_export);
                apb_agt.mon.monitor_port.connect(sb.apb_fifo.analysis_export);

        endfunction : connect_phase

endclass : env
