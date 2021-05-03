module pntr
  #(
    
    
  (clk,rst,enable,count,select);


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
