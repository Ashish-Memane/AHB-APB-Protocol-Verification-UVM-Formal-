//////////////////////////////////////////////////////////////////////////////////
// File Name: ahb_if.sv
// Description: Physical SystemVerilog interface for the AHB-to-APB Bridge.
//              Contains clocking blocks and modports for the testbench.
// Engineer : Ashish Memane
//////////////////////////////////////////////////////////////////////////////////

//`timescale 1ns / 1ps

interface ahb_if #(parameter int WIDTH = 32) (input bit Hclk, input logic Hresetn);


    //-------------------------------------------------------------------------
    // Signal Declarations
    //-------------------------------------------------------------------------
    //  logic        Hresetn;

    // AHB Master Signals
    logic [1:0]  Htrans;
    logic [2:0]  Hsize;
    logic        Hreadyin;
    logic [WIDTH-1:0] Hwdata;
    logic [WIDTH-1:0] Haddr;
    logic        Hwrite;
    logic [2:0] Hburst;

    // Bridge Outputs to AHB Master
    logic [WIDTH-1:0] Hrdata;
    logic [1:0]  Hresp;
    logic        Hreadyout;

    //-------------------------------------------------------------------------
    // Clocking Blocks
    //-------------------------------------------------------------------------

    // AHB Driver Clocking Block (Active Master)
    clocking ahb_drv_cb @(posedge Hclk);
        default input #1ns output #1ns;
        output Htrans;
        output Hburst;
        output Hsize;
        output Hreadyin;
        output Hwdata;
        output Haddr;
        output Hwrite;
        input  Hrdata;
        input  Hresp;
        input  Hreadyout;
    endclocking

    // AHB Monitor Clocking Block (Passive Observer)
    clocking ahb_mon_cb @(posedge Hclk);
        default input #1ns output #1ns;
        input Htrans;
        input Hburst;
        input Hsize;
        input Hreadyin;
        input Hwdata;
        input Haddr;
        input Hwrite;
        input Hrdata;
        input Hresp;
        input Hreadyout;
    endclocking

    //-------------------------------------------------------------------------
    // Modports (Kept for design consistency, but UVM will use un-modported VIF)
    //-------------------------------------------------------------------------
    modport ahb_drv_mp (clocking ahb_drv_cb);
    modport ahb_mon_mp (clocking ahb_mon_cb);

endinterface : ahb_if
