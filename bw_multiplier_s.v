module bw_multiplier_s #(parameter numBit = 32)
(
    input  wire [numBit-1:0]   m_in,
    input  wire [numBit-1:0]   n_in,
    output wire [2*numBit-1:0] o_out
);

    //INTERNAL SIGNAL
    wire [2*numBit-1:0] support_matrix [0:numBit-1];
    wire [numBit-1:0]   carry_vector;
    wire [numBit-1:0]   sum_vector;

    //GENERATE NESTED LOOP
    genvar i, j;
    generate
        for(i = 0; i < numBit; i = i + 1) begin : row_loop
            for(j = 0; j < numBit; j = j + 1) begin : col_loop
                
                if(j == numBit-1 && i == numBit-1) begin : c1
                    //phep nhan 2 bit dau, am x am = duong khong dao bit 
                    and_bw_block u0 (.a_in(n_in[numBit-1]), .b_in(m_in[numBit-1]), .c_in(1'b0), .s_in(1'b0), .s_out(support_matrix[i][2*j]), .c_out(support_matrix[i][2*j+1]));
                end

                else if(j == numBit-1) begin : c2
                    nand_bw_block v0 (.a_in(n_in[i]), .b_in(m_in[numBit-1]), .c_in(1'b0), .s_in(1'b0), .s_out(support_matrix[i][2*j]), .c_out(support_matrix[i][2*j+1]));
                end

                else if(i == numBit-1) begin : c3
                    nand_bw_block w0 (.a_in(n_in[numBit-1]), .b_in(m_in[j]), .c_in(support_matrix[i-1][2*j+1]), .s_in(support_matrix[i-1][2*j+2]), .s_out(support_matrix[i][2*j]), .c_out(support_matrix[i][2*j+1]));
                end

                else if(i == 0) begin : c4
                    if(j == numBit-1) begin : c4_1
                        nand_bw_block w0 (.a_in(n_in[0]), .b_in(m_in[numBit-1]), .c_in(1'b0), .s_in(1'b0), .s_out(support_matrix[i][2*j]), .c_out(support_matrix[i][2*j+1]));
                    end else begin : c4_2
                        and_bw_block u0 (.a_in(n_in[0]), .b_in(m_in[j]), .c_in(1'b0), .s_in(1'b0), .s_out(support_matrix[i][2*j]), .c_out(support_matrix[i][2*j+1]));
                    end
                end

                else begin : c5
                    and_bw_block z0 (.a_in(n_in[i]), .b_in(m_in[j]), .c_in(support_matrix[i-1][2*j+1]), .s_in(support_matrix[i-1][2*j+2]), .s_out(support_matrix[i][2*j]), .c_out(support_matrix[i][2*j+1]));
                end
            end
        end
    endgenerate

    //LAST FULL ADDER ROW
    genvar t;
    generate
        for(t = 0; t < numBit; t = t + 1) begin : rca_loop
            
            wire fa_b;
            assign fa_b = support_matrix[numBit-1][2*t+1];

            if(t == 0) begin : rca_first
                wire fa_cin_first;
                assign fa_cin_first = support_matrix[numBit-1][2*t+2];
                full_adder fa_last (.a(1'b1), .b(fa_b), .cin(fa_cin_first), .sum(sum_vector[t]), .cout(carry_vector[t]));
            end
            else if(t == numBit-1) begin : rca_last
                full_adder fa_last (.a(carry_vector[t-1]), .b(fa_b), .cin(1'b1), .sum(sum_vector[t]), .cout(carry_vector[t]));
            end
            else begin : rca_mid
                wire fa_cin_mid;
                assign fa_cin_mid = support_matrix[numBit-1][2*t+2];
                full_adder fa_last (.a(carry_vector[t-1]), .b(fa_b), .cin(fa_cin_mid), .sum(sum_vector[t]), .cout(carry_vector[t]));
            end
        end
    endgenerate

    //GENERATE OUTPUT ASSIGNMENT
    genvar f;
    generate
        for(f = 0; f < 2*numBit; f = f + 1) begin : out_assign_loop
            if(f < numBit) begin : out_low
                assign o_out[f] = support_matrix[f][0];
            end else begin : out_high
                assign o_out[f] = sum_vector[f-numBit];
            end
        end
    endgenerate

endmodule
