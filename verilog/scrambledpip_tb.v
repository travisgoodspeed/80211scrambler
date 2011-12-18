//With a 100ps per tick, the clock is 1ns/cycle
//Therefore we're running at 1Mbps.
`timescale 100ps/10ps

`include "scrambler.v"
`include "unscrambler.v"
`include "descrambler.v"

module scrambledpip_tb();
   // Declare inputs as regs and outputs as wires
   reg clock, reset, dereset, enable, bit_in;
   wire out1, out2, out3, out4;
   wire [6:0] state1, state2, state3, state4;
   
   //wire bit_out;
   
   integer    i, j;
   reg [7:0]  data[128:0];
   reg [7:0]  databyte;
   
   
   // Initialize all variables
   initial begin
      $dumpfile("scrambledpip_tb.vcd");
      $dumpvars(0,clock,reset,enable,bit_in,out1, out2, out3, out4);
      
      $readmemh("beacon.hex", data);
      
      $display ("WARNING: Scrambling compensator doesn't work yet.");	
      
      $display ("time\t clk reset enable in s1 s2 s3");	
      $monitor (  "%g\t %b   %b     %b      %b  %b  %b  %b", 
		  $time, clock, reset, enable,
		  bit_in, out1, out2, out3);
      

      clock = 1;       // initial value of clock
      reset = 0;       // initial value of reset
      enable = 0;      // initial value of enable
      bit_in = 1;
      #10 enable = 1;  // Assert enable
      #5 reset = 1;    // Assert the reset
      #10reset = 0;   // De-assert the reset
      
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
   
   //First scramble the bits.
   scrambler U_layer1 (
			clock,
			reset,
			enable,
			state1,
			bit_in,
			out1
			);
   //Then unscramble them, to produce on-air symbols.
   unscrambler U_layer2 (
			 clock, 
			 reset,
			 enable,
			 state2,
			 out1,
			 out2
			 );
   //Then descramble on reception.
   descrambler U_layer3 (
			 clock, 
			 reset,
			 enable,
			 state3,
			 out1,
			 out3
			 );
   
   
endmodule
