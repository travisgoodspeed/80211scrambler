//With a 100ps per tick, the clock is 1ns/cycle
//Therefore we're running at 1Mbps.
`timescale 100ps/10ps

`include "scrambler.v"
`include "unscrambler.v"
`include "descrambler.v"

module unscrambler_tb();
   // Declare inputs as regs and outputs as wires
   reg clock, reset, dereset, enable, bit_in;
   wire bit_out, debit_out;
   wire [6:0] state_out;
   wire [6:0] destate_out;
   //wire bit_out;
   
   integer    i, j;
   reg [7:0]  data[128:0];
   reg [7:0]  databyte;
   
   
   // Initialize all variables
   initial begin
      $dumpfile("unscrambler_tb.vcd");
      $dumpvars(0,clock,reset,enable,bit_in,bit_out,debit_out,state_out,destate_out);
      
      $readmemh("beacon.hex", data);
      
      $display ("time\t clk reset enable in en de  state destate");	
      $monitor (  "%g\t %b   %b     %b      %b  %b  %b   %b  %b", 
		$time, clock, reset, enable,
		  bit_in, bit_out, debit_out,
		  state_out, destate_out);	
      clock = 1;       // initial value of clock
      reset = 0;       // initial value of reset
      dereset = 0;
      enable = 0;      // initial value of enable
      bit_in = 1;
      #10 enable = 1;  // Assert enable
      #5 reset = 1;    // Assert the reset
      dereset = 1;  // Reset the second scrambler.
      #10 dereset = 0;
      reset = 0;   // De-assert the reset
      
      for(i=0; i<128; i=i+1) begin
	 databyte=data[i];
	 $display ("Byte %g %h=%b", i, data[i], data[i]);
	 for(j=0; j<8; j=j+1) begin
	    $display ("Bit %g, %b", j, databyte[j]);
	    bit_in<=databyte[j];
	    #10 ;
	 end
      end
      #20000 enable = 0;// De-assert enable
      #5 $finish;      // Terminate simulation
   end

   // Clock generator
   always begin
      #5 clock = ~clock; // Toggle clock every 5 ticks
   end

   // Connect DUT to test bench
   unscrambler U_scrambler (
			clock,
			reset,
			enable,
			state_out,
			bit_in,
			bit_out
			);
   scrambler U_descrambler (
			clock, 
			dereset,
			enable,
			destate_out,
			bit_out,
			debit_out
			);
   
endmodule
