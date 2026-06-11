///////////////////////////////////////////////////////////
// file name : top.sv
// description : top testbench module
// Engineer : Ashish Memane
///////////////////////////////////////////////////////////

module top;

        // importing the pkgs
        import uvm_pkg::*;
        `include "uvm_macros.svh"
        import tb_pkg::*;

        // parameters
        parameter int WIDTH = 32;
        parameter int SLAVE = 4;

        // global signals
        bit clk;
        bit reset;

        // clock generation
        initial begin
                clk = 0;
                forever #5 clk = ~clk;
        end

        // reset genteration
        initial begin
                reset = 0;
                #20 reset = 1;
        end

        // interface instantiation
        ahb_if#(WIDTH) ahb_in(clk, reset);
        apb_if#(WIDTH, SLAVE) apb_in(clk, reset);

        // dut instantiation
        rtl_top  dut(
                        // ahb
                        .Hclk(clk),
                        .Hresetn(reset),
                        .Haddr(ahb_in.Haddr),
                        .Hsize(ahb_in.Hsize),
                        .Hburst(ahb_in.Hburst),
                        .Htrans(ahb_in.Htrans),
                        .Hwrite(ahb_in.Hwrite),
                        .Hreadyout(ahb_in.Hreadyout),
                        .Hwdata(ahb_in.Hwdata),
                        .Hrdata(ahb_in.Hrdata),
                        .Hreadyin(ahb_in.Hreadyin),
                        .Hresp(ahb_in.Hresp),

                        // apb
                        .Paddr(apb_in.Paddr),
                        .Pwrite(apb_in.Pwrite),
                        .Pselx(apb_in.Pselx),
                        .Penable(apb_in.Penable),
                        .Pwdata(apb_in.Pwdata),
                        .Prdata(apb_in.Prdata)
                        );

        // uvm config db
        initial begin
                uvm_config_db#(virtual ahb_if#(WIDTH))::set(null,"*","ahb_if",ahb_in);
                uvm_config_db#(virtual apb_if#(WIDTH, SLAVE))::set(null,"*","apb_if", apb_in);

        // run test
        run_test();

        end

endmodule : top
