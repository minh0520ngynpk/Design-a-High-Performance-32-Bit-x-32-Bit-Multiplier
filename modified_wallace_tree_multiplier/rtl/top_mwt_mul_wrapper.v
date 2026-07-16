module top_mwt_mul_wrapper(
    input wire clk,
    input wire [31:0] A,
    input wire [31:0] B,
    output reg [63:0] Q
);

//flip-flop ngo vao
reg [31:0] A_reg, B_reg;
wire [63:0] Q_wire;

//cap nhat du lieu rising edge clk
always @(posedge clk) begin
    A_reg <= A;
    B_reg <= B;
    Q <= Q_wire;
end

top_mwt_mul u_core(
    .A(A_reg),
    .B(B_reg),
    .Q(Q_wire)
);

endmodule
