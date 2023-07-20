module DIGITAL_LED(
    input wire rst,
    input wire clk,
    input wire wen,
    input wire[11:0] addr,
    input wire[31:0] wdata,
    output reg[7:0] en,
    output reg DN_A,
    output reg DN_B,
    output reg DN_C,
    output reg DN_D,
    output reg DN_E,
    output reg DN_F,
    output reg DN_G,
    output reg DN_DP
);

reg [3:0]  DN_data;
reg        DN_enable;
reg [7:0]  DN;
reg [31:0] data;

reg [25:0] cnt;
reg cnt_inc;

wire cnt_end = cnt_inc & (cnt==26'd199_99);


always @(posedge clk or posedge rst) begin
    if(rst) begin cnt_inc<=1; end
end

//counter
always @(posedge clk or posedge rst) begin
    if(rst)          begin cnt<=0;     end
    else if(cnt_end) begin cnt<=0;     end
    else if(cnt_inc) begin cnt<=cnt+1; end
    else             begin cnt<=cnt;   end 
end


always@(posedge rst or posedge clk)begin
    if(rst)            begin data<=32'b0; end
    else if(wen==1'b1) begin data<=wdata; end
end

always @(posedge clk or posedge rst) begin
    if(rst)          begin en<=8'b11111110;     end
    else if(cnt_end) begin en<={en[6:0],en[7]}; end
end

always @(posedge clk or posedge rst) begin
    if(rst) begin DN_data<=data[3:0]; end
    else if(cnt_end) begin
      if(en[0]==0)      DN_data<=data[7:4];
      else if(en[1]==0) DN_data<=data[11:8];
      else if(en[2]==0) DN_data<=data[15:12];
      else if(en[3]==0) DN_data<=data[19:16];
      else if(en[4]==0) DN_data<=data[23:20];
      else if(en[5]==0) DN_data<=data[27:24];
      else if(en[6]==0) DN_data<=data[31:28];
      else if(en[7]==0) DN_data<=data[3:0];
      else              DN_data<=data[3:0];
    end
end

always@(*)begin
        case(DN_data)
            4'b0000:begin DN=8'b00000011; end
            4'b0001:begin DN=8'b10011111; end
            4'b0010:begin DN=8'b00100101; end
            4'b0011:begin DN=8'b00001101; end
            4'b0100:begin DN=8'b10011001; end
            4'b0101:begin DN=8'b01001001; end
            4'b0110:begin DN=8'b01000001; end
            4'b0111:begin DN=8'b00011111; end
            4'b1000:begin DN=8'b00000001; end
            4'b1001:begin DN=8'b00011001; end
            4'b1010:begin DN=8'b00010001; end
            4'b1011:begin DN=8'b11000001; end
            4'b1100:begin DN=8'b11100101; end
            4'b1101:begin DN=8'b10000101; end
            4'b1110:begin DN=8'b01100001; end
            4'b1111:begin DN=8'b01110001; end
            default:begin DN=8'b0;        end
        endcase
end

always@(*)begin
    DN_A=DN[7];
    DN_B=DN[6];
    DN_C=DN[5];
    DN_D=DN[4];
    DN_E=DN[3];
    DN_F=DN[2];
    DN_G=DN[1];
    DN_DP=DN[0];
end

endmodule