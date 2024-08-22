module axi_stream_insert_header #(
	parameter DATA_WD = 32,
	parameter DATA_BYTE_WD = DATA_WD / 8,
	parameter BYTE_CNT_WD = $clog2(DATA_BYTE_WD)
) (
	input 						clk				,
	input 						rst_n			,

	// AXI Stream input original data
	input 						valid_in		,
	input [DATA_WD-1 : 0] 		data_in   		,
	input [DATA_BYTE_WD-1 : 0]  keep_in   		,
	input 						last_in   		,
	output 						ready_in  		,

	// AXI Stream output with header inserted
	output 						valid_out 		,
	output [DATA_WD-1 : 0] 		data_out  		,
	output [DATA_BYTE_WD-1 : 0] keep_out  		,
	output 						last_out  		,
	input 						ready_out 		,

	// The header to be inserted to AXI Stream input
	input 						valid_insert 	,
	input [DATA_WD-1 : 0] 		data_insert		,
	input [DATA_BYTE_WD-1 : 0] 	keep_insert		,
	input [BYTE_CNT_WD-1 : 0] 	byte_insert_cnt ,
	output 						ready_insert
);
  


/*****************寄存器**********************/
reg							r_valid_out		;
reg [DATA_WD-1 : 0] 		r_data_out		; 
reg [DATA_BYTE_WD-1 : 0]    r_keep_out 		;
reg                 		r_last_out 	 	;
reg							r_ready_insert  ;

/*****************网线型**********************/






/*****************组合逻辑********************/  
assign valid_out    = r_valid_out    ;	
assign data_out	    = r_data_out     ;	
assign keep_out 	= r_keep_out     ; 	
assign last_out 	= r_last_out     ;  	

//always@(*)
//begin
//	if(last_in)begin
//		r_ready_in <= 'd0;
//		r_ready_insert <= 'd1;
//	end
//end

assign ready_in = (valid_in) ? 'd1 : 'd0;
assign ready_insert = r_ready_insert;

/*****************时序逻辑********************/
always@(posedge clk or negedge rst_n)
if(~rst_n || last_in)
	r_ready_insert <= 'd1;
else if(valid_insert && ready_insert)
	r_ready_insert <= 'd0;

always@(posedge clk or negedge rst_n)
if(~rst_n)begin
	r_valid_out     <= 'd0; 
    r_data_out      <= 'd0;
    r_keep_out      <= 'd0;
end
else begin
	if(valid_insert && ready_out)begin	//insert header
		case(keep_insert)
			4'b0001: begin
				r_valid_out  	<= 'd1;
				r_data_out		<= {24'h0,data_insert[7:0]};
				r_keep_out 		<= 4'b1111;
			end
			4'b0011: begin
				r_valid_out  	<= 'd1;
				r_data_out		<= {16'h0,data_insert[15:0]};
				r_keep_out 		<= 4'b1111;
			end
			4'b0111: begin
				r_valid_out  	<= 'd1;
				r_data_out		<= {8'h0,data_insert[23:0]};
				r_keep_out 		<= 4'b1111;
			end
			4'b1111: begin
				r_valid_out  	<= 'd1;
				r_data_out		<= data_insert;
				r_keep_out 		<= 4'b1111;
			end
			default: begin
				r_valid_out  	<= 'd1;
				r_data_out		<= data_insert;
				r_keep_out 		<= 4'b1111;
			end
		endcase
	end
	else if(valid_in && ready_out)begin //output data_in
			r_valid_out  	<= 'd1;
			r_data_out		<= data_in;
			r_keep_out 		<= keep_in;
	end
	else begin
		r_valid_out 	<= 'd0;
	end
end

always@(posedge clk or negedge rst_n)
if(~rst_n)
	r_last_out <= 'd0;
else if(valid_in && ready_out && ~last_out)
	r_last_out <= last_in;
else 
	r_last_out <= 'd0;


endmodule
