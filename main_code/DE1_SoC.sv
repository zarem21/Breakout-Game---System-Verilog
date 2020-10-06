/*
Overview: This is the top level module for the Breakout game. It calls all other modules and deals primarly with
			 the VGA, audio, and the score of this project.
				
Input: Clocks - CLOCK_50, CLOCK2_50
		 Keyboard inputs - PS2_DAT, PS2_CLK

Output: HEX Display - HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
		  VGA logic - VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS
		  Audio logic - FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT

Calls: score
		 userInput
		 Dificulty
		 keyboard
		 clock_divider
		 vga_driver
		 finite_impulse_response_filter
		 clock_generator
		 audio_and_video_config
		 audio_codec
*/
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, PS2_DAT, PS2_CLK,
					 CLOCK_50, CLOCK2_50, VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS,
					 FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);
					 
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;
	inout logic PS2_DAT;
	inout logic PS2_CLK;
	input CLOCK_50, CLOCK2_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	output logic FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	output logic AUD_XCK;
	input logic AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input logic AUD_ADCDAT;
	output logic AUD_DACDAT;

	assign HEX2 = '1;
	assign HEX3 = '1;
	
	logic reset;
	logic [9:0] x;
	logic [8:0] y;
	logic [7:0] r, g, b;
	assign reset = SW[9];
	
	logic [31:0] clk;
	logic [5:0] whichClock;
	
	//Controls the speed of the ball
	difficulty ball_speed (.clk(CLOCK_50), .reset, .var_1(SW[0]), .var_2(SW[1]), .speed(whichClock));
	//parameter whichClock = 18;
	clock_divider clocks (.clock(CLOCK_50), .reset, .divided_clocks(clk));

	logic L, R, DFFL, DFFR;
	logic [1:0] total_score;
//	ff InputL (.clk(CLOCK_50), .reset, .KEY(~KEY[3]), .out(DFFL));
//	ff InputR (.clk(CLOCK_50), .reset, .KEY(~KEY[0]), .out(DFFR));

	userInput UL (.clk(CLOCK_50), .reset, .key(DFFL), .out(L));
	userInput UR (.clk(CLOCK_50), .reset, .key(DFFR), .out(R));
	
	keyboard key (.HEX4, .HEX5, .clk(CLOCK_50), .reset, .PS2_DAT, .PS2_CLK, .L(DFFL), .R(DFFR));
	score blocks_hit (.clk(clk[whichClock]), .reset, .total_score, .HEX0, .HEX1);
	breakout game (.CLOCK_50, .clk(clk[whichClock]), .reset, .L, .R, .x, .y, .r, .g , .b, .total_score);

	
	video_driver #(.WIDTH(640), .HEIGHT(480))
		v1 (.CLOCK_50, .reset, .x, .y, .r, .g, .b,
			 .VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N,
			 .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);

	//Audio
	logic read_ready, write_ready, read, write;
	logic signed [23:0] readdata_left, readdata_right;
	logic signed [23:0] data_left, data_right;
	logic signed [23:0] writedata_left, writedata_right;
	
	assign read = read_ready;	
	assign write = write_ready;
	
	assign writedata_left = data_left;
	assign writedata_right = data_right;
	
	finite_impulse_response_filter right (.clk(CLOCK_50), .reset, .enable(read_ready & write_ready), .temp(readdata_right), .direction(data_right));
	finite_impulse_response_filter left (.clk(CLOCK_50), .reset, .enable(read_ready & write_ready), .temp(readdata_left), .direction(data_left));
	
	
	clock_generator my_clock_gen(
		CLOCK2_50,
		reset,
		AUD_XCK
	);

	audio_and_video_config cfg(
		CLOCK_50,
		reset,
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		CLOCK_50,
		reset,
		read,	
		write,
		writedata_left, 
		writedata_right,
		AUD_ADCDAT,
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,
		read_ready, 
		write_ready,
		readdata_left, 
		readdata_right,
		AUD_DACDAT
	);
	
	

endmodule
