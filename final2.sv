//-------------------------------------------------------------------------
//                                                                       --
//                                                                       --
//      For use with ECE 385 Lab 62                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module final2 (

      ///////// Clocks /////////
      input     MAX10_CLK1_50, 

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 

);


logic Reset_h, vssig, blank, sync, VGA_Clk;


//***************************************************************
// 1s Counter
logic [25:0] counter;
always_ff @(posedge MAX10_CLK1_50 or posedge Reset_h or posedge collide) begin
	if (Reset_h) 
	begin
//		counter = 26'd17108863;
		counter = 0;
	end
	
	else if (collide)
	begin
		counter = counter;
	end
	
	else
	begin
		counter <= counter + 1;
	end
end

//***************************************************************
// LED & hex_counter
logic [23:0] hex_counter;

always_ff @ (posedge counter[25] or posedge Reset_h or posedge collide) begin
	if (Reset_h) 
	begin
		LEDR = 0;
		hex_counter = 0;
	end
	
	else if (collide)
	begin
		LEDR = LEDR;
		hex_counter = hex_counter;
	end
	
	else
	begin
		LEDR <= LEDR + 9'b000000001;
		hex_counter <= hex_counter + 24'b1;
	end
end

//***************************************************************
// HEX Display
logic [3:0] HEX0_in, HEX1_in, HEX2_in, HEX3_in, HEX4_in, HEX5_in;

assign HEX0_in = hex_counter[3:0];
assign HEX1_in = hex_counter[7:4];
assign HEX2_in = hex_counter[11:8];
assign HEX3_in = hex_counter[15:12];
assign HEX4_in = hex_counter[19:16];
assign HEX5_in = hex_counter[23:20];

HexDriver Hex0_ (.In0(HEX0_in), .Out0(HEX0));
HexDriver Hex1_ (.In0(HEX1_in), .Out0(HEX1));
HexDriver Hex2_ (.In0(HEX2_in), .Out0(HEX2));
HexDriver Hex3_ (.In0(HEX3_in), .Out0(HEX3));
HexDriver Hex4_ (.In0(HEX4_in), .Out0(HEX4));
HexDriver Hex5_ (.In0(HEX5_in), .Out0(HEX5));


//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	
	logic [9:0] drawxsig, drawysig, ballxsig, ballysig, ballsizesig;
	
	logic [7:0] Red, Blue, Green;
	logic [7:0] keycode;

//=======================================================
//  Structural coding
//=======================================================
	assign	ARDUINO_IO[10] = SPI0_CS_N;
	assign	ARDUINO_IO[13] = SPI0_SCLK;
	assign	ARDUINO_IO[11] = SPI0_MOSI;
	assign	ARDUINO_IO[12] = 1'bZ;
	assign	SPI0_MISO = ARDUINO_IO[12];
	
	assign	ARDUINO_IO[9] = 1'bZ; 
	assign	USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign	ARDUINO_RESET_N = USB_RST;
	assign	ARDUINO_IO[7] = USB_RST;	//USB reset 
	assign	ARDUINO_IO[8] = 1'bZ;		//this is GPX (set to input)
	assign	USB_GPX = 1'b0;				//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign	ARDUINO_IO[6] = 1'b1;
	
	//Assign one button to reset
	assign	{Reset_h}=~ (KEY[0]);
	

	//Our A/D converter is only 12 bit
	always_ff @ (posedge VGA_Clk) begin
		VGA_R <= 0;
		VGA_B <= 0;
		VGA_G <= 0;
		if (blank) begin
			VGA_R <= Red[7:4];
			VGA_B <= Blue[7:4];
			VGA_G <= Green[7:4];
		end
	end
	
	
	final_soc u0 (
		.clk_clk                           (MAX10_CLK1_50),  //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
//		.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
//		.leds_export({hundreds, signs, LEDR}),
		.keycode_export(keycode)
		
	 );


//instantiate a vga_controller, ball, and color_mapper here with the ports.
logic [9:0] drawxsig2, drawysig2, ballxsig2, ballysig2;
logic [9:0] drawxsig3, drawysig3, ballxsig3, ballysig3;
logic [9:0] drawxsig4, drawysig4, ballxsig4, ballysig4;
logic [9:0] drawxsig5, drawysig5, ballxsig5, ballysig5;

logic collide;
//logic [9:0] Ball_X_Center2, Ball_Y_Motion2;

//assign Ball_X_Center2 = 250;
//assign Ball_Y_Motion2 = 10'd4;

vga_controller vga_	(.Clk(MAX10_CLK1_50), .Reset(Reset_h), 
							 .hs(VGA_HS), .vs(VGA_VS), .pixel_clk(VGA_Clk), .blank(blank), .sync(sync), 
							 .DrawX(drawxsig), .DrawY(drawysig),
							);


ball ball_	(.Reset(Reset_h), .frame_clk(VGA_VS), .keycode(keycode), .led(LEDR),
             .BallX(ballxsig), .BallY(ballysig), .BallS(ballsizesig),
				 
				 .BallX2(ballxsig2), .BallY2(ballysig2), 
//				 .Ball_X_Center2(Ball_X_Center2), .Ball_Y_Motion2(Ball_Y_Motion2),
				 
				 .BallX3(ballxsig3), .BallY3(ballysig3),
				 
				 .BallX4(ballxsig4), .BallY4(ballysig4),
				 
				 .BallX5(ballxsig5), .BallY5(ballysig5),
				 
				 .collide(collide)
				);
							  
							  
color_mapper color_mapper_	(.BallX(ballxsig), .BallY(ballysig), .Ball_size(ballsizesig),

									 .BallX2(ballxsig2), .BallY2(ballysig2),
									 
									 .BallX3(ballxsig3), .BallY3(ballysig3),
									 
									 .BallX4(ballxsig4), .BallY4(ballysig4),
									 
									 .BallX5(ballxsig5), .BallY5(ballysig5),
									 
									 .DrawX(drawxsig), .DrawY(drawysig),
									 .collide(collide), 
									 .vga_clk(VGA_Clk), .blank(blank), .*
									 );
									 

endmodule