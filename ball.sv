//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input Reset, frame_clk,
					input [7:0] keycode,
					input [9:0] led,
//					input [9:0] Ball_X_Center2, Ball_Y_Motion2,
               output [9:0] BallX, BallY, BallS, 
					output [9:0] BallX2, BallY2,
					output [9:0] BallX3, BallY3,
					output [9:0] BallX4, BallY4,
					output [9:0] BallX5, BallY5,
					output collide
				);
   
	logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Size, Ball_Y_Motion;

	parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
	parameter [9:0] Ball_Y_Center=300;  // Center position on the Y axis

	parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
	parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
	parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
	parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
	parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
	parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis

//	assign Ball_Size = 10;

	always_ff @ (posedge Reset or posedge frame_clk or posedge collide)
	begin: Move_Ball
		if (Reset)  // Asynchronous Reset
		begin 
			Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
			Ball_X_Motion <= 10'd0; //Ball_X_Step;
			Ball_Y_Pos <= Ball_Y_Center;
			Ball_X_Pos <= Ball_X_Center;
		end

		else if (collide)
		begin
			Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
			Ball_X_Motion <= 10'd0; //Ball_X_Step;
		end
		
		else
		begin	// Wall Bounce Detection
//			if ( (Ball_Y_Pos + Ball_Size) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
			if ( (Ball_Y_Pos + 53) >= Ball_Y_Max )
				Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);  // 2's complement.
			
//			else if ( (Ball_Y_Pos - Ball_Size) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
			else if ( (Ball_Y_Pos - 1) >= Ball_Y_Min )
				Ball_Y_Motion <= Ball_Y_Step;
			
//			else if ( (Ball_X_Pos + Ball_Size) >= Ball_X_Max )  // Ball is at the Right edge, BOUNCE!
			else if ( (Ball_X_Pos + 30) <= Ball_X_Max )
				Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);  // 2's complement.
			
//			else if ( (Ball_X_Pos - Ball_Size) <= Ball_X_Min )  // Ball is at the Left edge, BOUNCE!
			else if ( (Ball_X_Pos - 1) <= Ball_X_Min )
				Ball_X_Motion <= Ball_X_Step;
			
			else 
				Ball_Y_Motion <= Ball_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
				
				case (keycode)
					8'h04 : begin	//A
						if (Ball_X_Pos > 1)
							Ball_X_Motion <= -1;
						else
							Ball_X_Motion <= 0;
							
						Ball_Y_Motion<= 0;
					end
					        
					8'h07 : begin	//D
						if (Ball_X_Pos + 30 < 639)
							Ball_X_Motion <= 1;
						else
							Ball_X_Motion <= 0;
						
						Ball_Y_Motion <= 0;
					end
							  
//					8'h16 : begin
//						Ball_Y_Motion <= 1;//S
//						Ball_X_Motion <= 0;
//					end
//							  
//					8'h1A : begin
//					   Ball_Y_Motion <= -1;//W
//						Ball_X_Motion <= 0;
//					end
					
					default: begin
						Ball_Y_Motion <= 0;
						Ball_X_Motion <= 0;
					end
			   endcase
				
				// Update ball position
				Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);
				Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
				
		end
	end
       
	assign BallX = Ball_X_Pos;
	assign BallY = Ball_Y_Pos;
	assign BallS = Ball_Size;
	
//*************************************************************** 1st Meteor

	logic [9:0] Ball_X_Pos2, Ball_X_Motion2, Ball_Y_Pos2;
	logic [9:0] Ball_Y_Motion2;

	parameter [9:0] Ball_X_Center2=250;  // Center position on the X axis
	parameter [9:0] Ball_Y_Center2=0;  // Center position on the Y axis
	
	always_ff @ (posedge Reset or posedge frame_clk or posedge collide)
	begin: Move_Ball2
		if (Reset)  // Asynchronous Reset
		begin 
			Ball_Y_Motion2 <= 10'd2; //Ball_Y_Step;
			Ball_X_Motion2 <= 10'd0; //Ball_X_Step;
			Ball_Y_Pos2 <= Ball_Y_Center2;
			Ball_X_Pos2 <= Ball_X_Center2;
		end

		else if (collide == 1'b1)
		begin
			Ball_X_Motion2 <= 10'd0; //Ball_X_Step;
		end
		
		else if ((Ball_Y_Pos2 > 480) && ((Ball_Y_Pos2 < 485)))
		begin
			Ball_X_Pos2 <= (led[3:0] * Ball_X_Pos2 + (frame_clk * 20) + (Ball_X_Motion2 * 20) + Ball_X_Pos) % 556;
			Ball_Y_Pos2 <= (Ball_Y_Pos2 + Ball_Y_Motion2);  // Update ball position
		end

		else 
		begin   
			Ball_Y_Pos2 <= (Ball_Y_Pos2 + Ball_Y_Motion2);  // Update ball position
		end
	end

	assign BallY2 = Ball_Y_Pos2;
	assign BallX2 = Ball_X_Pos2;
	
//***************************************************************	2nd Meteor

	logic [9:0] Ball_X_Pos3, Ball_X_Motion3, Ball_Y_Pos3;
	logic [9:0] Ball_Y_Motion3;

	parameter [9:0] Ball_X_Center3=300;	// Center position on the X axis
	parameter [9:0] Ball_Y_Center3=400;	// Center position on the Y axis
	
	always_ff @ (posedge Reset or posedge frame_clk or posedge collide)
	begin: Move_Ball3
		if (Reset)  // Asynchronous Reset
		begin 
			Ball_Y_Motion3 <= 10'd4; //Ball_Y_Step;
			Ball_X_Motion3 <= 10'd0; //Ball_X_Step;
			Ball_Y_Pos3 <= Ball_Y_Center3;
			Ball_X_Pos3 <= Ball_X_Center3;
		end

		else if (collide == 1'b1)
		begin
			Ball_X_Motion3 <= 10'd0; //Ball_X_Step;
		end
		
		else if ((Ball_Y_Pos3 > 480) && ((Ball_Y_Pos3 < 485)))
		begin
			Ball_X_Pos3 <= (led[4:1] * Ball_X_Pos3 + (frame_clk * 55) + (Ball_X_Motion3 * 100) + Ball_X_Pos) % 556;
			Ball_Y_Pos3 <= (Ball_Y_Pos3 + Ball_Y_Motion3);  // Update ball position
		end

		else 
		begin   
			Ball_Y_Pos3 <= (Ball_Y_Pos3 + Ball_Y_Motion3);  // Update ball position
		end
	end

	assign BallY3 = Ball_Y_Pos3;
	assign BallX3 = Ball_X_Pos3;
	
//***************************************************************	3rd Meteor

	logic [9:0] Ball_X_Pos4, Ball_X_Motion4, Ball_Y_Pos4;
	logic [9:0] Ball_Y_Motion4;

	parameter [9:0] Ball_X_Center4=200;	// Center position on the X axis
	parameter [9:0] Ball_Y_Center4=500;	// Center position on the Y axis
	
	always_ff @ (posedge Reset or posedge frame_clk or posedge collide)
	begin: Move_Ball4
		if (Reset)  // Asynchronous Reset
		begin 
			Ball_Y_Motion4 <= 10'd3; //Ball_Y_Step;
			Ball_X_Motion4 <= 10'd0; //Ball_X_Step;
			Ball_Y_Pos4 <= Ball_Y_Center4;
			Ball_X_Pos4 <= Ball_X_Center4;
		end

		else if (collide == 1'b1)
		begin
			Ball_X_Motion4 <= 10'd0; //Ball_X_Step;
		end
		
		else if ((Ball_Y_Pos4 > 480) && ((Ball_Y_Pos4 < 485)))
		begin
			Ball_X_Pos4 <= (led[4:1] * Ball_X_Pos4 + (frame_clk * 55) + (Ball_X_Motion4 * 100) + Ball_X_Pos) % 556;
			Ball_Y_Pos4 <= (Ball_Y_Pos4 + Ball_Y_Motion4);  // Update ball position
		end

		else 
		begin   
			Ball_Y_Pos4 <= (Ball_Y_Pos4 + Ball_Y_Motion4);  // Update ball position
		end
	end

	assign BallY4 = Ball_Y_Pos4;
	assign BallX4 = Ball_X_Pos4;
	
//***************************************************************	4th Meteor

	logic [9:0] Ball_X_Pos5, Ball_X_Motion5, Ball_Y_Pos5;
	logic [9:0] Ball_Y_Motion5;

	parameter [9:0] Ball_X_Center5=200;	// Center position on the X axis
	parameter [9:0] Ball_Y_Center5=500;	// Center position on the Y axis
	
	always_ff @ (posedge Reset or posedge frame_clk or posedge collide)
	begin: Move_Ball5
		if (Reset)  // Asynchronous Reset
		begin 
			Ball_Y_Motion5 <= 10'd3; //Ball_Y_Step;
			Ball_X_Motion5 <= 10'd0; //Ball_X_Step;
			Ball_Y_Pos5 <= Ball_Y_Center5;
			Ball_X_Pos5 <= Ball_X_Center5;
		end

		else if (collide == 1'b1)
		begin
			Ball_X_Motion5 <= 10'd0; //Ball_X_Step;
		end
		
		else if ((Ball_Y_Pos5 > 480) && ((Ball_Y_Pos5 < 485)))
		begin
			Ball_X_Pos5 <= (led[5:1] * Ball_X_Pos5 + (frame_clk * 55) + (Ball_X_Motion5 * 100) + Ball_X_Pos) % 556;
			Ball_Y_Pos5 <= (Ball_Y_Pos5 + Ball_Y_Motion5);  // Update ball position
		end

		else 
		begin   
			Ball_Y_Pos5 <= (Ball_Y_Pos5 + Ball_Y_Motion5);  // Update ball position
		end
	end

	assign BallY5 = Ball_Y_Pos5;
	assign BallX5 = Ball_X_Pos5;
	
//***************************************************************

	logic collide1, collide2, collide3, collide4;
	
	always_comb		// for 1st meteor
	begin
//	rect1.x < rect2.x + rect2.w && rect1.x + rect1.w > rect2.x &&
//	rect1.y < rect2.y + rect2.h && rect1.h + rect1.y > rect2.y
//		if ((BallX + 15 < BallX2 + 84) && (BallX + 15 > BallX2) && (BallY + 26 < BallY2 + 96) && (BallY + 26 > BallY2))
//		if ((((BallX-BallX2-40)**2) + ((BallY-BallY2-70)**2)) < (25)**2)
//		if (((BallX - BallX2 - 20) < 40) && (((BallY+0) - (BallY2+60)) < 34))
//		if ((BallY2+90 >= BallY) && (((BallX+15 - BallX2+48) <= 0) || ((BallX2+48 - BallX+15) <= 0)))
//		if ((BallX+15 < BallX2+84-20) && (BallX+15 > BallX2+20) && (BallY+26-12 < BallY2+96) && (BallY+26-12 > BallY2))

		if ((BallX+15 < BallX2+84-20) && (BallX+15 > BallX2+15) && (BallY+26-12 < BallY2+96) && (BallY+26-12 > BallY2))
			collide1 = 1'b1;
		else
			collide1 = 1'b0;
	end
	
	always_comb		// for 2nd meteor
	begin
		if ((BallX+15 < BallX3+84-20) && (BallX+15 > BallX3+15) && (BallY+26-12 < BallY3+96) && (BallY+26-12 > BallY3))
			collide2 = 1'b1;
		else
			collide2 = 1'b0;
	end
	
	always_comb		// for 3rd meteor
	begin
		if ((BallX+15 < BallX4+84-20) && (BallX+15 > BallX4+15) && (BallY+26-12 < BallY4+96) && (BallY+26-12 > BallY4))
			collide3 = 1'b1;
		else
			collide3 = 1'b0;
	end
	
	always_comb		// for 4th meteor
	begin
		if ((BallX+15 < BallX5+84-20) && (BallX+15 > BallX5+15) && (BallY+26-12 < BallY5+96) && (BallY+26-12 > BallY5))
			collide4 = 1'b1;
		else
			collide4 = 1'b0;
	end
	
	always_comb
	begin
		if (collide1 || collide2 || collide3 || collide4)
			collide = 1'b1;
		else
			collide = 1'b0;
	end
		
endmodule
