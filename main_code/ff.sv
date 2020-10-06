// This module is is a double flip flop used to catch any timing errors.
module ff (clk, reset, KEY, out);
	input logic clk, reset;
	input logic KEY;
	output logic out;
	logic intermediate;
	
	
	always_ff @(posedge clk) begin
		if (reset) begin
			intermediate <= 0;
			out <= 0;
		end else begin
			intermediate <= KEY;
			out <= intermediate;
		end
	end
	
endmodule

module ff_testbench ();
	logic clk, reset, KEY;
	
	ff dut (.clk, .reset,.KEY);
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	
	initial begin
										@(posedge clk);
		reset <= 1;					@(posedge clk);
		reset <= 0; KEY <= 0;	@(posedge clk);
										@(posedge clk);
										@(posedge clk);
						KEY <= 1;	@(posedge clk);
										@(posedge clk);
										@(posedge clk);
						KEY <= 0;	@(posedge clk);
										@(posedge clk);
										@(posedge clk);
		reset <= 1; KEY <= 1;	@(posedge clk);
										@(posedge clk);
										@(posedge clk);
						KEY <= 1;	@(posedge clk);
										@(posedge clk);
										@(posedge clk);
										$stop;
	end
endmodule
										
						
					
	
