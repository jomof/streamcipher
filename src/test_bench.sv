module test_bench;
 reg [7:0] ui_in;
 reg [7:0] uio_in;
 reg ena;
 reg clk;
 reg rst_n;
 wire [7:0] uo_out;
 wire [7:0] uio_out;
 wire [7:0] uio_oe;

 // Instantiate the module under test
 stream_cypher uut (
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

 // Test stimulus
 initial begin
   // Initialize signals
   ui_in = 8'b0000_0000;
   uio_in = 8'b0000_0000;
   ena = 1'b1;
   clk = 1'b0;
   rst_n = 1'b1;

   // Apply reset
   #10 rst_n = 1'b0;
   #10 rst_n = 1'b1;

   // Test case 1: Encrypt a message
   #10 ui_in = 8'b0000_0001;
   #10 uio_in = 8'b0000_0101; // Set encrypt and view signals
   #10 ui_in = 8'b0000_0010;
   #10 ui_in = 8'b0000_0011;

   // Test case 2: Decrypt a message
   #10 uio_in = 8'b0000_0010; // Clear encrypt and set view signals
   #10 ui_in = 8'b0000_0001;
   #10 ui_in = 8'b0000_0010;
   #10 ui_in = 8'b0000_0011;

   // Test case 3: Encrypt a message without changing the input
   #10 ui_in = 8'b0000_0001;
   #10 uio_in = 8'b0000_0101; // Set encrypt and view signals
   #10 ui_in = 8'b0000_0001; // Keep the input constant
   #10 ui_in = 8'b0000_0011;

   // Finish the simulation
   #10 $finish;
 end
endmodule
