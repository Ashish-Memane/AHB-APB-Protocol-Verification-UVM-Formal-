module rtl_top (
    // AHB Signals
    input  logic Hclk, Hresetn,
    input  logic [31:0] Haddr, Hwdata,
    input  logic [2:0] Hsize, Hburst,
    input  logic [1:0] Htrans,
    input  logic Hwrite, Hreadyin,
    output logic Hreadyout,
    output logic [31:0] Hrdata,
    output logic [1:0] Hresp,

    // APB Signals
    output logic [31:0] Paddr, Pwdata,
    output logic Pwrite, Penable,
    output logic [3:0] Pselx,
    input  logic [31:0] Prdata
);
    // STUB MODULE: No internal logic. 
    // Used strictly to allow UVM environment compilation.
    
    assign Hreadyout = 1'b1; // Prevent AHB driver from hanging
    assign Hresp = 2'b00;

endmodule
