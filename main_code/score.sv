/*
Overview: This module handles the score counting of the game.

Input: 
	clk: modified system clock based on game dificulty
	reset: central system reset >> SW[9]
	total_score: The total amount of blocks destroyed by the ball at one instance
					 One block = 1 point
	
Output:
	HEX0: HEX display for ones place of score
	HEX1: HEX display for tens place

Calls: This method calls the HEXStates0 and HEXStates12 state machines
		 to increment the score by one, two, or three points.
		 Calls seg7 once for the ones place, and a second time for the tens place.
		 
		 This module gets the total_score from the breakout module
		 The breakout module makes total_score by adding all pOne signals for every
		 of every brick returned by the collision module.
 
 */
module score (clk, reset, total_score, HEX0, HEX1);	
	input logic clk, reset;
	input logic [1:0] total_score;
	output logic [6:0] HEX0, HEX1;
	
	logic carry1, carry2, borrow1, borrow2;
	logic pOne, pTwo, pThree;
	logic [3:0] bcd0, bcd1;
	
	always_comb begin
		case(total_score)
			2'b01: begin
						pOne = 1'b1;
						pTwo = 1'b0;
						pThree = 1'b0;
					 end
			2'b10: begin
						pOne = 1'b0;
						pTwo = 1'b1;
						pThree = 1'b0;
					 end
			2'b11: begin
						pOne = 1'b0;
						pTwo = 1'b0;
						pThree = 1'b1;
					 end
			default: begin
							pOne = 1'b0;
							pTwo = 1'b0;
							pThree = 1'b0;
						end
		endcase //case(total_score)
	end // always_comb
	
	// ones place of the score
	HEXStates0 ones (.clk(clk), .reset(reset), .pOne, .pTwo, .pThree, .bcd(bcd0), .moveOver(carry1), .borrow(borrow1));
	// tens place of the score
	HEXStates12 tens (.clk(clk), .reset(reset), .increment(carry1), .borrow(borrow1), .bcd(bcd1), .moveOver(carry2), .borrowLeft(borrow2));
	
	// ones place
	seg7 hex0 (.bcd(bcd0), .leds(HEX0));
	// tens place
	seg7 hex1 (.bcd(bcd1), .leds(HEX1));
endmodule // score

module score_testbench();
	logic clk, reset;
	logic [1:0] total_score;
	logic [6:0] HEX0, HEX1;
	
	score dut (.*);
	
	parameter clk_PERIOD=50;
		initial begin
				clk <= 0;
				forever #(clk_PERIOD/2) clk <= ~clk;
		end // initial
		
	initial begin
			reset <= 1;	total_score <= 0;	@(posedge clk);
			
			reset <= 0; 						@(posedge clk);
			total_score <= 1;					@(posedge clk);
			total_score <= 0;					@(posedge clk);
			total_score <= 0;					@(posedge clk);
			total_score <= 0;					@(posedge clk);
			total_score <= 2;					@(posedge clk);
			total_score <= 0;					@(posedge clk);
			total_score <= 0;					@(posedge clk);
			total_score <= 0;					@(posedge clk);
			total_score <= 3;					@(posedge clk);
			total_score <= 0;					@(posedge clk);
			total_score <= 0;					@(posedge clk);
			total_score <= 0;					@(posedge clk);
			total_score <= 3;					@(posedge clk);
			total_score <= 0;					@(posedge clk);
			total_score <= 0;					@(posedge clk);
			total_score <= 0;					@(posedge clk);
			total_score <= 1;					@(posedge clk);
			total_score <= 0;					@(posedge clk);
			total_score <= 0;					@(posedge clk);
			total_score <= 0;					@(posedge clk);
													@(posedge clk);
		$stop;
	end //initital
	
endmodule // score_testbench
