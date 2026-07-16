module Booth_encoder #(parameter WIDTH = 32
)(
    input wire [WIDTH-1:0] Q,
    output wire [(WIDTH/2)*3-1:0] seq_out
);

wire [WIDTH:0] extended_Q = {Q, 1'b0}; //extended to 33bits (32bit A + 1bit LSB)

//extract sequences
genvar i;
generate
    for (i=0; i<(WIDTH/2); i = i + 1) //16 pp generator
    begin
        assign seq_out[i*3 + 2 : i*3] = extended_Q[i*2 + 2 : i*2];
    end
endgenerate

endmodule
