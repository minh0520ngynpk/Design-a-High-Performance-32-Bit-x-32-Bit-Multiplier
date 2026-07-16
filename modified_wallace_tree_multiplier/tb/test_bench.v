`timescale 1ns / 1ps

module test_bench;

reg  [31:0] A;
reg  [31:0] B;
wire [63:0] Q;

//internal signal
reg [63:0] expected_Q;
integer i;
integer error_count;
reg clk;

top_mwt_mul dut (
   .A(A),
   .B(B),
   .Q(Q)
);

initial begin
    clk = 0;
end

always #5 clk = ~clk;

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, test_bench);

    A = 32'd0;
    B = 32'd0;
    error_count = 0;
    $display("==================================================    ");
    $display("TESTING 32-BIT MODIFIED WALLACE TREE MULTIPLIER...    ");
    $display("==================================================    ");

        //Direct test
        $display("Running Corner Cases...");
        
        test_mult(32'd0, 32'd0);
        
        test_mult(32'hFFFF_FFFF, 32'hFFFF_FFFF);
        
        test_mult(32'h0000_0001, 32'hFFFF_FFFF);
        
        test_mult(32'hFFFF_FFFF, 32'h0000_0001);
        
        test_mult(32'hAAAA_AAAA, 32'h5555_5555);
        
        test_mult(32'h8000_0000, 32'h0000_0001); // MSB = 1

        //Random test
        $display("\nRunning 100 Random Testcases...");
        for (i = 0; i < 100; i = i + 1) begin            
            @(posedge clk);
            #1;
            test_mult({$urandom, $urandom}, {$urandom, $urandom}); 
        end

        
        $display("==================================================");
        if (error_count == 0) begin
            $display("[SUCCESS]: PASS ALL TESTCASES");
            $display("SIMULATION FINISHED");
        end else begin 
            $display("[FAILED] FAIL %0d TESTCASES COUNT", error_count);
            $display("SIMULATION FINISHED");
        end
        $display("==================================================");
        
        #100
        $finish;
    end

task test_mult;
    input [31:0] test_A;
    input [31:0] test_B;
begin
    @(posedge clk);
    #1;
    A = test_A;
    B = test_B;
    
    //golden model
    expected_Q = test_A * test_B;
    #10;
            
    if (Q !== expected_Q) begin
        $display("[FAIL] Time: %0t | A = %h | B = %h | Q_out = %h | Q_exp = %h", $time, A, B, Q, expected_Q);
        error_count = error_count + 1;
        $stop;
    end else begin
        $display("[PASS] Time: %0t | A = %h | B = %h | Q = %h | Q_exp = %h", $time, A, B, Q, expected_Q);
    end
end
endtask

endmodule
