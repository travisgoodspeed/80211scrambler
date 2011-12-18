//With a 100ps per tick, the clock is 1ns/cycle
//Therefore we're running at 1Mbps.
`timescale 100ps/10ps

`include "scrambler.v"
module scrambler_tb();
   // Declare inputs as regs and outputs as wires
   reg clock, reset, enable, bit_in;
   wire [6:0] state_out;
   wire bit_out;
   

   // Initialize all variables
   initial begin
      $dumpfile("scrambler_tb.vcd");
      $dumpvars(0,clock,reset,enable,bit_in,bit_out,state_out);
      
      $display ("time\t clk reset enable in out state");	
      $monitor (  "%g\t %b   %b     %b      %b  %b   %b", 
		$time, clock, reset, enable, bit_in, bit_out, state_out);	
      clock = 1;       // initial value of clock
      reset = 0;       // initial value of reset
      enable = 0;      // initial value of enable
      bit_in = 1;
      #5 reset = 1;    // Assert the reset
      #10 reset = 0;   // De-assert the reset
      #10 enable = 1;  // Assert enable
      #20000 enable = 0; // De-assert enable
      #5 $finish;      // Terminate simulation
   end

   // Clock generator
   always begin
      #5 clock = ~clock; // Toggle clock every 5 ticks
   end

   // Connect DUT to test bench
   scrambler U_scrambler (
			clock,
			reset,
			enable,
			state_out,
			bit_in,
			bit_out
			);

endmodule
