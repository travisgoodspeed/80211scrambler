//-----------------------------------------------------
// 802.11B Unscrambler
// Design Name : unscrambler.v
// File Name : unscrambler.v
// Function : This is a 7 bit unscrambler for 802.11b
// Synchronous active high reset and
// with active high enable signal
//-----------------------------------------------------
module unscrambler (
		  clock ,    // Clock input of the design
		  reset ,    // active high, synchronous Reset input
		  enable ,   // Active high enable signal
		  state_out, // vector output
		  bit_in,    // Input data bit.
		  bit_flipped    // Scrambled output bit.
		  ); // End of port list
   //-------------Input Ports-----------------------------
   input clock ;
   input reset ;
   input enable ;
   input bit_in;

   //-------------Output Ports----------------------------
   output [6:0] state_out ;
   output 	bit_flipped;
   
   //-------------Input ports Data Type-------------------
   // By rule all the input ports should be wires   
   wire 	clock ;
   wire 	reset ;
   wire 	enable ;
   //-------------Output Ports Data Type------------------
   // Output port can be a storage element (reg) or a wire
   //reg [6:0] 	state_out ;
   //reg 		bit_out;

   reg 	bit_flipped=1;
   
   
   scrambler scramble(~clock,reset,enable,state_out,bit_flipped,bit_out);
   
   
   //------------Code Starts Here-------------------------
   
   

   // We trigger the below block with respect to positive
   // edge of the clock.
   always @ (posedge clock)
     begin : SCRAMBLER // Block Name
	if (bit_out^bit_in) begin
	   bit_flipped=bit_flipped^1;
	   $display("Flipped a bit.");
	   
	end
     end // block: SCRAMBLER
   always @ (posedge clock)
     begin : SCRAMBLERDOWN
	
     end

endmodule
