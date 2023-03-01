module Meteor1_rom (
	input logic clock,
	input logic [8:0] address,
	output logic [3:0] q
);

logic [3:0] memory [0:503] /* synthesis ram_init_file = "C:/Users/Carl/OneDrive - University of Illinois - Urbana/Documents/final_project/Meteor1.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
