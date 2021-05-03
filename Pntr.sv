module fifo_pntr
    #(
        parameter FADD_WIDTH=4
    )
    (
        input clk,rst,enable,select,
        output[4:0] pntr
    );
   
    reg[4:0] pntr;

 
    always_ff @(posedge clk or negedge rst) begin
    
        if(!rst)
            pntr<=5'b00000;
        else if(enable && select)
            pntr<=pntr+5'b00001;
        
    end

endmodule
