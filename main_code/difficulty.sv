/*
Overview: This module controls the speed of the ball. You can change the switch inputs
			 so that the ball will speedup. This makes the game harder as the speed increases.
				
Input: clk - Clock
		 reset - reset
		 var_1 - switch input
		 var_2 - switch input

Output: speed - changes the clock, that controls the speed of the ball. Changes whichClock

Calls: None

*/
module difficulty (
						 input clk, reset,
						 input logic var_1,
						 input logic var_2,
						 output logic [5:0] speed
						 );

		always_ff @(posedge clk) begin
			if (var_1 & ~var_2)
				speed <= 6'd18;
		
			else if (var_1 & var_2)
				speed <= 6'd17;
				
			else 	
				speed <= 6'd19;
		end //always_ff
												
endmodule //difficulty

module difficulty_testbench();
	logic clk, reset;
	logic var_1;
	logic var_2;
	logic [5:0] speed;
	
	difficulty dut (.*);

	parameter clk_PERIOD=50;
		initial begin
				clk <= 0;
				forever #(clk_PERIOD/2) clk <= ~clk;
		end // initial
		
	initial begin
			reset <= 1;	var_1 <= 0; var_2 <= 0;	@(posedge clk);
			
			reset <= 0; 								@(posedge clk);
			var_1 <= 0; var_2 <= 0;					@(posedge clk);
			var_1 <= 1; var_2 <= 0;					@(posedge clk);
			var_1 <= 0; var_2 <= 1;					@(posedge clk);
			var_1 <= 1; var_2 <= 1;					@(posedge clk);
															@(posedge clk);
		$stop;
	end //initital
	
endmodule //difficulty_testbench
