module stream_cypher_tb;
 reg [7:0] ui_in;
 wire [7:0] uo_out;
 reg [7:0] uio_in;
 wire [7:0] uio_out, uio_oe;
 reg ena, clk, rst_n;

 // Instantiate the module under test
 stream_cypher uut (
   .ui_in(ui_in),
   .uo_out(uo_out),
   .uio_in(uio_in),
   .uio_out(uio_out),
   .uio_oe(uio_oe),
   .ena(ena),
   .clk(clk),
   .rst_n(rst_n)
 );

 // Clock generation
 always #5 clk = ~clk;

 // Test sequence
 initial begin
   // Initialize signals
   ui_in = 8'b0000_0000;
   uio_in = 8'b0000_0000;
   ena = 1'b1;
   rst_n = 1'b0;
   #10 rst_n = 1'b1;

   // Test encryption
   ui_in = 8'b1111_1111;
   uio_in = 8'b0010_0000; // view=1, encrypt=1, inc=0
   #10 uio_in = 8'b0010_0001; // inc=1
   #10 assert(uo_out == 8'b0000_0000) else $error("Encryption failed");
  
   // Test decryption
   uio_in = 8'b0000_0000; // view=0, encrypt=0, inc=0
   #10 uio_in = 8'b0000_0001; // inc=1
   #10 assert(uo_out == 8'b1111_1111) else $error("Decryption failed");

   // Test reset
   rst_n = 1'b0;
   #10 rst_n = 1'b1;
   #10 assert(uo_out == 8'b0000_0000) else $error("Reset failed");

   // Finish the simulation
   $finish;
 end


endmodule
