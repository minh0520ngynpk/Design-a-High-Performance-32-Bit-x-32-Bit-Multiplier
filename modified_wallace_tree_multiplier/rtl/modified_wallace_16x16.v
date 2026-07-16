module modified_wallace_16x16 (
    input  wire [15:0] A,
    input  wire [15:0] B,
    output wire [31:0] Out
);
    wire [31:0] pp [0:15];
    genvar i, j;

    //16 rows partial products
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_pp
            assign pp[i] = ((B[i] ? {16'b0, A} : 32'b0) << i);
        end
    endgenerate
    //16 hang, moi hang 32b.
    //Dem tung bit B, neu B[i] = 1, lay A, B[i] = 0, lay 0
    //dich i bit tao hinh tam giac nguoc

    //Compress 16 -> 11
    wire [31:0] stg1 [0:10]; //11 hàng 
    generate
        for (i = 0; i < 5; i = i + 1) begin : stage1_comp 
            //16/3 được 5 nhóm dư 1 i < 5 
            for (j = 0; j < 31; j = j + 1) begin : bit_slice
                mux_32_compressor u (
                    .x1(pp[3*i][j]), 
                    .x2(pp[3*i+1][j]), 
                    .x3(pp[3*i+2][j]),
                    .sum(stg1[2*i][j]), 
                    .carry(stg1[2*i+1][j+1])
                );
            end
            assign stg1[2*i][31]   = pp[3*i][31] ^ pp[3*i+1][31] ^ pp[3*i+2][31];
            assign stg1[2*i+1][0]  = 1'b0;
        end
    endgenerate
    assign stg1[10] = pp[15]; 

    //Compress 11 -> 8
    wire [31:0] stg2 [0:7];
    generate
        for (i = 0; i < 3; i = i + 1) begin : stage2_comp
            //11:3 được 3 dư 2 i < 3 
            for (j = 0; j < 31; j = j + 1) begin : bit_slice
                mux_32_compressor u (
                    .x1(stg1[3*i][j]), 
                    .x2(stg1[3*i+1][j]), 
                    .x3(stg1[3*i+2][j]),
                    .sum(stg2[2*i][j]), 
                    .carry(stg2[2*i+1][j+1])
                );
            end
            assign stg2[2*i][31]   = stg1[3*i][31] ^ stg1[3*i+1][31] ^ stg1[3*i+2][31];
            assign stg2[2*i+1][0]  = 1'b0;
        end
    endgenerate
    assign stg2[6] = stg1[9];  
    assign stg2[7] = stg1[10]; 

    //Compress 8 -> 6
    wire [31:0] stg3 [0:5];
    generate
        for (i = 0; i < 2; i = i + 1) begin : stage3_comp
            for (j = 0; j < 31; j = j + 1) begin : bit_slice
                mux_32_compressor u (
                    .x1(stg2[3*i][j]), 
                    .x2(stg2[3*i+1][j]), 
                    .x3(stg2[3*i+2][j]),
                    .sum(stg3[2*i][j]), 
                    .carry(stg3[2*i+1][j+1])
                );
            end
            assign stg3[2*i][31]   = stg2[3*i][31] ^ stg2[3*i+1][31] ^ stg2[3*i+2][31];
            assign stg3[2*i+1][0]  = 1'b0;
        end
    endgenerate
    assign stg3[4] = stg2[6];
    assign stg3[5] = stg2[7];

    //Compress 6 -> 4
    wire [31:0] stg4 [0:3];
    generate
        for (i = 0; i < 2; i = i + 1) begin : stage4_comp
            for (j = 0; j < 31; j = j + 1) begin : bit_slice
                mux_32_compressor u (
                    .x1(stg3[3*i][j]), 
                    .x2(stg3[3*i+1][j]), 
                    .x3(stg3[3*i+2][j]),
                    .sum(stg4[2*i][j]), 
                    .carry(stg4[2*i+1][j+1])
                );
            end
            assign stg4[2*i][31]   = stg3[3*i][31] ^ stg3[3*i+1][31] ^ stg3[3*i+2][31];
            assign stg4[2*i+1][0]  = 1'b0;
        end
    endgenerate

    //Compress 4 -> 3
    wire [31:0] stg5 [0:2];
    generate
        for (j = 0; j < 31; j = j + 1) begin : stage5_comp
            mux_32_compressor u (
                .x1(stg4[0][j]), 
                .x2(stg4[1][j]), 
                .x3(stg4[2][j]),
                .sum(stg5[0][j]), 
                .carry(stg5[1][j+1])
            );
        end
        assign stg5[0][31]  = stg4[0][31] ^ stg4[1][31] ^ stg4[2][31];
        assign stg5[1][0]   = 1'b0;
    endgenerate
    assign stg5[2] = stg4[3];

    //Compress 3 -> 2
    wire [31:0] stg6 [0:1];
    generate
        for (j = 0; j < 31; j = j + 1) begin : stage6_comp
            mux_32_compressor u (
                .x1(stg5[0][j]), 
                .x2(stg5[1][j]), 
                .x3(stg5[2][j]),
                .sum(stg6[0][j]), 
                .carry(stg6[1][j+1])
            );
        end
        assign stg6[0][31]  = stg5[0][31] ^ stg5[1][31] ^ stg5[2][31];
        assign stg6[1][0]   = 1'b0;
    endgenerate

    //Final Adder 16x16
    assign Out = stg6[0] + stg6[1];
    //stg6[1] = sum
    //stg6[1] = carry
endmodule
