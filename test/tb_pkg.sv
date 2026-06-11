// ////////////////////////////////////////////////////////////////////////////
// File Name   : tb_pkg.sv
// Description : Testbench Package for AHB-to-APB VIP
// Engineer : Ashish Memane
// ////////////////////////////////////////////////////////////////////////////

package tb_pkg;

        // Import the base UVM library and macros first
        import uvm_pkg::*;
        `include "uvm_macros.svh"

        // ---------------------------------------------------------
        // 1. Configuration Objects
        // ---------------------------------------------------------
        `include "env_config.sv"

        // ---------------------------------------------------------
        // 2. Transactions (Sequence Items)
        // ---------------------------------------------------------
        `include "ahb_xtn.sv"
        `include "apb_xtn.sv"

        // ---------------------------------------------------------
        // 3. Sequences (Require Transactions)
        // ---------------------------------------------------------
        `include "ahb_seq_lib.sv"
        `include "apb_seq.sv"

        // ---------------------------------------------------------
        // 4. AHB Agent Components
        // ---------------------------------------------------------
        `include "ahb_sequencer.sv"
        `include "ahb_driver.sv"
        `include "ahb_monitor.sv"
        `include "ahb_agent.sv"

        // ---------------------------------------------------------
        // 5. APB Agent Components
        // ---------------------------------------------------------
        `include "apb_sequencer.sv"
        `include "apb_driver.sv"
        `include "apb_monitor.sv"
        `include "apb_agent.sv"

        // ---------------------------------------------------------
        // 6. Environment Components
        // ---------------------------------------------------------
        `include "scoreboard.sv" // Scoreboard needs xtns
        `include "env.sv"        // Env needs agents, config, and scoreboard

        // ---------------------------------------------------------
        // 7. Tests (The top of the class hierarchy)
        // ---------------------------------------------------------
        `include "ahb_apb_test_lib.sv"

endpackage : tb_pkg
