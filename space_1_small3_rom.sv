module space_1_small3_rom (
	input logic clock,
	input logic [16:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:76799] /* synthesis ram_init_file = "C:/Users/Carl/OneDrive - University of Illinois - Urbana/Documents/final_project/space_1_small3.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
