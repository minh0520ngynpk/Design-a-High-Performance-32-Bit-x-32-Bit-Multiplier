module Booth_decoder #(
    parameter WIDTH = 32
)(
    input  wire [(WIDTH/2)*3 - 1 : 0] seq_in, 
    input  wire [WIDTH-1:0] M,               

    output reg  [(WIDTH/2)*(WIDTH+1) - 1 : 0] extended_out, 
    output reg  [WIDTH/2 - 1 : 0] sgn_out,                  
    output reg  [WIDTH/2 - 1 : 0] e_out                     
);

    localparam NUM_SEQ = WIDTH / 2;     
    localparam PP_WIDTH = WIDTH + 1;    

    wire multiplicand_sign = M[WIDTH-1];

    integer i;
    reg [2:0] seq;

    always @(*) begin
        for (i = 0; i < NUM_SEQ; i = i + 1) begin
            // Đã fix: Dùng Indexed Part Select (+:) để cắt 3 bit
            seq = seq_in[i*3 +: 3];

            case (seq)
                3'b000, 3'b111: begin
                    extended_out[i*PP_WIDTH +: PP_WIDTH] = {PP_WIDTH{1'b0}};
                    sgn_out[i] = 0; 
                    e_out[i]   = 1;
                end
                
                3'b001, 3'b010: begin // +1M
                    extended_out[i*PP_WIDTH +: PP_WIDTH] = {M[WIDTH-1], M}; 
                    sgn_out[i] = 0;
                    e_out[i]   = ~(multiplicand_sign ^ 1'b0);
                end
                
                3'b011: begin // +2M
                    extended_out[i*PP_WIDTH +: PP_WIDTH] = {M, 1'b0}; 
                    sgn_out[i] = 0;
                    e_out[i]   = ~(multiplicand_sign ^ 1'b0);
                end
                
                3'b100: begin // -2M
                    extended_out[i*PP_WIDTH +: PP_WIDTH] = ~{M, 1'b0}; 
                    sgn_out[i] = 1;
                    e_out[i]   = ~(multiplicand_sign ^ 1'b1);
                end
                
                3'b101, 3'b110: begin // -1M
                    extended_out[i*PP_WIDTH +: PP_WIDTH] = ~{M[WIDTH-1], M}; 
                    sgn_out[i] = 1;
                    e_out[i]   = ~(multiplicand_sign ^ 1'b1);
                end
                
                default: begin
                    extended_out[i*PP_WIDTH +: PP_WIDTH] = {PP_WIDTH{1'b0}};
                    sgn_out[i] = 0;
                    e_out[i]   = 1;
                end
            endcase
        end
    end

endmodule
