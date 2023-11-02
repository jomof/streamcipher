module test_bench;
 reg [7:0] ui_in;
 reg [7:0] uio_in;
 reg ena;
 reg clk;
 reg rst_n;
 wire [7:0] uo_out;
 wire [7:0] uio_out;
 wire [7:0] uio_oe;

 // Instantiate the DUT
 stream_cypher dut (
   .ui_in(ui_in),
   .uio_in(uio_in),
   .ena(ena),
   .clk(clk),
   .rst_n(rst_n),
   .uo_out(uo_out),
   .uio_out(uio_out),
   .uio_oe(uio_oe)
 );

 // Clock generation
 always begin
   #5 clk = ~clk;
 end

 // Testbench stimulus
 initial begin
   // Initialize signals
   ui_in = 8'b0000_0000;
   uio_in = 8'b0000_0000;
   ena = 1'b1;
   clk = 1'b0;
   rst_n = 1'b0;

   // Apply reset
   #10 rst_n = 1'b1;

   // Test vector 1: Encrypt a byte
   #10 ui_in = 8'b1010_1010;
   #10 uio_in = 8'b0000_0001;
   #10 ui_in = 8'b0101_0101;
   #10 uio_in = 8'b0000_0010;
   #10 ui_in = 8'b1111_1111;
   #10 uio_in = 8'b0000_0011;
   #10 ui_in = 8'b0000_0000;
   #10 uio_in = 8'b0000_0100;

   // Test vector 2: Decrypt a byte
   #10 ui_in = 8'b1010_1010;
   #10 uio_in = 8'b0000_0001;
   #10 ui_in = 8'b0101_0101;
   #10 uio_in = 8'b0000_0010;
   #10 ui_in = 8'b1111_1111;
   #10 uio_in = 8'b0000_0011;
   #10 ui_in = 8'b0000_0000;
   #10 uio_in = 8'b0000_0101;

   // Finish the simulation
   #10 $finish;
 end

 // Assertions
 always @(posedge clk) begin
  // Assert that the output is correct
  if (uo_out != $xor(ui_in, uio_in[7:0])) begin
    $error("Output is incorrect");
  end

  // Assert that the output enable is correct
  if (uio_oe != ~uio_in[2]) begin
    $error("Output enable is incorrect");
  end
 end
endmodule
