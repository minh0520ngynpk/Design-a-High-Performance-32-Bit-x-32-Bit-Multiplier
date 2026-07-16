module radix4_Booth_mul(
    input  wire [31:0] M,
    input  wire [31:0] Q,
    output wire [63:0] P
);

    wire [47:0] seq_in; 
    wire [527:0] extended_out; 
    wire [15:0] sgn_out;
    wire [15:0] e_out;

    // Gọi Encoder
    Booth_encoder #(32) enc(
        .Q(Q),
        .seq_out(seq_in)
    );

    // Gọi Decoder
    Booth_decoder #(32) dec(
        .seq_in(seq_in),
        .M(M),
        .extended_out(extended_out),
        .sgn_out(sgn_out),
        .e_out(e_out)
    );

    reg [64:0] layers [0:16]; 
    reg [64:0] final_sum;

    integer i;
    always @(*) begin
        for (i = 0; i < 17; i = i + 1) begin
            layers[i] = 65'b0;
        end

        for (i = 0; i < 16; i = i + 1) begin
            // Nạp 33-bit Partial Product
            layers[i][2*i +: 33] = extended_out[i*33 +: 33];

            if (i == 0) begin
                // ĐÃ FIX BUGS: Đảo lại thứ tự thành ~e, ~e, e 
                layers[0][33] = ~e_out[0];
                layers[0][34] = ~e_out[0];
                layers[0][35] = e_out[0];
            end else begin
                // Các hàng dưới giữ nguyên
                layers[i][2*i + 33] = e_out[i];
                layers[i][2*i + 34] = 1'b1;
                // Ký gửi bit sgn
                layers[i][2*i - 2] = sgn_out[i-1];
            end
        end

        // Bit sgn cuối cùng của hàng 16
        layers[16][30] = sgn_out[15];

        // Nén song song
        final_sum = 65'b0;
        for (i = 0; i < 17; i = i + 1) begin
            final_sum = final_sum + layers[i];
        end
    end

    assign P = final_sum[63:0];

endmodule
