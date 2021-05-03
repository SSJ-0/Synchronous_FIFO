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
reg[DT_WIDTH-1:0] loc[F_DEPTH:0];


wire f_empty,f_full;
wire[FADD_WIDTH-1:0]rd_pntr;
wire[FADD_WIDTH-1:0]wrt_pntr;


pntr rp(clk,rst,rd_en,rd_pntr,empty_b);
pntr wp(clk,rst,wrt_en,wrt_pntr,full_b);


always @(posedge clk) 
begin
	if(!rd_en) begin
		if((r_p_temp[4]!=wrt_pntr[4] && r_p_temp[3]==wrt_pntr[3] && r_p_temp[2]==wrt_pntr[2] && r_p_temp[1]==wrt_pntr[1] && r_p_temp[0]==wrt_pntr[0]) || (rd_pntr[4]!=wrt_pntr[4] && rd_pntr[3]==wrt_pntr[3] && rd_pntr[2]==wrt_pntr[2] && rd_pntr[1]==wrt_pntr[1] && rd_pntr[0]==wrt_pntr[0]))
			full_bar=0;
	end
	else
		full_bar=1;
	if(wrt_en) begin
		if(!full_bar)
			$display("FIFO is full");
		else begin
			case({wrt_pntr[3],wrt_pntr[2],wrt_pntr[1],wrt_pntr[0]})
				4'b0000: loc[0]<=wrt_dt;
				4'b0001: loc[1]<=wrt_dt;
				4'b0010: loc[2]<=wrt_dt;
				4'b0011: loc[3]<=wrt_dt;
				4'b0100: loc[4]<=wrt_dt;
				4'b0101: loc[5]<=wrt_dt;
				4'b0110: loc[6]<=wrt_dt;
				4'b0111: loc[7]<=wrt_dt;
				4'b1000: loc[8]<=wrt_dt;
				4'b1001: loc[9]<=wrt_dt;
				4'b1010: loc[10]<=wrt_dt;
				4'b1011: loc[11]<=wrt_dt;
				4'b1100: loc[12]<=wrt_dt;
				4'b1101: loc[13]<=wrt_dt;
				4'b1110: loc[14]<=wrt_dt;
				4'b1111: loc[15]<=wrt_dt;
			endcase
		end
	end
end

always @(posedge clk)
begin
if(rd_en) begin
if(rd_pntr==wrt_pntr)
$display("FIFO is empty");
else begin
case({rd_pntr[3],rd_pntr[2],rd_pntr[1],rd_pntr[0]})
4'b0000: begin rd_dt<=loc[0];
         loc[0]<=8'h00;  end
4'b0001: begin rd_dt<=loc[1];
         loc[1]<=8'h00;  end       
4'b0010: begin rd_dt<=loc[2];
         loc[2]<=8'h00;  end
4'b0011: begin rd_dt<=loc[3];
         loc[3]<=8'h00;  end
4'b0100: begin rd_dt<=loc[4];
         loc[4]<=8'h00;  end
4'b0101: begin rd_dt<=loc[5];
         loc[5]<=8'h00;  end
4'b0110: begin rd_dt<=loc[6];
         loc[6]<=8'h00;  end
4'b0111: begin rd_dt<=loc[7];
         loc[7]<=8'h00;  end
4'b1000: begin rd_dt<=loc[8];
         loc[8]<=8'h00;  end
4'b1001: begin rd_dt<=loc[9];
         loc[9]<=8'h00;  end
4'b1010: begin rd_dt<=loc[10];
         loc[10]<=8'h00;  end
4'b1011: begin rd_dt<=loc[11];
         loc[11]<=8'h00;  end
4'b1100: begin rd_dt<=loc[12];
         loc[12]<=8'h00;  end
4'b1101: begin rd_dt<=loc[13];
         loc[13]<=8'h00;  end
4'b1110: begin rd_dt<=loc[14];
         loc[14]<=8'h00;  end
4'b1111: begin rd_dt<=loc[15];
         loc[15]<=8'h00;  end
endcase
end
end
if(!wrt_en) begin
if(rd_pntr==w_p_temp || rd_pntr==wrt_pntr)
empty_bar=0;
end
else
empty_bar=1;
end
`ifdef TST_ACTIVE
	assign rd_pntr= ( rd_en? ( f_empty? 16'hx : loc[rd_ptr] 

assign f_full=  ( rd_pntr[4]!=wrt_pntr[4] ) & ( rd_pntr[3:0]==wrt_pntr[3:0] );
assign f_empty= ( rd_pntr==wrt_pntr );

endmodule
/*
module syncfifo_testbench();
`timescale 1ns/1ps

wire clk,rst,rd_en,wrt_en;
reg ck,res,r_en,w_en;
reg[7:0] wrt_dt;
wire[7:0] rd_dt;

syncfifo duty(clk,rst,rd_en,wrt_en,wrt_dt,rd_dt);
initial begin
ck=1;
forever #5 ck=~ck;
end

initial begin
wrt_dt=8'hff;
forever begin
#10 wrt_dt<=wrt_dt+8'h08;
end
end

initial begin
r_en=0;
#40 r_en<=1;
forever begin
#80 r_en<=~r_en;
#20 r_en<=~r_en;
end
end

initial begin
w_en=0;
#20 w_en<=1;
forever begin
#1000 w_en<=~w_en;
#1000 w_en<=~w_en;
end
end

initial begin
res=1;
#20;
res<=0;
end

assign clk=ck;
assign rst=res;
assign rd_en=r_en;
assign wrt_en=w_en;

endmodule

