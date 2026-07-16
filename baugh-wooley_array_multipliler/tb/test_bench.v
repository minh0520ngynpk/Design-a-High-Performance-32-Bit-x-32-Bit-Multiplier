`timescale 1ns / 1ps

module test_bench;

    parameter numBit = 32;

    //internal signal
    reg signed  [numBit-1:0]   A;
    reg signed  [numBit-1:0]   B;
    wire signed [2*numBit-1:0] Q;
    wire signed [2*numBit-1:0] expected_Q;

    integer i;
    integer error_count;

    bw_multiplier_s #(
        .numBit(numBit)
    ) uut (
        .m_in(A),
        .n_in(B),
        .o_out(Q)
    );

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, test_bench); 
end

//Golden model
assign expected_Q = $signed(A) * $signed(B);

initial begin
    error_count = 0;
    $display("======================================");
    $display("TESTING 32-BIT BAUGH_WOOLEY_MULTIPLIER");
    $display("======================================");

    //corner testcases
    $display("\nRunning corner testcases...");
    test_case(32'h7FFFFFFF, 32'h7FFFFFFF); //max x max
    test_case(32'h80000000, 32'h80000000); //min x min
    test_case(32'h80000000, 32'h7FFFFFFF); //min x max
    test_case(32'hFFFFFFFF, 32'hFFFFFFFF); //-1 x -1 = 1
    test_case(32'hFFFFFFFF, 32'h00000000); //-1 x 0 = 0
    test_case(32'h00000000, 32'h00000000); //0 x 0 = 0
    test_case(32'h00000001, 32'h00000000); //1 x 1 = 1
    test_case(32'h00000001, 32'hFFFFFFFF); //1 x -1 = -1

    //random testcases
    $display("\nRunning 100 random signed testcases...");
    for (i = 0; i < 100; i = i + 1) begin
        A = $random;
        B = $random;
        #10;
        if (Q == expected_Q) begin
            $display("[PASS] %0d: A=%0d | B=%0d | Q=%0d | Exp=%0d", i, A, B, Q, expected_Q);
        end else begin
            $display("[FAIL] %0d: A=%0d | B=%0d | Q=%0d | Exp=%0d", i, A, B, Q, expected_Q);
            error_count = error_count + 1;
            $stop;
        end
    end

    $display("=======================================");
    $display("SIMULATION FINISHED");
    $display("=======================================");
    
    if (error_count == 0) begin
        $display("PASSED ALL TESTCASES");
    end else begin
        $display("FAIL %0d TESTCASES PLEASE CHECK AGAIN", error_count);
    end
    $display("=======================================");

    #100;
    $finish;
end

task test_case;
    input signed [31:0] test_A;
    input signed [31:0] test_B;
    begin
        A = test_A;
        B = test_B;
        #10;

        if (Q !== expected_Q) begin
            $display("[FAIL] A=%0d | B=%0d | Q=%0d | Exp=%0d", A, B, Q, expected_Q);
            error_count = error_count + 1;
            $stop;
        end else begin
            $display("[PASS] A=%0d | B=%0d | Q=%0d | Exp=%0d", A, B, Q, expected_Q);
        end
    end
endtask

endmodule
