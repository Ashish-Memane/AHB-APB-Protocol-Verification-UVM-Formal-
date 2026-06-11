/////////////////////////////////////////////////////////////////////////////////
// file name : ahb_apb_test_lib.sv
// description : base and extended test cases for the bridge rtl
// Engineer : Ashish Memane
/////////////////////////////////////////////////////////////////////////////////

class base_test #(parameter int WIDTH = 32, int SLAVE = 4) extends uvm_test;

        // factory registration
        `uvm_component_param_utils(base_test#(WIDTH, SLAVE))

        // component handles
        env#(WIDTH, SLAVE) env_h;
        env_config m_cfg;

        // constructor
        function new(string name = "base_test", uvm_component parent = null);
                super.new(name,parent);
        endfunction : new

        // build phase
        function void build_phase(uvm_phase phase);
                super.build_phase(phase);

                m_cfg = env_config::type_id::create("m_cfg");

                m_cfg.ahb_is_active = UVM_ACTIVE;
                m_cfg.apb_is_active = UVM_ACTIVE;

                env_h = env#(WIDTH, SLAVE)::type_id::create("env_h", this);

                uvm_config_db#(env_config)::set(this,"*","env_config", m_cfg);

        endfunction : build_phase

        // end of elaboration phase
        function void end_of_elaboration_phase(uvm_phase phase);
                super.end_of_elaboration_phase(phase);

                uvm_top.print_topology();

        endfunction : end_of_elaboration_phase

endclass : base_test

// =========================================================================
// 2. SPECIFIC TESTS
// =========================================================================

// --- Single Write Test ---
class test_single_write #(parameter int WIDTH = 32, int SLAVE = 4) extends base_test#(WIDTH, SLAVE);
        `uvm_component_param_utils(test_single_write#(WIDTH, SLAVE))

        ahb_single_write_seq#(WIDTH)       ahb_seq;
        apb_dummy_seq#(WIDTH, SLAVE)       apb_seq;

        function new(string name = "test_single_write", uvm_component parent = null);
                super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
                ahb_seq = ahb_single_write_seq#(WIDTH)::type_id::create("ahb_seq");
                apb_seq = apb_dummy_seq#(WIDTH, SLAVE)::type_id::create("apb_seq");

                phase.raise_objection(this);
                fork
                        apb_seq.start(env_h.apb_agt.seqr);
                        begin
                                ahb_seq.start(env_h.ahb_agt.seqr);
                        end
                join_any
                phase.drop_objection(this);
        endtask
endclass : test_single_write

// --- Burst Test (INCR4) ---
class test_incr4_burst #(parameter int WIDTH = 32, int SLAVE = 4) extends base_test#(WIDTH, SLAVE);
        `uvm_component_param_utils(test_incr4_burst#(WIDTH, SLAVE))

        ahb_incr4_seq#(WIDTH)   ahb_seq;

        function new(string name = "test_incr4_burst", uvm_component parent = null);
                super.new(name, parent);
        endfunction : new

        task run_phase(uvm_phase phase);
                ahb_seq = ahb_incr4_seq#(WIDTH)::type_id::create("ahb_seq");

                phase.raise_objection(this);

                        ahb_seq.start(env_h.ahb_agt.seqr);

                phase.drop_objection(this);

        endtask : run_phase

endclass : test_incr4_burst
