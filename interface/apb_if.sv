//////////////////////////////////////////////////////////////////////////
// file name : apb_if.sv
// description : apb interface
// Engineer : Ashish Memane
//////////////////////////////////////////////////////////////////////////
//`timescale 1ns / 1ps

interface apb_if #(parameter int WIDTH = 32, SLAVE = 4) ( input Hclk, input Hresetn);

        // signal declarations
        logic [WIDTH-1:0] Paddr;
        logic Pwrite;
        logic [SLAVE-1:0] Pselx;
        logic Penable;
        logic [WIDTH-1:0] Pwdata;
        logic [WIDTH-1:0] Prdata;


        // clocking blocks
        clocking apb_drv_cb @(posedge Hclk);
                default input #1 output #1;
                input Paddr;
                input Pwrite;
                input Pselx;
                input Penable;
                input Pwdata;
                output Prdata;
        endclocking : apb_drv_cb

        clocking apb_mon_cb @(posedge Hclk);
                default input #1 output #1;
                input Paddr;
                input Pwrite;
                input Pselx;
                input Penable;
                input Pwdata;
                input Prdata;
        endclocking : apb_mon_cb

endinterface : apb_if
