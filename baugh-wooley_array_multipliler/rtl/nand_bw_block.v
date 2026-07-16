module nand_bw_block (
    input  wire a_in,
    input  wire b_in,
    input  wire c_in,
    input  wire s_in,
    output wire s_out,
    output wire c_out
);

wire inputs_nand_wire;

assign inputs_nand_wire = ~(a_in & b_in);

full_adder f0 (
    .a(inputs_nand_wire), 
    .b(c_in),             
    .cin(s_in),           
    .sum(s_out),          
    .cout(c_out)          
);

endmodule
