/*
Overview: This module handles the tens place score counting of the game.

Input: 
	clk: modified system clock based on game dificulty
	reset: central system reset >> SW[9]
	increment: increment one digit
	borrow: decrement one digit
	
Output:
	bcd: logic that communicates with seg7 to tell it which number to display.
	moveOver: move up a digit in the hundreds place (not applicable to this program)
	borrowLeft: move down a digit in the hundreds place (not applicable to this program)
	

Calls: Communicates with seg7 to display the current score
		 of the game. Called within the score module, and receives inputs from score,
		 and HEXStates0.
 
 */
module HEXStates12 (clk, reset, increment, borrow, bcd, moveOver, borrowLeft);
	input logic clk, reset, increment, borrow;
	output logic [3:0] bcd;
	output logic moveOver, borrowLeft;
	enum bit [3:0] {ZERO, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE} ps, ns;
	
	always_comb begin
		case(ps)
			ZERO: if (increment) begin
						ns = ONE;
						moveOver = 0;
						borrowLeft = 0;
					end else if (borrow) begin
						ns = NINE;
						moveOver = 0;
						borrowLeft = 1;
					end else begin
						ns = ZERO;
						moveOver = 0;
						borrowLeft = 0;
					end
			ONE: if (increment) begin
						ns = TWO;
						moveOver = 0;
						borrowLeft = 0;
					end else if (borrow) begin
						ns = ZERO;
						moveOver = 0;
						borrowLeft = 0;
					end else begin
						ns = ONE;
						moveOver = 0;
						borrowLeft = 0;
					end
			TWO: if (increment) begin
						ns = THREE;
						moveOver = 0;
						borrowLeft = 0;
					end else if (borrow) begin
						ns = ONE;
						moveOver = 0;
						borrowLeft = 0;
					end else begin
						ns = TWO;
						moveOver = 0;
						borrowLeft = 0;
					end
			THREE: if (increment) begin
						ns = FOUR;
						moveOver = 0;
						borrowLeft = 0;
					end else if (borrow) begin
						ns = TWO;
						moveOver = 0;
						borrowLeft = 0;
					end else begin
						ns = THREE;
						moveOver = 0;
						borrowLeft = 0;
					end
			FOUR: if (increment) begin
						ns = FIVE;
						moveOver = 0;
						borrowLeft = 0;
					end else if (borrow) begin
						ns = THREE;
						moveOver = 0;
						borrowLeft = 0;
					end else begin
						ns = FOUR;
						moveOver = 0;
						borrowLeft = 0;
					end
			FIVE: if (increment) begin
						ns = SIX;
						moveOver = 0;
						borrowLeft = 0;
					end else if (borrow) begin
						ns = FOUR;
						moveOver = 0;
						borrowLeft = 0;
					end else begin
						ns = FIVE;
						moveOver = 0;
						borrowLeft = 0;
					end
			SIX: if (increment) begin
						ns = SEVEN;
						moveOver = 0;
						borrowLeft = 0;
					end else if (borrow) begin
						ns = FIVE;
						moveOver = 0;
						borrowLeft = 0;
					end else begin
						ns = SIX;
						moveOver = 0;
						borrowLeft = 0;
					end
			SEVEN: if (increment) begin
						ns = EIGHT;
						moveOver = 0;
						borrowLeft = 0;
					end else if (borrow) begin
						ns = SIX;
						moveOver = 0;
						borrowLeft = 0;
					end else begin
						ns = SEVEN;
						moveOver = 0;
						borrowLeft = 0;
					end
			EIGHT: if (increment) begin
						ns = NINE;
						moveOver = 0;
						borrowLeft = 0;
					end else if (borrow) begin
						ns = SEVEN;
						moveOver = 0;
						borrowLeft = 0;
					end else begin
						ns = EIGHT;
						moveOver = 0;
						borrowLeft = 0;
					end
			NINE: if (increment) begin
						ns = ZERO;
						moveOver = 1;
						borrowLeft = 0;
					end else if (borrow) begin
						ns = EIGHT;
						moveOver = 0;
						borrowLeft = 0;
					end else begin
						ns = NINE;
						moveOver = 0;
						borrowLeft = 0;
					end
			endcase
	end
	assign bcd = ps;
	always_ff @(posedge clk) begin
		if(reset)
			ps <= ZERO;
		else
			ps <= ns;
	end
	
endmodule

//module HEXStates12_testbench ();
//	logic clk, reset, increment, borrow;
//	logic [3:0] bcd;
//	logic moveOver, borrowLeft;
//	
//	score dut (.clk, .reset, .increment, . borrow, .bcd, .moveOver, .borrowLeft);
//	
//	parameter clk_PERIOD=50;
//		initial begin
//			clk <= 0;
//			forever #(clk_PERIOD/2) clk <= ~clk;
//		end
//
//	initial begin
//		reset <= 1; reset <= 0; 					@(posedge clk);
//															@(posedge clk);
//															@(posedge clk);
//		increment <= 0; borrow <= 0;				@(posedge clk);	
//				increment <= 1;						@(posedge clk);
//				increment <= 0;						@(posedge clk);
//															@(posedge clk);
//				increment <= 1;						@(posedge clk);
//				increment <= 0;						@(posedge clk);
//															@(posedge clk);
//				increment <= 1;						@(posedge clk);
//				increment <= 0;						@(posedge clk);
//															@(posedge clk);
//				increment <= 1;						@(posedge clk);
//				increment <= 0;						@(posedge clk);
//															@(posedge clk);
//				increment <= 1;						@(posedge clk);
//				increment <= 0;						@(posedge clk);
//															@(posedge clk);
//				borrow <= 1;							@(posedge clk);
//				borrow <= 0;							@(posedge clk);
//															@(posedge clk);
//				borrow <= 1;							@(posedge clk);
//				borrow <= 0;							@(posedge clk);
//															@(posedge clk);
//				borrow <= 1;							@(posedge clk);
//				borrow <= 0;							@(posedge clk);
//															@(posedge clk);
//				borrow <= 1;							@(posedge clk);
//				borrow <= 0;							@(posedge clk);
//															@(posedge clk);
//				increment <= 1;						@(posedge clk);
//				increment <= 0;						@(posedge clk);
//															@(posedge clk);
//				increment <= 1;						@(posedge clk);
//				increment <= 0;						@(posedge clk);
//															@(posedge clk);								
//				increment <= 1;						@(posedge clk);
//				increment <= 0;						@(posedge clk);
//															@(posedge clk);
//				increment <= 1;						@(posedge clk);
//				increment <= 0;						@(posedge clk);
//															@(posedge clk);				
//															@(posedge clk);
//				borrow <= 1;							@(posedge clk);
//				borrow <= 0;							@(posedge clk);
//															@(posedge clk);
//				borrow <= 1;							@(posedge clk);
//				borrow <= 0;							@(posedge clk);
//															@(posedge clk);
//				borrow <= 1;							@(posedge clk);
//				borrow <= 0;							@(posedge clk);
//															@(posedge clk);
//				borrow <= 1;							@(posedge clk);
//				borrow <= 0;							@(posedge clk);								
//													
//		$stop;
//	end
//	
//endmodule
															
															
															
															
															
															
															
															
															
															
															
															
				