/*
Overview: This module reads the input from the keyboard and will output if the 
			 the left button has been pressed or if the right button has been pressed
				
Input: clk - Clock
		 reset - reset
		 PS2_DAT - Used for the keyboard_press_driver, from the board
		 PS2_CLK - Used for the keyboard_press_driver, from the board
		 
Output: HEX4 & HEX5 - show the scan code keys from the keyboard
		  L - true when the left arrow is pressed
		  R - tru when the right arror is pressed

Calls: keyboard_press_driver

*/
module keyboard (HEX4, HEX5, clk, reset, PS2_DAT, PS2_CLK, L, R);
	output logic [6:0] HEX4, HEX5;
	input logic clk, reset;
	input logic PS2_DAT, PS2_CLK;
	output logic L, R;

	logic valid, makeBreak;
	logic [7:0] outCode;

	keyboard_press_driver drive (.CLOCK_50(clk), .valid(valid), .makeBreak(makeBreak), .outCode(outCode), .PS2_DAT(PS2_DAT), .PS2_CLK(PS2_CLK), .reset(reset));	

	//display LOC on HEX1 - HEX0
	logic [4:0] highHolder;
	logic [4:0] lowHolder;
	always_comb begin
		if (outCode < 8'd16) begin
			lowHolder = {1'b0, outCode[3:0]};
			highHolder = 5'b11111;
		end //if
		else begin
			lowHolder = {1'b0, outCode[3:0]};
			highHolder = {1'b0, outCode[7:4]};
		end //else
	end
	
	//Display LOC values(in hex) on HEX1 - HEX0
	seg7_hexDisplay low (.num(lowHolder), .Hex(HEX4));
	seg7_hexDisplay high (.num(highHolder), .Hex(HEX5));
	
	
	enum {Idle, Left, Right} ps, ns;
	
	always_comb begin
		case (ps)
			Idle: begin //when nothig is being pressed
				if ((makeBreak & outCode == 8'h61)) 
					ns = Left;
				else if ((makeBreak & outCode == 8'h6A))
					ns = Right;
				else 
					ns = Idle;
			end // Idle
			
			Left: begin // when left arrow is pressed
				if (~makeBreak)
					ns = Idle;
				else
					ns = Left;
			end// Left
			
			Right: begin// When right arrow is pressed
				if (~makeBreak)
					ns = Idle;
				else 
					ns = Right;
			
			end// Right
		endcase // case
	end // always_ff
	
	assign L = (ps == Left);
	assign R = (ps == Right);
	
	
	always_ff @(posedge clk) begin
		if (reset) 
			ps <= Idle;
		else 
			ps <= ns;
	
	end // always_ff			  
					  
endmodule //keyboard


module keyboard_testbench ();
	logic clk, reset;
	logic PS2_DAT, PS2_CLK; 
	logic L, R;
	logic valid, makeBreak;
	logic [6:0] HEX4, HEX5;
	
	// Sets up the clock.
	parameter CLOCK_PERIOD=50;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end //initial
	
	keyboard dut (.*);
	
	
	initial begin
		reset <= 0;  @(posedge clk);
	
	
	
		$stop;
	end// initial



endmodule //keyboard_testbench

