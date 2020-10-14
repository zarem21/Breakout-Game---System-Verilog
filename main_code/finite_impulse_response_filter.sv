/*
Overvirew: This module is the code for Task #2 of Lab 5. This module is a noise filter that
			  accepts read data from the codec and filters it. It is a averaging finite impulse
			  response filter (FIR). We are averaging the last 8 samples and that is sent back to 
			  the main module to be sent to the speaker. It removes the noise produced when you 
			  speak into a microphone which makes your voice sound clear.

Inputs: clk - clock
		  reset - resets the filter 
		  enable - only able to accept new input if enable is true (read_ready)
		  temp - Is the unfiltered sound sample

Outputs: direction - Sound sample that has now been filtered


Calls: None


*/

module finite_impulse_response_filter (clk, reset, enable, temp, direction);
	input logic  clk, reset, enable;
	input logic signed [23:0] temp;
	output logic signed [23:0] direction;
	
	logic signed [23:0] ps_S1, ns_S1;
	logic signed [23:0] ps_S2, ns_S2;
	logic signed [23:0] ps_S3, ns_S3;
	logic signed [23:0] ps_S4, ns_S4;
	logic signed [23:0] ps_S5, ns_S5;
	logic signed [23:0] ps_S6, ns_S6;
	logic signed [23:0] ps_S7, ns_S7;
	
	logic signed [23:0] add1, add2, add3, add4, add5, add6;
	
	always_comb begin 
		ns_S1 = temp;
		ns_S2 = ps_S1;
		ns_S3 = ps_S2;
		ns_S4 = ps_S3;
		ns_S5 = ps_S4;
		ns_S6 = ps_S5;
		ns_S7 = ps_S6;
		
		add1 = (temp >>> 3) + (ps_S1 >>> 3);
		add2 = add1 + (ps_S2 >>> 3);
		add3 = add2 + (ps_S3 >>> 3);
		add4 = add3 + (ps_S4 >>> 3);
		add5 = add4 + (ps_S5 >>> 3);
		add6 = add5 + (ps_S6 >>> 3);
		
		direction = add6 + (ps_S7 >> 3); //The output is combinational

	end //always_comb
	
	always_ff @(posedge clk) begin
		if (reset) begin
			ps_S1 <= 24'sb0; //initializes all values to zero
			ps_S2 <= 24'sb0;
			ps_S3 <= 24'sb0;
			ps_S4 <= 24'sb0;
			ps_S5 <= 24'sb0;
			ps_S6 <= 24'sb0;
			ps_S7 <= 24'sb0;
		end //if
		else if (enable) begin //only shifts values over if enable is true
				ps_S1 <= ns_S1;
				ps_S2 <= ns_S2;
				ps_S3 <= ns_S3;
				ps_S4 <= ns_S4;
				ps_S5 <= ns_S5;
				ps_S6 <= ns_S6;
				ps_S7 <= ns_S7;
		end //else if
	end //always_ff
	

endmodule //finite_impulse_response_filter

module finite_impulse_response_filter_testbench ();
	logic  clk, reset, enable;
	logic signed [23:0] temp;
	logic signed [23:0] direction;
	
	finite_impulse_response_filter  dut (.*);
	
	// Sets up the clock.
	parameter CLOCK_PERIOD=50;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end //initial
	
	initial begin
		reset <= 0; enable <= 0; temp <= 24'sb0; @(posedge clk);
		reset <= 1;										 @(posedge clk);
		reset <= 0;										 @(posedge clk);
		enable <= 0;												   @(posedge clk);
		enable <= 1; temp <= 1; @(posedge clk);
		enable <= 0;													@(posedge clk);
		enable <= 1; temp <= 3; @(posedge clk);
		enable <= 0;												   @(posedge clk);
		enable <= 1; temp <= 31; @(posedge clk);
		enable <= 0;													@(posedge clk);
		enable <= 1; temp <= 32; @(posedge clk);
		enable <= 0;												   @(posedge clk);
		enable <= 1; temp <= 8; @(posedge clk);
		enable <= 0;													@(posedge clk);
		enable <= 1; temp <= 57; @(posedge clk);
		enable <= 0;												   @(posedge clk);
		enable <= 1; temp <= -96; @(posedge clk);
		enable <= 0;													@(posedge clk);
		enable <= 1; temp <= -24; 									@(posedge clk);
		enable <= 0;												   @(posedge clk);
		enable <= 1; temp <= -8; 									@(posedge clk);
		enable <= 0;													@(posedge clk);
		enable <= 1; temp <= 80; @(posedge clk);
		enable <= 0;												   @(posedge clk);
		enable <= 1; temp <= 16; @(posedge clk);
		enable <= 0;													@(posedge clk);
																			@(posedge clk);
																			@(posedge clk);
																			@(posedge clk);
																			@(posedge clk);
																			$stop;
	end //initial
endmodule //finite_impulse_response_filter_testbench

