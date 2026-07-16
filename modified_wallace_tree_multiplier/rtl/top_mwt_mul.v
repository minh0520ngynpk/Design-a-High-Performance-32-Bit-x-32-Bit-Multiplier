module top_mwt_mul (
    input  wire [31:0] A,
    input  wire [31:0] B,
    output wire [63:0] Q
);

wire [31:0] q0, q1, q2, q3;

//4 modified wallace 16x16 (divide and conquer)
modified_wallace_16x16 m_q0 (.A(A[15:0]),  .B(B[15:0]),  .Out(q0));
modified_wallace_16x16 m_q1 (.A(A[15:0]),  .B(B[31:16]), .Out(q1));
modified_wallace_16x16 m_q2 (.A(A[31:16]), .B(B[15:0]),  .Out(q2));
modified_wallace_16x16 m_q3 (.A(A[31:16]), .B(B[31:16]), .Out(q3));

//first state adder
wire [47:0] left_sum;
wire [32:0] right_sum; 
    
assign left_sum  = {q3, 16'h0000} + {16'h0000, q2};
assign right_sum = q1 + {16'h0000, q0[31:16]}; // q0 lấy 16 bit cao

//second state adder
wire [47:0] final_sum;
assign final_sum = left_sum + right_sum;

assign Q = {final_sum, q0[15:0]};

endmodule
