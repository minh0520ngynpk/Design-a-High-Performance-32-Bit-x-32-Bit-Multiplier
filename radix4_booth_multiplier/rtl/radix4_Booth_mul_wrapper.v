module radix4_Booth_mul_wrapper (
    input  wire        clk,
    input  wire [31:0] m_in,
    input  wire [31:0] n_in,
    output reg  [63:0] o_out
);

reg signed [31:0] m_reg;
reg signed [31:0] n_reg;
wire signed [63:0] out_wire;

always @(posedge clk) begin
    m_reg <= m_in;
    n_reg <= n_in;
    o_out <= out_wire;
end

radix4_Booth_mul #(
    .numBit(32) 
) core_radix4 (
    .M(m_reg),
    .N(n_reg),
    .Q(out_wire)
);

endmodule
