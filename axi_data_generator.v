module axi_data_generator #(
	parameter DATA_WD = 32,
	parameter DATA_BYTE_WD = DATA_WD / 8,
	parameter BYTE_CNT_WD = $clog2(DATA_BYTE_WD)
) (
	input 						clk				,
	input 						rst_n			,

	// AXI Stream output original data
	output 						valid_in		,
	output [DATA_WD-1 : 0] 		data_in   		,
	output [DATA_BYTE_WD-1 : 0] keep_in   		,
	output 						last_in   		,
	input 						ready_in  		,

	// AXI Stream input with header inserted
	input 						valid_out 		,
	input [DATA_WD-1 : 0] 		data_out  		,
	input [DATA_BYTE_WD-1 : 0]  keep_out  		,
	input 						last_out  		,
	output 						ready_out 		,

	// The header to be inserted to AXI Stream output
	output 						valid_insert 	,
	output [DATA_WD-1 : 0] 		data_insert		,
	output [DATA_BYTE_WD-1 : 0] keep_insert		,
	output [BYTE_CNT_WD-1 : 0] 	byte_insert_cnt ,
	input 						ready_insert
);

/********************寄存器***********************/
reg	[DATA_WD-1 : 0] 	 r_data_in   		;	
reg    					 r_last_in	 		;
reg						 r_valid_in			;

reg 					 r_valid_insert 	;
reg [DATA_WD-1 : 0] 	 r_data_insert		;		
reg [BYTE_CNT_WD-1 : 0]  r_byte_insert_cnt  ;
reg [BYTE_CNT_WD-1 : 0]  r_byte_in			;
reg						 r_insert			;

/********************网线型***********************/


/********************组合逻辑*********************/
assign  data_in   	    = r_data_in   	  	;

assign  last_in	 	    = r_last_in	 	  	;

assign  valid_insert    = r_valid_insert   	;
assign  data_insert	    = r_data_insert	  	;  
assign  byte_insert_cnt = r_byte_insert_cnt ;

assign keep_insert = 
	(r_byte_insert_cnt == 2'b11) ? 4'b1111 :
	(r_byte_insert_cnt == 2'b10) ? 4'b0111 :
	(r_byte_insert_cnt == 2'b01) ? 4'b0011 : 4'b0001 ;

assign keep_in = 
	(r_byte_in == 2'b11 && r_last_in) ? 4'b1111 :
	(r_byte_in == 2'b10 && r_last_in) ? 4'b1110 :
	(r_byte_in == 2'b01 && r_last_in) ? 4'b1100 :
	(r_byte_in == 2'b00 && r_last_in) ? 4'b1000 :
	4'b1111;

assign ready_out = (ready_insert || ready_in) ? 'd1 : 'd0;
assign valid_in = r_valid_in;
/********************时序逻辑********************/
always@(posedge clk or negedge rst_n)
if(~rst_n || last_in)
	r_insert <= 'd1;
else if(ready_insert && ~valid_insert)
	r_insert <= 'd0;

always@(posedge clk or negedge rst_n)
if(~rst_n)begin
    r_valid_insert    <= 'd0;
    r_data_insert	  <= 'd0;
    r_byte_insert_cnt <= 'd0;
end
else begin
	if(ready_insert && ~valid_insert && ~valid_in)begin
		r_valid_insert <= $random()%2;
		r_data_insert  <= $random();
		r_byte_insert_cnt <= $random()%4;
	end
	else begin
		r_valid_insert <= 'd0;
	end
end

always@(posedge clk or negedge rst_n)
if(~rst_n)begin
    r_data_in   <= 'd0;
    r_last_in	<= 'd0;
	r_byte_in	<= 'd0;
	r_valid_in  <= 'd0;
end
else begin
	if((~r_insert && ~last_in && valid_insert) || 
		(valid_in && ~last_in))begin
		r_data_in  <= $random();
		r_byte_in  <= $random()%4;
		r_valid_in <= 'd1;
		if(valid_in)
			r_last_in  <= $random()%2;
	end
	else if(last_in)begin
		r_last_in <= 'd0;
		r_valid_in <= 'd0;
	end
end

endmodule
