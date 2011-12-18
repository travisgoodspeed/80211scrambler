//-----------------------------------------------------
// 802.11B Scrambler
// Design Name : scrambler.v
// File Name : scrambler.v
// Function : This is a 7 bit scrambler for 802.11b
// Synchronous active high reset and
// with active high enable signal
//-----------------------------------------------------
module scrambler (
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
   wire 	bit_out;
   
   
   //------------Code Starts Here-------------------------
   assign feedback =  (bit_in ^ state_out[6] ^ state_out[3]);
   assign bit_out = feedback;
   
   // We trigger the below block with respect to positive
   // edge of the clock.
   always @ (posedge clock)
     begin : SCRAMBLER // Block Name
	// At every rising edge of clock we check if reset is active
	// If active, zero the state.
	if (reset == 1'b1) begin
	   //Anything but all one's is legal.
	   state_out <= #1 7'b0000000;  //Zeroed start. Might be common?
	   //state_out <= #1 7'b1010101;  //Striped start.
	   //state_out <= #1 7'b1000101;  //Striped start.
	   //state_out <= #1 7'b1111111;  //Illegal start.
	end
	// If enable is active, then we tick the state.
	else if (enable == 1'b1) begin
	   //state_out <= #1 state_out + 1;
	   state_out <= {state_out[5], state_out[4], state_out[3],
			 state_out[2], state_out[1], state_out[0],
			 feedback};
	   //bit_out <= state_out[6];
	   //bit_out <= feedback;
	end
     end // block: SCRAMBLER
   always @ (negedge clock)
     begin : SCRAMBLERDOWN
	//bit_out <= feedback;
     end

endmodule
