/*
Overview: This module controls the logic to determine if the ball has collided with a brick.
			 When the ball has hit the brick it will disapear. 
				
Input:  clk - Clock
		  reset - reset
		  ball_x - the x value for the center of the ball
		  ball_y - the y value for the senter of the ball
		  x1 & x2 - the x dimension of the ball
		  y1 & y2 - the y dimension of the ball
		  
Output: brick_alive - determine if a brick should be shown on screen
		  pOne - output to determine if a brick has been hit

Calls: None

*/
module collision #(H_SIZE = 3) (clk, reset, brick_alive, ball_x, ball_y, x1, x2, y1, y2, pOne);
	input logic clk, reset;
	input logic [9:0] ball_x, x1, x2;
	input logic [8:0] ball_y, y1, y2;
	output logic brick_alive, pOne;
	
	logic hit_brick;
	//Determines if a ball has been hit
	assign hit_brick = ((ball_x >= x1 - H_SIZE & ball_x <= x2 + H_SIZE) & ball_y >= (y1 - H_SIZE) & ball_y <= (y2 + H_SIZE));
	
	always_ff @(posedge clk) begin
		if (reset) begin
			brick_alive <= 1;
//			ps_alive <= 1;
			pOne <= 0;
		end //if
		else begin
			if (hit_brick) begin
				brick_alive <= 0;
//				ps_alive <= 0;
			end //if
			
			if (brick_alive & hit_brick)
				pOne <= 1;
			else 
				pOne <= 0;
				
		end //else
	end //always_ff
endmodule //collision
