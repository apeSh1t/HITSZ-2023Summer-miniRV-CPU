`timescale 1ns / 1ps

`include "defines.vh"

module ALU(
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [3:0]  op,
    output reg  [31:0] C,
    output reg  [1:0]  f
);


always @(*) begin
    if(($signed(A) == $signed(B)) && (op == `ALU_OP_BEQ))            begin f = `NPC_BR_JUMP; end
    else if(($signed(A) != $signed(B)) && (op == `ALU_OP_BNE))       begin f = `NPC_BR_JUMP; end
    else if(($signed(A) < $signed(B)) && (op == `ALU_OP_BLT))        begin f = `NPC_BR_JUMP; end
    else if(($signed(A) >= $signed(B)) && (op == `ALU_OP_BGE))       begin f = `NPC_BR_JUMP; end
    else if(op == `ALU_OP_JAL)                                       begin f = `NPC_BR_JUMP; end
    else if(op == `ALU_OP_JALR)                                      begin f = `NPC_BR_JUMP; end
    else                                                             begin f = `NPC_BR_KEEP; end

end

always @(*) begin
    case(op)
        `ALU_OP_DEFAULT: begin C = B; end
        `ALU_OP_ADD: begin C = A + B;     end
        `ALU_OP_SUB: begin C = A - B;     end
        `ALU_OP_AND: begin C = A & B;     end
        `ALU_OP_OR:  begin C = A | B;     end
        `ALU_OP_XOR: begin C = A ^ B;     end
        `ALU_OP_SLL: begin C = A << B[4:0];    end
        `ALU_OP_SRL: begin C = A >> B[4:0];    end
        `ALU_OP_SRA: begin C = $signed(A) >>> B[4:0];   end
        `ALU_OP_BEQ: begin C = 32'b0;     end
        `ALU_OP_BNE: begin C = 32'b0;     end
        `ALU_OP_BLT: begin C = 32'b0;     end
        `ALU_OP_BGE: begin C = 32'b0;     end
        `ALU_OP_JALR: begin C = A + B;    end
        default:     begin C = 32'B0;     end
    endcase
end

endmodule