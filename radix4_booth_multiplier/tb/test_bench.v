`timescale 1ns / 1ps

module test_bench;
    reg [31:0] M;
    reg [31:0] Q;
    wire [63:0] P;
    
//internal signals
reg [63:0] expected_P;
integer i;
integer error_count;
reg clk;

radix4_Booth_mul dut (
    .M(M),
    .Q(Q),
    .P(P)
);

initial begin
    clk = 0;
end

always #5 clk = ~clk;

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, test_bench);
    
    M = 32'd0;
    Q = 32'd0;
    error_count = 0;
    $display("==========================================");
    $display("TESTING 32-BIT RADIX-4 BOOTH MULTIPLIER...");
    $display("==========================================");
    
    //Checkerboard
    $display("\n Coner testcases...");
    test_mul(32'hFFFF_FFFF, 32'hFFFF_FFFF);
    test_mul(32'hAAAA_AAAA, 32'h5555_5555);
    test_mul(32'h1111_1111, 32'hBCBC_BCBC);
    
    //Boundaries
    test_mul(32'h8000_0000, 32'h8000_0000);
    test_mul(32'h7FFF_FFFF, 32'h7FFF_FFFF);
    test_mul(32'h7FFF_FFFF, 32'h8000_0000);
    
    test_mul(32'h0000_0000, 32'h0000_0000);
    test_mul(32'h1234_5678, 32'h0000_0000);
    test_mul(32'h8000_0000, 32'h0000_0001);
    test_mul(32'h7FFF_FFFF, 32'hFFFF_FFFF);

    //Asymetric
    test_mul(32'h0000_0003, 32'h7FFF_FFF3);
    test_mul(32'hFFFF_FFFD, 32'h0000_0005);


    //Random test
    $display("\n Random testcases...");
    for (i=0; i<100; i = i + 1) begin
        test_mul($random, $random);
    end
    
    $display("==================================================");
    if (error_count == 0) begin
    $display("[SUCCESS]: PASS ALL TESTCASES");
    $display("--- SIMULATION FINISHED ---");
    end else begin
    $display("[FAIL]: FAIL %0d TESTCASES COUNT", error_count);
    $display("--- SIMULATION FINISHED ---");
    end
    $display("==================================================");
        
    #100; 
    $finish;
end

task test_mul;
    input [31:0] test_M;
    input [31:0] test_Q;

begin
    @(posedge clk);
    #1;
    M = test_M;
    Q = test_Q;

    //golden model
    expected_P = $signed(test_M) * $signed(test_Q);
    #10;

    if (P !== expected_P) begin
        $display("[FAIL] Time: %0t | M = %h | Q = %h | P = %h | exp_P = %h", $time, M, Q, P, expected_P);
        error_count = error_count + 1;
    end else begin
        $display("[PASS] Time: %0t | M = %h | Q = %h | P = %h | exp_P = %h", $time, M, Q, P, expected_P);
    end
end
endtask

endmodule
