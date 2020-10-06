/*
Overview: This module determines when the ball goes past the paddle
			 and returns a high gameOver signal when the ball passes that barrier.

Input: 
	clk: modified system clock based on game dificulty
	reset: central system reset >> SW[9]
	ball_x: ball x position
	ball_y: ball y position
	
Output:
	gameOver: Returns 1 when the ball hits the bottom border of the screen (past the paddle)
				 Returns 0 otherwise, and the game goes on

Calls: 
	It is called in the breakout module and determines when the game continues
	If gameOver is high, the screen displays a red screen, and game stops.
 */
module ballDied (clk, reset, ball_x, ball_y, gameOver);
	input logic clk, reset;
	output logic gameOver;
	input logic [9:0] ball_x;
	input logic [8:0] ball_y;
	enum {ALIVE, DEAD} ps, ns;
	
	logic bottomBorder;
	assign bottomBorder = ball_y >= (450 + 3) & ball_y <= (460 - 3);
	
	always_comb begin
		case (ps)
			ALIVE: begin
						if (bottomBorder)
							ns = DEAD;
						else
							ns = ALIVE;
					 end
			
			DEAD: ns = DEAD;
			default: ns = ALIVE;
		endcase
	end
	
	assign gameOver = (ps == DEAD);
	
	always_ff @(posedge clk) begin
		if (reset)
			ps <= ALIVE;
		else
			ps <= ns;
	end
endmodule

module ballDied_testbench();
	logic clk, reset;
	logic gameOver;
	logic [9:0] ball_x;
	logic [8:0] ball_y;
	
	ballDied dut (.*);
	
	parameter clk_PERIOD=50;
		initial begin
				clk <= 0;
				forever #(clk_PERIOD/2) clk <= ~clk;
		end // initial
		
	initial begin
			reset <= 1;	ball_x <= 440; ball_y <= 440;	@(posedge clk);
			
			reset <= 0; 						@(posedge clk);

			ball_x <= 455; ball_y <= 448;	@(posedge clk);
													@(posedge clk);
			ball_x <= 456; ball_y <= 449;	@(posedge clk);
													@(posedge clk);
			ball_x <= 457; ball_y <= 450;	@(posedge clk);
													@(posedge clk);
			ball_x <= 458; ball_y <= 451;	@(posedge clk);
													@(posedge clk);
			ball_x <= 459; ball_y <= 452;	@(posedge clk);
													@(posedge clk);
			ball_x <= 460; ball_y <= 453;@(posedge clk);
													@(posedge clk);
		$stop;
	end //initital
	
endmodule // ballDied_testbench