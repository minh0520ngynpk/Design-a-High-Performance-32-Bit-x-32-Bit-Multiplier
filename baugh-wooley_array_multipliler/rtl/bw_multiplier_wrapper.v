module bw_multiplier_wrapper (
    input  wire        clk,
    input  wire [31:0] m_in,
    input  wire [31:0] n_in,
    output reg  [63:0] o_out
);

reg [31:0] m_reg, n_reg;
wire [63:0] out_wire;

always @(posedge clk) begin
    m_reg <= m_in;
    n_reg <= n_in;
    o_out <= out_wire;
end

bw_multiplier_s #(
    .numBit(32)
) core(
    .m_in(m_reg),
    .n_in(n_reg),
    .o_out(out_wire)
);

endmodule
