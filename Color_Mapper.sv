//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module color_mapper (input        [9:0] BallX, BallY, DrawX, DrawY, Ball_size,
							input        [9:0] BallX2, BallY2,
							input        [9:0] BallX3, BallY3,
							input        [9:0] BallX4, BallY4,
							input        [9:0] BallX5, BallY5,
							input					 vga_clk, blank, collide,
                     output logic [7:0] Red, Green, Blue
						  );

logic ball_on, ball_on2, ball_on3, ball_on4, ball_on5;

	  
int Size;
logic [9:0] DistX, DistY;

assign DistX = DrawX - BallX;
assign DistY = DrawY - BallY;
//assign Size = Ball_size;

always_comb
begin:Ball_on_proc
//	if ( ( DistX*DistX + DistY*DistY) <= (Size * Size) )	// spherical sprite's shape
	if (DistX < 30 && DistY < 53)	// square sprite's shape
		ball_on = 1'b1;
	else
		ball_on = 1'b0;
end


logic [9:0] DistX2, DistY2;
assign DistX2 = DrawX - BallX2;
assign DistY2 = DrawY - BallY2;

always_comb
begin:Ball_on_proc2
	if (DistX2 < 84 && DistY2 < 96)
		ball_on2 = 1'b1;
	else 
		ball_on2 = 1'b0;
end


logic [9:0] DistX3, DistY3;
assign DistX3 = DrawX - BallX3;
assign DistY3 = DrawY - BallY3;

always_comb
begin:Ball_on_proc3
	if (DistX3 < 84 && DistY3 < 96)
		ball_on3 = 1'b1;
	else 
		ball_on3 = 1'b0;
end


logic [9:0] DistX4, DistY4;
assign DistX4 = DrawX - BallX4;
assign DistY4 = DrawY - BallY4;

always_comb
begin:Ball_on_proc4
	if (DistX4 < 84 && DistY4 < 96)
		ball_on4 = 1'b1;
	else 
		ball_on4 = 1'b0;
end


logic [9:0] DistX5, DistY5;
assign DistX5 = DrawX - BallX5;
assign DistY5 = DrawY - BallY5;

always_comb
begin:Ball_on_proc5
	if (DistX5 < 84 && DistY5 < 96)
		ball_on5 = 1'b1;
	else 
		ball_on5 = 1'b0;
end


// Ian's tool
logic [3:0] bg_r, bg_g, bg_b, bg_r2, bg_g2, bg_b2, bg_r3, bg_g3, bg_b3, bg_r4, bg_g4, bg_b4;
logic [3:0] bg_r5, bg_g5, bg_b5;
logic [3:0] bg_r6, bg_g6, bg_b6;
logic [3:0] bg_r7, bg_g7, bg_b7;

space_1_small3_mapper space_1_small3_mapper_(.DrawX(DrawX), .DrawY(DrawY), .vga_clk(vga_clk), .blank(blank),
															.red(bg_r), .green(bg_g), .blue(bg_b));
															
Game_over1_mapper Game_over1_mapper_(.DrawX(DrawX), .DrawY(DrawY), .vga_clk(vga_clk), .blank(blank),
												 .red(bg_r2), .green(bg_g2), .blue(bg_b2));
												 
spaceship2_mapper spaceship2_mapper_(.DrawX(DistX), .DrawY(DistY), .vga_clk(vga_clk), .blank(blank),
											  .red(bg_r3), .green(bg_g3), .blue(bg_b3));
												 
Meteor1_mapper Meteor1_mapper_(.DrawX(DistX2), .DrawY(DistY2), .vga_clk(vga_clk), .blank(blank),
										 .red(bg_r4), .green(bg_g4), .blue(bg_b4));
										 
Meteor1_mapper Meteor1_mapper_2(.DrawX(DistX3), .DrawY(DistY3), .vga_clk(vga_clk), .blank(blank),
										  .red(bg_r5), .green(bg_g5), .blue(bg_b5));
										  
Meteor1_mapper Meteor1_mapper_3(.DrawX(DistX4), .DrawY(DistY4), .vga_clk(vga_clk), .blank(blank),
										  .red(bg_r6), .green(bg_g6), .blue(bg_b6));
										  
Meteor1_mapper Meteor1_mapper_4(.DrawX(DistX5), .DrawY(DistY5), .vga_clk(vga_clk), .blank(blank),
										  .red(bg_r7), .green(bg_g7), .blue(bg_b7));


always_comb
begin:RGB_Display
	Red 	= '0;
	Green = '0;
	Blue 	= '0;
	if ((ball_on == 1'b1) && ({bg_r3, bg_g3, bg_b3} != {4'h0, 4'hE, 4'h0}) && ({bg_r3, bg_g3, bg_b3} != {4'h0, 4'hB, 4'h0}) && ({bg_r3, bg_g3, bg_b3} != {4'h0, 4'h7, 4'h0}) && ({bg_r3, bg_g3, bg_b3} != {4'h2, 4'h4, 4'h0}))	// spaceship is drawn here
	begin
		Red 	= {bg_r3, 4'b0000};
		Green = {bg_g3, 4'b0000};
		Blue 	= {bg_b3, 4'b0000};
	end
	
	else if ((ball_on2 == 1'b1) && ({bg_r4, bg_g4, bg_b4} != {4'h0, 4'h0, 4'h0}))	// 1st meteor is drawn here
		begin 
			Red 	= {bg_r4, 4'b0000};
			Green = {bg_g4, 4'b0000};
			Blue 	= {bg_b4, 4'b0000};
		end
		
	else if ((ball_on3 == 1'b1) && ({bg_r5, bg_g5, bg_b5} != {4'h0, 4'h0, 4'h0}))	// 2nd meteor is drawn here
		begin 
			Red 	= {bg_r5, 4'b0000};
			Green = {bg_g5, 4'b0000};
			Blue 	= {bg_b5, 4'b0000};
		end
		
	else if ((ball_on4 == 1'b1) && ({bg_r6, bg_g6, bg_b6} != {4'h0, 4'h0, 4'h0}))	// 3rd meteor is drawn here
		begin 
			Red 	= {bg_r6, 4'b0000};
			Green = {bg_g6, 4'b0000};
			Blue 	= {bg_b6, 4'b0000};
		end
	
	else if ((ball_on5 == 1'b1) && ({bg_r7, bg_g7, bg_b7} != {4'h0, 4'h0, 4'h0}))	// 4th meteor is drawn here
		begin 
			Red 	= {bg_r7, 4'b0000};
			Green = {bg_g7, 4'b0000};
			Blue 	= {bg_b7, 4'b0000};
		end
	
	else
		begin	// background is drawn here
			if (~collide)
			begin
				Red 	= {bg_r, 4'b0000};
				Green = {bg_g, 4'b0000};
				Blue 	= {bg_b, 4'b0000};
			end
			
			else // GAME OVER screen
			begin
				Red 	= {bg_r2, 4'b0000};
				Green = {bg_g2, 4'b0000};
				Blue 	= {bg_b2, 4'b0000};
			end
		end
end

endmodule
