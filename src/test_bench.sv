module test_bench;
 logic [7:0] ui_in, uio_in;
 logic [7:0] uo_out, uio_out, uio_oe;
 logic ena, clk, rst_n;

 // Instantiate the stream_cypher module
 stream_cypher dut (
   .ui_in(ui_in),
   .uio_in(uio_in),
   .uo_out(uo_out),
   .uio_out(uio_out),
   .uio_oe(uio_oe),
   .ena(ena),
   .clk(clk),
   .rst_n(rst_n)
 );

 // Generate a clock signal
 always #5 clk = ~clk;

 // Initialize signals
 initial begin
   ui_in = 8'b0000_0000;
   uio_in = 8'b0000_0000;
   ena = 1'b1;
   rst_n = 1'b0;
   #10 rst_n = 1'b1;
 end

 // Apply stimulus
 initial begin
  // Test case 1: Test encryption and decryption
  ui_in = 8'b0000_0001;
  uio_in = 8'b000_0001;
  #10 assert(uo_out == 8'b0000_0001) else $error("Test case 1 failed");
 
  // Test case 2: Test viewing encrypted message
  uio_in = 8'b000_0010;
  #10 assert(uo_out == 8'b0000_0001) else $error("Test case 2 failed");
 
  // Test case 3: Test viewing decrypted message
  uio_in = 8'b000_0011;
  #10 assert(uo_out == 8'b0000_0000) else $error("Test case 3 failed");
 end
endmodule
