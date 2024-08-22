module tb();

parameter DATA_WD = 32;
parameter DATA_BYTE_WD = DATA_WD / 8;
parameter BYTE_CNT_WD = $clog2(DATA_BYTE_WD);

reg clk,rst_n;

wire valid_in,last_in;
wire [DATA_WD-1 : 0] data_in;
wire [DATA_BYTE_WD-1 : 0] keep_in;
wire 	ready_in;

wire ready_out;
wire [DATA_WD-1 : 0] data_out;
wire [DATA_BYTE_WD-1 : 0] keep_out;
wire last_out,valid_out;

wire valid_insert;
wire [DATA_WD-1 : 0] data_insert;
wire [DATA_BYTE_WD-1 : 0] keep_insert;
wire [BYTE_CNT_WD-1 : 0] byte_insert_cnt;
wire ready_insert;

always#5 clk = ~clk;

initial begin
	//reset
	rst_n = 0; clk = 0;
	#201; rst_n = 1;

	repeat(5000)@(posedge clk);#1;
	$finish();
end



axi_stream_insert_header #(
	.DATA_WD(DATA_WD),
	.DATA_BYTE_WD(DATA_BYTE_WD),
	.BYTE_CNT_WD(BYTE_CNT_WD)
)
u0(
	.clk	        (clk	        ),
    .rst_n          (rst_n          ),
                                   
	.valid_in       (valid_in       ),
    .data_in        (data_in        ),
    .keep_in        (keep_in        ),
    .last_in        (last_in        ),
    .ready_in       (ready_in       ),
                                   
	.valid_out      (valid_out      ),
    .data_out       (data_out       ),
    .keep_out       (keep_out       ),
    .last_out       (last_out       ),
	.ready_out      (ready_out      ),
                                   
	.valid_insert   (valid_insert   ),
    .data_insert	(data_insert	), 
    .keep_insert	(keep_insert	), 
    .byte_insert_cnt(byte_insert_cnt),
	.ready_insert   (ready_insert   )
); 

axi_data_generator #(
	.DATA_WD(DATA_WD),
	.DATA_BYTE_WD(DATA_BYTE_WD),
	.BYTE_CNT_WD(BYTE_CNT_WD)
)
u1(
	.clk	        (clk	        ),
    .rst_n          (rst_n          ),
                                   
	.valid_in       (valid_in       ),
    .data_in        (data_in        ),
    .keep_in        (keep_in        ),
    .last_in        (last_in        ),
    .ready_in       (ready_in       ),
                                   
	.valid_out      (valid_out      ),
    .data_out       (data_out       ),
    .keep_out       (keep_out       ),
    .last_out       (last_out       ),
	.ready_out      (ready_out      ),
                                   
	.valid_insert   (valid_insert   ),
    .data_insert	(data_insert	), 
    .keep_insert	(keep_insert	), 
    .byte_insert_cnt(byte_insert_cnt),
	.ready_insert   (ready_insert   )
);

endmodule
