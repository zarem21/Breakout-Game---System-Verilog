
/*
Overview: This module deals with the movement of the ball across the screen. Accounting
			 for the boarders and each brick
				
Input: clk - Clock
		 reset - reset
		 initial_x - changes the initial postion of the x 
		 paddle_x1 & paddle_x2 - where the paddle is located
		 x_hit - tells the ball it has hit the left or the right of a brick
		 y_hit - tells the ball it has hit the top or the bottom of a brick
		 gameOver - tells the ball to stop moving when the game is over

Output: x1 & x2 - the x values for the dimension of the ball
		  y1 & y2 - the y values for the dimension of the ball
		  x - x value of the center of the ball
		  y - value of the center of the ball

Calls: None

*/
module ball_movement #(H_SIZE = 3, IX = 320, IY = 375, IX_DIR = 1, IY_DIR = 0, D_WIDTH = 640, D_HEIGHT = 480) 
							 (
							  input logic clk,
							  input logic reset,
							  input logic [9:0] initial_x,
							  input logic [9:0] paddle_x1, paddle_x2,
							  input logic x_hit,
							  input logic y_hit,
							  input logic gameOver,
							  output logic [9:0] x1, //x has [9:0]
							  output logic [9:0] x2,
							  output logic [9:0] y1, //y has [8:0]
							  output logic [9:0] y2,
							  output logic [9:0] x,
							  output logic [8:0] y
							  );
	logic x_dir;
	logic y_dir;
	
	//controls the dimensions of the ball
	assign x1 = x - H_SIZE;
	assign x2 = x + H_SIZE;
	assign y1 = y - H_SIZE;
	assign y2 = y + H_SIZE;
	
	always_ff @(posedge clk) begin
		if (reset) begin //intial values of the ball
			x <= IX;
			y <= IY;
			x_dir <= IX_DIR;
			y_dir <= IY_DIR;
				
		end //if

		else begin
			x <= (~gameOver ? ((x_dir) ? (x + 1) : (x - 1)) : 0);
			y <= (~gameOver ? ((y_dir) ? (y + 1) : (y - 1)) : 0);
			
			if (x <= (H_SIZE + 1)) //hits left side of screen
				x_dir <= 1; //bounces back to the right
			
			if (x >= (D_WIDTH - H_SIZE - 1)) //hits right side of screen
				x_dir <= 0; //bounces back to the left
				
			if (y <= (H_SIZE + 1)) //hits the top screen
				y_dir <= 1; //bounces back to the bottom
			
			if (y >= (D_HEIGHT - H_SIZE - 1)) // hits the bottom of the screen
				y_dir <= 0; //bounces back to the top
			
			if ((y >= (450 - H_SIZE - 1)) & (x >= paddle_x1 & x <= paddle_x2))
				y_dir <= 0; //if it hits the paddle
				
			if (x_hit) //inverts the x direction when the ball hits the left or right side of the brick
				x_dir <= ~x_dir;   
			if (y_hit) //inverts the y direction when the ball hits the left or right side of the brick
				y_dir <= ~y_dir; 
					
		end //else
	end //always_ff
endmodule // ball_movement
	