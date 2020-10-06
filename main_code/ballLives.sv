module ballLives (clk, reset, gameOver, out);
	input logic clk, reset;
	
	enum {FULL, TWO, ONE, DEAD} ps, ns;
	
	always_comb begin
		case(ps)
			FULL: begin
						if (gameOver)
							ns = TWO;
						else
							ns = ps;
					end
					
			TWO: begin
						if (gameOver)
							ns = TWO;
						else
							ns = ps;
					end
			ONE: begin
						if (gameOver)
							ns = TWO;
						else
							ns = ps;
					end
		endcase
	end
endmodule