/*
Overview: This module handles the ones place score counting of the game.

Input: 
	clk: modified system clock based on game dificulty
	reset: central system reset >> SW[9]
	pOne: plus one signal
	pTwo: plus two signal
	pThree: plus three signal
	
Output:
	bcd: logic that communicates with seg7 to tell it which number to display
	moveOver: move up a digit in the tens place
	borrow: move down a digit in the tens place

Calls: Communicates with HEXStates12 and seg7 to display the current score
		 of the game. Receives pOne, pTwo, pThree
 
 */
module HEXStates0 (clk, reset, pOne, pTwo, pThree, bcd, moveOver, borrow);
	input logic clk, reset, pOne, pTwo, pThree;
	output logic [3:0] bcd; 
	output logic moveOver, borrow;
	enum bit [3:0] {ZERO, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE} ps, ns;
	
	always_comb begin
		case(ps)
			ZERO: if (pOne) begin
							ns = ONE;
							moveOver = 0;
							borrow = 0;
					end else if (pTwo) begin
							ns = TWO;
							moveOver = 0;
							borrow = 0;
					end else if (pThree) begin
							ns = THREE;
							moveOver = 0;
							borrow = 0;
					end else begin
							ns = ZERO;
							moveOver = 0;
							borrow = 0;
					end
			ONE: if (pOne) begin
							ns = TWO;
							moveOver = 0;
							borrow = 0;
					end else if (pTwo) begin
							ns = THREE;
							moveOver = 0;
							borrow = 0;
					end else if (pThree) begin
							ns = FOUR;
							moveOver = 0;
							borrow = 0;
					end else begin
							ns = ONE;
							moveOver = 0;
							borrow = 0;
					end
			TWO: if (pOne) begin
							ns = THREE;
							moveOver = 0;
							borrow = 0;
					end else if (pTwo) begin
							ns = FOUR;
							moveOver = 0;
							borrow = 0;
					end else if (pThree) begin
							ns = FIVE;
							moveOver = 0;
							borrow = 0;
					end else begin
							ns = TWO;
							moveOver = 0;
							borrow = 0;
					end
			THREE: if (pOne) begin
							ns = FOUR;
							moveOver = 0;
							borrow = 0;
					end else if (pTwo) begin
							ns = FIVE;
							moveOver = 0;
							borrow = 0;
					end else if (pThree) begin
							ns = SIX;
							moveOver = 0;
							borrow = 0;
					end else begin
							ns = THREE;
							moveOver = 0;
							borrow = 0;
					end
			FOUR: if (pOne) begin
							ns = FIVE;
							moveOver = 0;
							borrow = 0;
					end else if (pTwo) begin
							ns = SIX;
							moveOver = 0;
							borrow = 0;
					end else if (pThree) begin
							ns = SEVEN;
							moveOver = 0;
							borrow = 0;
					end else begin
							ns = FOUR;
							moveOver = 0;
							borrow = 0;
					end
			FIVE: if (pOne) begin
							ns = SIX;
							moveOver = 0;
							borrow = 0;
					end else if (pTwo) begin
							ns = SEVEN;
							moveOver = 0;
							borrow = 0;
					end else if (pThree) begin
							ns = EIGHT;
							moveOver = 0;
							borrow = 0;
					end else begin
							ns = FIVE;
							moveOver = 0;
							borrow = 0;
					end
			SIX: if (pOne) begin
							ns = SEVEN;
							moveOver = 0;
							borrow = 0;
					end else if (pTwo) begin
							ns = EIGHT;
							moveOver = 0;
							borrow = 0;
					end else if (pThree) begin
							ns = NINE;
							moveOver = 0;
							borrow = 0;
					end else begin
							ns = SIX;
							moveOver = 0;
							borrow = 0;
					end
			SEVEN: if (pOne) begin
							ns = EIGHT;
							moveOver = 0;
							borrow = 0;
					end else if (pTwo) begin
							ns = NINE;
							moveOver = 0;
							borrow = 0;
					end else if (pThree) begin
							ns = ZERO;
							moveOver = 1;
							borrow = 0;
					end else begin
							ns = SEVEN;
							moveOver = 0;
							borrow = 0;
					end
			EIGHT: if (pOne) begin
							ns = NINE;
							moveOver = 0;
							borrow = 0;
					end else if (pTwo) begin
							ns = ZERO;
							moveOver = 1;
							borrow = 0;
					end else if (pThree) begin
							ns = ONE;
							moveOver = 1;
							borrow = 0;
					end else begin
							ns = EIGHT;
							moveOver = 0;
							borrow = 0;
					end
			NINE: if (pOne) begin
							ns = ZERO;
							moveOver = 1;
							borrow = 0;
					end else if (pTwo) begin
							ns = ONE;
							moveOver = 1;
							borrow = 0;
					end else if (pThree) begin
							ns = TWO;
							moveOver = 1;
							borrow = 0;
					end else begin
							ns = NINE;
							moveOver = 0;
							borrow = 0;
					end
		endcase //case(ps)
end //always_comb

	assign bcd = ps;

	always_ff @(posedge clk) begin
		if(reset)
			ps <= ZERO;
		else
			ps <= ns;
	end // always_ff
	
endmodule // HEXStates0
