module pntr(clk,rst,enable,count,select);
`timescale 1ns/1ps

input clk,rst,enable,select;
output[4:0] count;

reg[4:0] count;

always @(posedge clk or posedge rst)
begin
if(rst)
    count<=5'b00000;
else if(enable && select)
    count<=count+5'b00001;
end

endmodule

module syncfifo
(
	input 	clk,rst,
	input 	rd_en,wrt_en,
	input	[DT_WIDTH-1:0] wrt_dt,
	output	[DT_WIDTH-1:0]rd_dt
);


parameter DT_WIDTH=8;
parameter F_DEPTH=16;
parameter FADD_WIDTH=$clog2(F_DEPTH);


reg[DT_WIDTH-1:0] rd_dt;
	reg[DT_WIDTH-1:0] f_mem[F_DEPTH:0];


wire f_empty,f_full;
wire[FADD_WIDTH-1:0]rd_pntr;
wire[FADD_WIDTH-1:0]wrt_pntr;


pntr rp(clk,rst,rd_en,rd_pntr,empty_b);
pntr wp(clk,rst,wrt_en,wrt_pntr,full_b);


always_ff @(posedge clk) begin
	if(wrt_en & !f_full) begin
				
		f_mem[wrt_pntr]<=wrt_dt;
				
	end
end

always_comb begin

	`ifdef TST_ACTIVE
	rd_dt= ( ( rd_en & !f_empty ) ? loc[rd_ptr] : 16'hx );
	`else
	rd_dt= 
	
end
	
assign f_full=  ( rd_pntr[4]!=wrt_pntr[4] ) & ( rd_pntr[3:0]==wrt_pntr[3:0] );
assign f_empty= ( rd_pntr==wrt_pntr );

endmodule
