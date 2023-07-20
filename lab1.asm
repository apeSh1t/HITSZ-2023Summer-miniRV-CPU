addi s2, zero, 0                       #3'b000
addi s3, zero, 1                       #3'b001
addi s4, zero, 2                       #3'b010
addi s5, zero, 3                       #3'b011
addi s6, zero, 4                       #3'b100
addi s7, zero, 5                       #3'b101
addi s8, zero, 6                       #3'b110

MAIN:
	lui  s1, 0xFFFFF
	lw   s0, 0x70(s1)		# read switch(input)
	andi a2, s0, 0x000000FF             # a2 <= B           
	srli a1, s0, 8                       
	andi a1, a1, 0x000000FF             # a1 <= A   
	srli a3, s0, 21                     
	andi a3, a3, 0x00000007             # a3 <= opcode
	
	andi a4, a1, 0x80                 
	srli a4, a4, 7                       #A +or-
	
	andi a5, a2, 0x80                 
	srli a5, a5, 7                       #B +or-
	
	beq a3, s2, AND
	beq a3, s3, OR
	beq a3, s4, XOR
	beq a3, s5, SLL
	beq a3, s6, SRA
	beq a3, s7, JUDGE
	beq a3, s8, DIV                     # 7 kinds operation
	beq zero, zero, ZERO                # else 


AND:
	and s11, a1, a2
        jal SHOW         
OR:
	or  s11, a1, a2
        jal SHOW                             
XOR:
	xor s11, a1, a2
	jal SHOW   
SLL:
	sll s11, a1, a2
	jal SHOW   
SRA:
	beqz a4, MOVE                        # if a_symbol == positive
	andi a1, a1, 0x0000007F              #else make symbol=0 
	MOVE:	
		sra s11, a1, a2
		beqz a4, SHOW
		ori s11, s11, 0x00000080     # add symbol again
		jal SHOW  
JUDGE:
	bnez a1, COMPLEMENTB                 #B=B_implement
	RETURN_JUD:
		add  s11, zero, a2
		jal SHOW   


DIV:
	xor  a4, a4, a5                       #the symbol of A/B
	andi a1, a1, 0x7F
	andi a2, a2, 0x7F                     #A*   B*
	addi a7, zero, 0                      #a7存商
	addi a6, zero, 1                      #a6存商的位数，即运算次数
	
	PRE_OP:
		blt  a1, a2, START
		addi a6, a6, 1
		slli a2, a2, 1
		jal PRE_OP
	START: 	
		addi a6, a6, -1
		srli a2, a2, 1
	
	LOOP_DIV:
		beqz a6, END_LOOP
		addi a6, a6, -1
		blt a1, a2, ADD_OP               # a1 < a2, 
		bge a1, a2, SUB_OP               # a1 >= a2, 
		
		
	ADD_OP:
		slli a7, a7, 1
		srli a2, a2, 1               #除数右移
		jal LOOP_DIV
		
	SUB_OP:
		slli a7, a7, 1
		addi a7, a7, 1
		sub  a1, a1, a2
		srli a2, a2, 1               #除数右移
		jal LOOP_DIV
		
	
	END_LOOP:
		slli a4, a4, 7
		add  s11, a4, a7            #add symbol
		jal SHOW  

ZERO:
	add s11, zero, zero
	jal SHOW

SHOW:       
	andi s11, s11, 0x000000FF      # keep low 8 bit     						
	sw   s11, 0x60(s1)		# write led(same as switch)
    	sw   s11, 0x00(s1)             # write numbers
	jal  MAIN    
	
COMPLEMENTB:
	beqz a5, POSITIVE_NUM
	xori a2, a2, 0x0000007F        # B is negative_num
	addi a2, a2, 1
	jal  RETURN_JUD
	POSITIVE_NUM:
		add a2, a2, zero      # B if positive_num
		jal RETURN_JUD
