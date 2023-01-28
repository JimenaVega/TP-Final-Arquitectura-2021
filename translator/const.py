# INTRUCTIONS:
# R-TYPE
ADD = 'add'
ADDU = 'addu' 
SUB = 'sub'
SUBU = 'subu'
AND = 'and'
OR = 'or'
NOR = 'nor'
XOR = 'xor'
SLL = 'sll'
SRL = 'srl'
SRA = 'sra'
SLLV = 'sllv'
SRLV = 'srlv'
SRAV = 'srav'
SLT = 'slt'
JR = 'jr'
JALR = 'jalr'
# I-TYPE
SLL = 'sll'
SRL = 'srl'
SRA = 'sra'
SLLV = 'sllv'
SRLV = 'srlv'
SRAV = 'srav'
LB = 'lb'
LH = 'lh'
LHU = 'lhu'
LW = 'lw' # rt=*(int*)(offset+rs)
LWU = 'lwu' 
LBU = 'lbu' 
SB = 'sb'
SH = 'sh'
SW = 'sw'
ADDI = 'addi' # rt=rs+imm
ANDI = 'andi' # rt=rs&imm
ORI = 'ori'
XORI = 'xori'
LUI = 'lui' # rt=imm<<16
SLTI = 'slti' # rt=rs<imm
BEQ = 'beq' # if(rs==rt) pc+=offset*4
BNE = 'bne'
#TYPE-J
J = 'j'
JAL = 'jal'
