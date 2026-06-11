//////////////////////////////////////////////////////////////////////
// file name : scoreboard.sv
// description : ahb apb scoreboard with functional coverage
// Engineer : Ashish Memane
//////////////////////////////////////////////////////////////////////

class scoreboard #(parameter int WIDTH = 32, SLAVE = 4) extends uvm_scoreboard;

        // factory registraion
        `uvm_component_param_utils(scoreboard#(WIDTH, SLAVE))

        // declaration of the tlm fifo
        uvm_tlm_analysis_fifo #(apb_xtn#(WIDTH, SLAVE)) apb_fifo;
        uvm_tlm_analysis_fifo #(ahb_xtn#(WIDTH)) ahb_fifo;

        // properties
        int read_pkts = 0;
        int write_pkts = 0;

        // Coverage sampling variables
        ahb_xtn#(WIDTH) cov_ahb_tx;
        apb_xtn#(WIDTH, SLAVE) cov_apb_tx;

        // ============================================================================
        // COVERGROUP DEFINITION
        // ============================================================================
        covergroup ahb_apb_cg;
                option.per_instance = 1;

                // 1. Coverage for Write vs Read
                cp_hwrite : coverpoint cov_ahb_tx.Hwrite {
                        bins READ  = {0};
                        bins WRITE = {1};
                }

                // 2. Coverage for Transfer Size
                cp_hsize : coverpoint cov_ahb_tx.Hsize {
                        bins BYTE     = {3'b000};
                        bins HALFWORD = {3'b001};
                        bins WORD     = {3'b010};
                }

                // 3. Coverage for Burst Types
                cp_hburst : coverpoint cov_ahb_tx.Hburst {
                        bins SINGLE = {3'b000};
                        bins INCR   = {3'b001};
                        bins WRAP4  = {3'b010};
                        bins INCR4  = {3'b011};
                        bins WRAP8  = {3'b100};
                        bins INCR8  = {3'b101};
                }

                // 4. Coverage for Peripheral Slave Addresses (Based on Test Plan)
                cp_slave_select : coverpoint cov_apb_tx.Paddr[31:16] {
                        bins GPIO = {16'h0000};
                        bins UART = {16'h0001};
                        bins SPI  = {16'h0002};
                }

                // 5. Cross Coverage: Ensure every burst type is both read and written
                cr_write_burst : cross cp_hwrite, cp_hburst;
                
        endgroup : ahb_apb_cg

        // constructor
        function new(string name = "scoreboard", uvm_component parent = null);
                super.new(name,parent);

                apb_fifo = new("apb_fifo", this);
                ahb_fifo = new("ahb_fifo", this);

                // Instantiate the covergroup
                ahb_apb_cg = new();
        endfunction : new

        // task run phase
        task run_phase(uvm_phase phase);
                forever begin
                        ahb_xtn#(WIDTH) ahb_tx;

                        // 1. Get ONE full burst transaction from the AHB Master
                        ahb_fifo.get(ahb_tx);

                        // 2. Filter out internal bridge config registers (Bridge eats these)
                        if(ahb_tx.Haddr >= 'h00 && ahb_tx.Haddr <= 'h08) begin
                                `uvm_info(get_type_name(), $sformatf("Config Register Bypass: Addr=%0h", ahb_tx.Haddr), UVM_LOW)
                        end
                        // 3. Normal Slave Access -> Send to checker
                        else begin
                                check_data(ahb_tx);
                        end
                end
        endtask : run_phase

        // check the data
        task check_data(ahb_xtn#(WIDTH) ahb_tx);
                apb_xtn#(WIDTH, SLAVE) apb_tx;
                logic [WIDTH-1:0] expected_addr;

                // Initialize our tracking address with the starting address of the burst
                expected_addr = ahb_tx.Haddr;

                // UNROLL THE BURST
                for(int i = 0; i < ahb_tx.length; i++) begin

                        // Wait for the single APB beat to arrive
                        apb_fifo.get(apb_tx);

                        // --- UPDATE COVERAGE VARIABLES & SAMPLE ---
                        cov_ahb_tx = ahb_tx;
                        cov_apb_tx = apb_tx;
                        ahb_apb_cg.sample();

                        // --- ADDRESS COMPARISON ---
                        if(expected_addr == apb_tx.Paddr) begin
                                `uvm_info(get_type_name(), $sformatf("[ADDR MATCH] Beat %0d: Expected=%0h, Actual=%0h", i, expected_addr, apb_tx.Paddr), UVM_HIGH)
                        end else begin
                                `uvm_error(get_type_name(), $sformatf("[ADDR MISMATCH] Beat %0d: Expected=%0h, Actual=%0h", i, expected_addr, apb_tx.Paddr))
                        end

                        // --- DATA COMPARISON ---
                        if(ahb_tx.Hwrite == 1) begin
                                // WRITE: Compare AHB write array to APB write scalar
                                if(ahb_tx.Hwdata[i] == apb_tx.Pwdata) begin
                                        `uvm_info(get_type_name(), $sformatf("[WRITE MATCH] Beat %0d: Data=%0h", i, apb_tx.Pwdata), UVM_HIGH)
                                        write_pkts++; // INCREMENT COUNTER
                                end else begin
                                        `uvm_error(get_type_name(), $sformatf("[WRITE MISMATCH] Beat %0d: AHB=%0h, APB=%0h", i, ahb_tx.Hwdata[i], apb_tx.Pwdata))
                                end
                        end else begin
                                // READ: Compare AHB read array to APB read scalar
                                if(ahb_tx.Hrdata[i] == apb_tx.Prdata) begin
                                        `uvm_info(get_type_name(), $sformatf("[READ MATCH] Beat %0d: Data=%0h", i, apb_tx.Prdata), UVM_HIGH)
                                        read_pkts++; // INCREMENT COUNTER
                                end else begin
                                        `uvm_error(get_type_name(), $sformatf("[READ MISMATCH] Beat %0d: AHB=%0h, APB=%0h", i, ahb_tx.Hrdata[i], apb_tx.Prdata))
                                end
                        end

                        // --- CALCULATE NEXT EXPECTED ADDRESS ---
                        expected_addr = expected_addr + (1 << ahb_tx.Hsize);
                end

        endtask : check_data

        // report phase
        function void report_phase(uvm_phase phase);
                `uvm_info(get_type_name(),$sformatf("write pkt count : %0d ||| read pkt count : %0d", write_pkts, read_pkts), UVM_LOW)
                // Print coverage percentage at the end of the simulation
                `uvm_info(get_type_name(), $sformatf("Scoreboard Functional Coverage: %0.2f%%", ahb_apb_cg.get_inst_coverage()), UVM_LOW)
        endfunction : report_phase

endclass : scoreboard
