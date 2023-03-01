module Game_over1_rom (
	input logic clock,
	input logic [11:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:3071] /* synthesis ram_init_file = "C:/Users/Carl/OneDrive - University of Illinois - Urbana/Documents/final_project/Game_over1.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
