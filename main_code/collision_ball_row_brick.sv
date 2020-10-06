/*
Overview: This module is called for each row of bricks. It uses the fact that each 
			 row has the same y1 and y2, and the x values for the rows are the same.
			 It uses the x1, x2, y1, y2 of each brick and the ball to decide if the ball
			 has hit a brick. It then returns what type of hit has happened so that 
			 the ball can bounce.
				
Input: clk - Clock
		 y1 - y1 value of the row of bricks
		 y2 - y2 value of the row of bricks
		 x_var - set of all possible x values
		 brick_alive- holds all the brick alive variables for the row
		 ball_x - position of the center of the ball in the x-axis
		 ball_y - position of the center of the ball in the y-axis

Output: x_hit - the ball has hit the left or right side of a brick in this row
		  y_hit - the ball has hit the top or the bottom of a brick in this row

Calls: None

*/
module collision_ball_row_brick #(H_SIZE = 3) 
											(
											input logic clk, 
											input logic [8:0] y1, //Y values of the bricks in the row
											input logic [8:0] y2,
											input logic [9:0] x_var [10:0], //11 possible x values
											input logic [9:0] brick_alive, //Whether a brick is there to bounce off of
											input logic [9:0] ball_x,
											input logic [8:0] ball_y, //Center coordinated of the ball
											output logic x_hit, //ball hit the left or right of a brick in the row
											output logic y_hit ///ball hit the top or bottom of a brick in the row
										   );
	logic [9:0] brick_XHit, brick_YHit;
	
	//Chcks if the ball has hit the left or the right side of a brick
	genvar i;
		generate
			for (i = 0; i < 10; i++)begin :hitsX
				//                   brick alive   AND                       (left hit                                 OR       right hit)
				assign brick_XHit[i] = brick_alive[i] & ((ball_x == (x_var[i] - H_SIZE) & (ball_y >= y1 & ball_y <= y2)) || (ball_x == (x_var[i+1] + H_SIZE) & (ball_y >= y1 & ball_y <= y2)));
			end //for
		endgenerate
	
//Checks if the ball has hits the top of the bottom of a brick	
	genvar j;
		generate
			for (j = 0; j < 10; j++)begin :hitsY
				//                   brick alive    AND                 (top hit                                             OR                bottom hit)
				assign brick_YHit[j] = brick_alive[j] & ((ball_y == (y1 - H_SIZE) & (ball_x >= x_var[j] & ball_x <= x_var[j+1])) || (ball_y == (y2 + H_SIZE) & (ball_x >= x_var[j] & ball_x <= x_var[j+1])));
			end //for
		endgenerate
	
	//takes all of the checks above and Or's them together to become a single output for the row if something has been hit
	always_ff @(posedge clk) begin
		x_hit <= brick_XHit[0] || brick_XHit[1] || brick_XHit[2] || brick_XHit[3] || brick_XHit[4] || brick_XHit[5] || brick_XHit[6] || brick_XHit[7] || brick_XHit[8] ||  brick_XHit[9];
	   y_hit <= brick_YHit[0] || brick_YHit[1] || brick_YHit[2] || brick_YHit[3] || brick_YHit[4] || brick_YHit[5] || brick_YHit[6] || brick_YHit[7] || brick_YHit[8] ||  brick_YHit[9];

	end //always_ff
	
endmodule //collision_ball_row_brick