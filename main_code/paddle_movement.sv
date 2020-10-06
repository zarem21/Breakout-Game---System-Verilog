/*
Overview: This module controls the movement of the paddle at the bottom of the screen
			 It take in the L and R arrow keys from the keyboard and outputs the x values 
			 of the paddle. 
				
Input: clk - Clock
		 reset - reset
		 L - The left button input from the keyboard
		 R - The right button input from the keyboard
		 x - values from the video driver
		 y - values from the video driver

Output: x1 - the x1 value of the paddle, used for the collision on the ball
		  x2 - the x1 value of the paddle, used for the collision with the ball

Calls: None 

*/
module paddle_movement (clk, reset, x, y, L, R, paddle, x1, x2);
	input logic clk, reset, L, R;
	input logic [9:0] x;
	input logic [8:0] y;
	output logic paddle;
	output logic [9:0] x1, x2;
	
	logic y_limit;
	assign y_limit = (y > 450) & (y < 460);
	

	assign paddle = (x > x1) & (x < x2) & y_limit; // the logic to make the paddle appear on screen
						
	always_ff @(posedge clk) begin
		if (reset) begin //initial position
			x1 <= 10'd280;
			x2 <= 10'd360;
		end //if
		else if (L & x1 > 30) begin //Move to the left with one press
			x1 <= x1 - 10'd30;
			x2 <= x2 - 10'd30;
		end //else if
		else if (R & x2 < 610) begin // Move to the right with one press
			x1 <= x1 + 10'd30;
			x2 <= x2 + 10'd30;
		end //else if
		else begin //If nothing is pressed stay where your are
			x1 <= x1;
			x2 <= x2;
		end //else
	end //always_ff
endmodule //paddle_movement

module paddle_movement_testbench();
	logic clk, reset, L, R;
	logic [9:0] x;
	logic [8:0] y;
	logic [9:0] x1, x2;
	logic paddle;
	
	// Sets up the clock.
	parameter CLOCK_PERIOD=50;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	paddle_movement dut (.*);
	
	initial begin
		reset <= 0; L <= 0; R <= 0; x <= 0; y <= 0; @(posedge clk);
		reset <= 1;
		$stop;
	end
endmodule
