/*
Overview: This module takes a 4 bit binary number and displays it on a HEX display
			 in hexadecimal.
				
input: num -> 5 bit binary number to be display

output: Hex -> a 7 bit display that is programed to light up HEX Displays

calls: None 

*/

module seg7_hexDisplay (num, Hex);
	input logic [4:0] num;
	output logic [6:0] Hex;
	
	always_comb begin
		case (num)	
			 //    Light: 6543210
			5'b00000: begin
							Hex = 7'b1000000;//0
						 end // 4'b0000
			5'b00001: begin
							Hex = 7'b1111001; // 1
						end // 4'b0001
			5'b00010: begin
							Hex = 7'b0100100; // 2
						end // 4'b0010
			5'b00011: begin
							Hex = 7'b0110000; // 3
						end // 4'b0011
			5'b00100: begin
							Hex = 7'b0011001; // 4
						end// 4'b0100
			5'b00101: begin
							Hex = 7'b0010010; // 5
						end// 4'b0101
			5'b00110: begin
							Hex = 7'b0000010; // 6
						end// 4'b0110
			5'b00111: begin
							Hex = 7'b1111000; // 7
						end// 4'b0111
			5'b01000: begin
							Hex = 7'b0000000; // 8
						end// 4'b1000
			5'b01001: begin
							Hex = 7'b0010000; // 9
						end// 4'b1001
			5'b01010: begin
							Hex = 7'b0001000;//A, 10
						end// 4'b1010
			5'b01011: begin
							Hex = 7'b0000011;//B, 11
						end// 4'b1011
			5'b01100: begin
							Hex = 7'b1000110;//C, 12
						end// 4'b1100
			5'b01101: begin
							Hex = 7'b0100001;//D, 13
						end// 4'b1101
			5'b01110: begin
							Hex = 7'b0000110;//E, 14
						end// 4'b1110
			5'b01111: begin
							Hex = 7'b0001110;//F, 15
						end// 4'b1111
			default: begin
							Hex = 7'b1111111;//blank
						end// default
		endcase //case
	end //always_comb
endmodule //seg7_hexDisplay



module seg7_hexDisplay_testbench();
	logic [3:0] num;
	logic [6:0] Hex;
	
	seg7_hexDisplay dut (.num, .Hex);
	
	initial begin
		num <= 4'b0000; #10;//0
		num <= 4'b0001; #10;//1
		num <= 4'b0010; #10;//2
		num <= 4'b0011; #10;//3
		num <= 4'b0100; #10;//4
		num <= 4'b0101; #10;//5
		num <= 4'b0110; #10;//6
		num <= 4'b0111; #10;//7
		num <= 4'b1000; #10;//8
		num <= 4'b1001; #10;//9
		num <= 4'b1010; #10;//10
		num <= 4'b1011; #10;//11
		num <= 4'b1100; #10;//12
		num <= 4'b1101; #10;//13
		num <= 4'b1110; #10;//14
		num <= 4'b1111; #10;//15
		
		$stop;
	end //initial
	
endmodule //seg7_hexDisplay_testbench
