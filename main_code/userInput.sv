// This module makes sure that each user input is only true for one cycle.
module userInput (clk, reset, key, out);
	input logic clk, reset, key;
	output logic out;
	enum {OFF, ON} ps, ns;
	
	always_comb begin
		
		ns = ps;
		case (ps)
			OFF: if (key) begin
							  ns = ON;
				  end else begin
							  ns = OFF;
				  end
			ON: if (~key) begin
							  ns = OFF;
				 end else begin
							  ns = ON;
				 end
		endcase
	end
	assign out = (ps == OFF) & key;
	
	always_ff @(posedge clk) begin
		if (reset)
			ps <= OFF;
		else
			ps <= ns;
	end
endmodule

module userInput_testbench ();
	logic clk, reset, key, out;
	userInput dut (.clk, .reset, .key, .out);
	
	parameter CLOCK_PERIOD = 100;
	initial begin 
		clk <= 0;
		forever#(CLOCK_PERIOD/2) clk <= ~clk;
		
	end
	
	initial begin
										@(posedge clk);
		reset <= 1;					@(posedge clk);
		reset <= 0; key <= 0;	@(posedge clk);
										@(posedge clk);
										@(posedge clk);
						key <= 1;	@(posedge clk);
										@(posedge clk);
										@(posedge clk);
						key <= 0;	@(posedge clk);
										@(posedge clk);
						key <= 0;	@(posedge clk);
										@(posedge clk);
		reset <= 1; key <= 1;	@(posedge clk);
										@(posedge clk);
						reset <= 0;	@(posedge clk);
						key <= 1;	@(posedge clk);
										@(posedge clk);
										@(posedge clk);
										$stop;
	end
	
endmodule


