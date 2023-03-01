module Meteor1_mapper (
	input logic [9:0] DrawX, DrawY,
	input logic vga_clk, blank,
	output logic [3:0] red, green, blue
);

logic [9:0] rom_address;
logic [4:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

//assign rom_address = (DrawX*21/640) + (DrawY*24/480 * 21);
assign rom_address = (DrawX/4 + 1) + (DrawY/4 * 21);


always_ff @ (posedge vga_clk) begin
	red <= 4'h0;
	green <= 4'h0;
	blue <= 4'h0;

	if (blank) begin
		red <= palette_red;
		green <= palette_green;
		blue <= palette_blue;
	end
end

Meteor1_rom Meteor1_rom (
	.clock   (vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

Meteor1_palette Meteor1_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

endmodule
