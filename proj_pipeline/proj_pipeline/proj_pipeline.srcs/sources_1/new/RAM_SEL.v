module RAM_SEL (
    input wire rst,
    input wire [1:0] forward_ram,
    input wire [31:0] mem_c,
    input wire [31:0] ex_rD2,
    input wire [31:0] wb_c,
    output reg [31:0] wdin
);
    
always @(*) begin
    if (rst) begin wdin = 32'b0; end
    else begin
        if(forward_ram == 2'b01)         begin wdin = mem_c; end
        else if (forward_ram == 2'b10)   begin wdin = wb_c;  end
        else                             begin wdin = ex_rD2; end
    end
end


endmodule