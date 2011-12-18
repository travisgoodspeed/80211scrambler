//-----------------------------------------------------
// 802.11B Decrambler
// Design Name : descrambler.v
// File Name : descrambler.v
// Function : This is a self-synching 7 bit descrambler for 802.11b
// Synchronous active high reset and
// with active high enable signal
//-----------------------------------------------------
module descrambler (
		  clock ,    // Clock input of the design
		  reset ,    // active high, synchronous Reset input
		  enable ,   // Active high enable signal
		  state_out, // vector output
		  bit_in,    // Input data bit.
		  bit_out    // Scrambled output bit.
		  ); // End of port list
   //-------------Input Ports-----------------------------
   input clock ;
   input reset ;
   input enable ;
   input bit_in;

   //-------------Output Ports----------------------------
   output [6:0] state_out ;
   output 	bit_out;
   
   //-------------Input ports Data Type-------------------
   // By rule all the input ports should be wires   
   wire 	clock ;
   wire 	reset ;
   wire 	enable ;
   //-------------Output Ports Data Type------------------
   // Output port can be a storage element (reg) or a wire
   reg [6:0] 	state_out ;
   reg 		bit_out;
   
   //------------Code Starts Here-------------------------
   assign feedback =  (bit_in ^ state_out[6] ^ state_out[3]);

   // We trigger the below block with respect to positive
   // edge of the clock.
   always @ (posedge clock)
     begin : DESCRAMBLER // Block Name
	// At every rising edge of clock we check if reset is active
	// If active, zero the state.
	if (reset == 1'b1) begin
	   //Self synching, so a reset should be to the unknown state.
	   //This might cause a problem in synthesis.
	   state_out <= #1 7'bXXXXXXX;
	end
	// If enable is active, then we tick the state.
	else if (enable == 1'b1) begin
	   //state_out <= #1 state_out + 1;
	   state_out <= {state_out[5], state_out[4], state_out[3],
			 state_out[2], state_out[1], state_out[0],
			 bit_in};
	   //bit_out <= feedback;
	end
     end // block: DESCRAMBLER
   always @ (negedge clock)
     begin:DESCRAMBLERDOWN
	bit_out<=feedback;
     end
   

endmodule
