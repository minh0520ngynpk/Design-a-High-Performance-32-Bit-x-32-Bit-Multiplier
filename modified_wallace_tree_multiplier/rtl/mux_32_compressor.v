module mux_32_compressor (
    input  wire x1,
    input  wire x2,
    input  wire x3,
    output wire sum,
    output wire carry
);

//xor & xnor
wire xor_12  = x1 ^ x2;
wire xnor_12 = ~(x1 ^ x2);

//mux 2:1
assign sum   = (x3) ? xnor_12 : xor_12; 
assign carry = (xor_12) ? x3 : x1;

endmodule
