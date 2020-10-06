/*
Overview: The breakout module is the top-level module for the breakout game. This
			 is where all of the center modules are called to bring together the game.
				
Input:  
		clk- clock_divider clock
		CLOCK_50- DE1_SoC clock
		reset - central reset
		L - Left arrow
		R - Right arrow
		X - x returned by VGA
		y - y returned by VGA

		  
Output: 
		r - Red input for VGA
		g - Green input for VGA
		b - Blue input for VGA
		total_score - instantaneous amount of bricks broken

Calls: 
		ball_movement
		paddle_movement
		collision
		collision_ball_row_brick
		ball_Died

*/
module breakout #(H_SIZE = 3) (CLOCK_50, clk, reset, L, R, x, y, r, g, b, total_score);
	input logic clk, CLOCK_50, reset, L, R;
	input logic [9:0] x;
	input logic [8:0] y;
	output logic [7:0] r, g, b;
	output logic [1:0] total_score;
	
	logic [9:0] brick [4:0];
	logic [9:0] brick_alive [4:0];
	logic [9:0] x1 [10:0];
	logic [9:0] x2 [9:0];
	logic [8:0] y_var [5:0];
	logic [8:0] row2_y1, row3_y1;
	logic [8:0] row2_y2, row3_y2;
	logic [9:0] ball_x1, ball_x2, ball_x;
	logic [8:0] ball_y1, ball_y2, ball_y;
	
	logic paddle;
	logic ball;
	logic gameOver;
	logic gameFinished;
	
	assign x1[10] = x2[9];
	assign x1[0] = 10'd20;
	assign x2[0] = 10'd80;
	assign y_var[0] = 9'd40;
	assign gameFinished = (brick_alive[0] == 10'b0) & (brick_alive[1] == 10'b0) & (brick_alive[2] == 10'b0) & (brick_alive[3] == 10'b0) & (brick_alive[4] == 10'b0);
	assign ball = (x > ball_x1) & (y > ball_y1) & (x < ball_x2) & (y < ball_y2) & ~gameOver & ~gameFinished;
	
	// x and y placements for each brick
	genvar j;
		generate
			for (j = 1; j < 10; j++) begin : xyInitial
				assign x1[j] = x2[j - 1];
				assign x2[j] = x2[j - 1] + 10'd60;
				if (j < 6) begin
					assign y_var[j] = y_var[j - 1] + 9'd40;
				end
			end //xyinitial
		endgenerate	

	// brick initialization
	genvar i;
		generate
			for (i = 0; i < 10; i++) begin : BlockInitial
				assign brick[0][i] = ((x > x1[i]) & (y >  y_var[0]) & (x < x2[i]) & (y < y_var[1]) & brick_alive[0][i] & ~gameOver);
				assign brick[1][i] = ((x > x1[i]) & (y >  y_var[1]) & (x < x2[i]) & (y < y_var[2]) & brick_alive[1][i] & ~gameOver);
				assign brick[2][i] = ((x > x1[i]) & (y >  y_var[2]) & (x < x2[i]) & (y < y_var[3]) & brick_alive[2][i] & ~gameOver);
				assign brick[3][i] = ((x > x1[i]) & (y >  y_var[3]) & (x < x2[i]) & (y < y_var[4]) & brick_alive[3][i] & ~gameOver);
				assign brick[4][i] = ((x > x1[i]) & (y >  y_var[4]) & (x < x2[i]) & (y < y_var[5]) & brick_alive[4][i] & ~gameOver);
			end // BlockInitial
		endgenerate
	
  //Collision with a brick in the row 1
	logic [4:0] row_XHit, row_YHit;
	logic xHit, yHit;
	assign xHit = row_XHit[0] | row_XHit[1] | row_XHit[2] | row_XHit[3] | row_XHit[4];
	assign yHit = row_YHit[0] | row_YHit[1] | row_YHit[2] | row_YHit[3] | row_YHit[4];
	genvar k;
		generate
			for (k = 0; k < 5; k++) begin : deflect
				collision_ball_row_brick #(3) row1 (.clk, .y1(y_var[k]), .y2(y_var[k+1]), .x_var(x1), .brick_alive(brick_alive[k]), .ball_x, 
														 .ball_y, .x_hit(row_XHit[k]), .y_hit(row_YHit[k]));
			end
		endgenerate	
	logic [9:0] pOne [4:0];
	logic [1:0] row_pOne [4:0];
	genvar n, m;
	// at the end of every row, or all of the pOne's together. Then outside the generate statement, assign total_score to be 
	// the or of all the rows' pOne's
	generate
			for (n = 0; n < 5; n++) begin : aliveOrDead
				for (m = 0; m < 10; m++) begin: eachBrick
					collision #(H_SIZE) deadOrAlive (.clk, .reset, .brick_alive(brick_alive[n][m]), .ball_x, .ball_y, .x1(x1[m]), .x2(x2[m]), 
														 .y1(y_var[n]), .y2(y_var[n+1]), .pOne(pOne[n][m]));
				end // eachBrick
				assign row_pOne[n] = pOne[n][0] + pOne[n][1] + pOne[n][2] + pOne[n][3] + pOne[n][4] + pOne[n][5] + pOne[n][6] + pOne[n][7] + pOne[n][8] + pOne[n][9];
			end // aliveOrDead
		endgenerate
		
	assign total_score = row_pOne[0] + row_pOne[1] + row_pOne[2] + row_pOne[3] + row_pOne[4];
	
	logic [9:0] paddle_x1, paddle_x2;
	
	ballDied checkEndGame (.clk, .reset, .ball_x, .ball_y, .gameOver);
	paddle_movement move_paddle (.clk, .reset, .x, .y, .L, .R, .paddle, .x1(paddle_x1), .x2(paddle_x2));
	ball_movement #(H_SIZE) ball_move 
							 (
							  .clk,
							  .reset(reset),
							  .paddle_x1(paddle_x1),
							  .paddle_x2(paddle_x2),
							  .x_hit(xHit),
							  .y_hit(yHit),
							  .gameOver,
							  .x1(ball_x1), 
							  .x2(ball_x2),
							  .y1(ball_y1), 
							  .y2(ball_y2),
							  .x(ball_x),
							  .y(ball_y)
							  );
							  
	always_ff @(posedge CLOCK_50) begin
		if (brick[0][0] || brick[0][1] || brick[0][2] || brick[0][3] || brick[0][4] || brick[0][5] || brick[0][6] || brick[0][7] || brick[0][8] || brick[0][9] ||
		    brick[3][0] || brick[3][1] || brick[3][2] || brick[3][3] || brick[3][4] || brick[3][5] || brick[3][6] || brick[3][7] || brick[3][8] || brick[3][9] ||
			 brick[4][0] || brick[4][1] || brick[4][2] || brick[4][3] || brick[4][4] || brick[4][5] || brick[4][6] || brick[4][7] || brick[4][8] || brick[4][9] ||
			 paddle || ball || gameOver)
			r <= 8'b11111111;
		else 
			r <= 8'b00000000;
			
		if (brick[1][0] || brick[1][1] || brick[1][2] || brick[1][3] || brick[1][4] || brick[1][5] || brick[1][6] || brick[1][7] || brick[1][8] || brick[1][9] ||
		    brick[4][0] || brick[4][1] || brick[4][2] || brick[4][3] || brick[4][4] || brick[4][5] || brick[4][6] || brick[4][7] || brick[4][8] || brick[4][9] ||
			 paddle || ball)
			b <= 8'b11111111;
		else
			b <= 8'b00000000;
			
		if (brick[2][0] || brick[2][1] || brick[2][2] || brick[2][3] || brick[2][4] || brick[2][5] || brick[2][6] || brick[2][7] || brick[2][8] || brick[2][9] ||
			 brick[3][0] || brick[3][1] || brick[3][2] || brick[3][3] || brick[3][4] || brick[3][5] || brick[3][6] || brick[3][7] || brick[3][8] || brick[3][9] ||
			 paddle || ball || gameFinished)
			g <= 8'b11111111;
		else
			g <= 8'b00000000;
		
	end // always_ff
endmodule // breakout
