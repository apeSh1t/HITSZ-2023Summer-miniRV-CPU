module BUTTON(
    input wire rst,
    input wire clk,
    input wire[11:0] addr,
    input wire[4:0] button,
    output reg[31:0] rdata 
);

always@(posedge rst or posedge clk)begin
    if(rst)begin
        rdata<=32'b0;
    end
    else begin
        rdata<={27'b0,button};
    end
end

endmodule