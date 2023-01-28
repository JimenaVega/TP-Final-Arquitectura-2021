from numpy import *
from const import *

def jType(instruction):
    result = []
    opcode = insCodes[instruction[0]][0]  # OPCODE
    result.append(bin(opcode)[2:].zfill(6))  # OPCODE

    loc = int(int(instruction[1]) / 4)
    imm = bin(loc)[2:].zfill(26)   # imm
    result.append(imm)             # imm

    bin_val = ''.join(result)
    hex_val = hex(int('0b' + bin_val, 2))[2:].zfill(8)
    return (hex_val, bin_val)



def rType(instruction):
    result = []
    shift = 0
    shamt = [SLL, SRL, SRA] # Instructions that use shamt field 
    shift_value = [SLLV, SRLV, SRAV] # Instructions of type $rd = $rt <<>> $rs

    opcode = insCodes[instruction[0]][0]  # OPCODE
    result.append(bin(opcode)[2:].zfill(6))  # OPCODE

    if instruction[0] in shamt:
        shift = int(instruction[3]) # shamt
        result.append(bin(opcode)[2:].zfill(5))  # rs

        rt = getRegister(instruction[2])
        result.append(bin(rt)[2:].zfill(5))  # rt

    elif instruction[0] in shift_value:
        rs = getRegister(instruction[3])  # rs
        result.append(bin(rs)[2:].zfill(5))  # rs

        rt = getRegister(instruction[2])
        result.append(bin(rt)[2:].zfill(5))  # rt
    else:
        rs = getRegister(instruction[2])  # rs
        result.append(bin(rs)[2:].zfill(5))  # rs

        rt = getRegister(instruction[3])
        result.append(bin(rt)[2:].zfill(5))  # rt

    rd = getRegister(instruction[1])
    result.append(bin(rd)[2:].zfill(5))  # rd

    result.append(bin(shift)[2:].zfill(5))  # shift

    func = insCodes[instruction[0]][1]     # Func Code
    result.append(bin(func)[2:].zfill(6))  # Func Code

    bin_val = ''.join(result)
    hex_val = hex(int('0b' + bin_val, 2))[2:].zfill(8)
    return (hex_val, bin_val)


def iType(instruction):
    print("INSTRUCTION: ", instruction)
    result = []
    opcode = insCodes[instruction[0]][0]  # OPCODE
    print("OPCODE: ",opcode)
    result.append(bin(opcode)[2:].zfill(6))  # OPCODE
    load_store = [LB, LH, LHU, LW, LWU, LBU, SB, SH, SW]

    rt = getRegister(instruction[1])
    result.append(bin(rt)[2:].zfill(5))  # rt

    if instruction[0] in load_store:
        baseAndImm = instruction[2].split('(')

        rs = getRegister(baseAndImm[1][:-1])
        result.append(bin(rs)[2:].zfill(5))  # rs

        imm_b = bin(int(baseAndImm[0]) & 0xffffffff)[2:] 
        imm = imm_b.zfill(16) if int(baseAndImm[0]) >= 0 else imm_b[16:]
        result.append(imm)         # imm
        print("IMM= ", imm)
    elif instruction[0] == LUI:
        imm_b = bin(int(instruction[2]) & 0xffffffff)[2:] 
        imm = imm_b.zfill(16) if int(instruction[2]) >= 0 else imm_b[16:]
        result.append(imm)
        print("IMM= ", imm)
       
    else:
        rs = getRegister(instruction[2])
        result.append(bin(rs)[2:].zfill(5))  # rs
        imm_b = bin(int(instruction[3]) & 0xffffffff)[2:] 
        print('IMM_B: ', imm_b)
        imm = imm_b.zfill(16) if int(instruction[3]) >= 0 else imm_b[16:]
        result.append(imm)
        print("IMM= ", imm)


    bin_val = ''.join(result)
    hex_val = hex(int('0b' + bin_val, 2))[2:].zfill(8)
    return (hex_val, bin_val)


registers = {
    'zero': 0,   'at': 1,   'v0': 2,   'v1': 3,
    'a0': 4,   'a1': 5,   'a2': 6,   'a3': 7,
    't0': 8,   't1': 9,   't2': 10,  't3': 11,
    't4': 12,  't5': 13,  't6': 14,  't7': 15,
    's0': 16,  's1': 17,  's2': 18,  's3': 19,
    's4': 20,  's5': 21,  's6': 22,  's7': 23,
    't8': 24,  't9': 25,  'k0': 26,  'k1': 27,
    'gp': 28,  'sp': 29,  'fp': 30,  'ra': 31
}


# FINISH THE INSTRUCTION CODES, WILL HAVE ISSUES
insCodes = {
    
    ADD: (0, 0x20), ADDU:(0, 0x21), SUB: (0, 0x22),SUBU: (0,0x23),
    AND: (0, 0x24), OR: (0, 0x25), NOR: (0, 0x27), XOR: (0, 0x26), SLT: (0, 0x2a), 
    
    SLL: (0, 0x00), SRL: (0, 0x02), SRA:(0,0x3),SLLV:(0, 0x4), SRLV:(0,0x6), SRAV:(0, 0x7),
    
     
    LB: (0x20, 0),LH: (0x21, 0), LHU: (0x22,0),LW: (0x23, 0), LWU: (0x24,0), LBU: (0x25, 0), 
    SB:(0x28,0), SH:(0x29,0), SW: (0x2b, 0),
     
    ADDI: (0x8, 0), ANDI: (0xc,0), ORI:(0xd, 0), XORI:(0xe, 0), 
    LUI:(0xf, 0), SLTI:(0xa,0), BEQ: (0x4, 0), BNE:(0x5,0), 
     
    J: (0x2, 0),JALR:(0, 0x9), JR:(0, 0x8), JAL:(0x3,0), 
}


instructionHandler = {
    ADD: rType, ADDU: rType, SUB: rType, SUBU:rType,
    AND: rType, OR: rType, NOR: rType, XOR: rType,

    SLL: rType, SLLV: rType, SRLV:rType, SRAV:rType, 
    SLT: rType, SRL: rType,SRA:rType, 

    LB: iType,LBU: iType, LH:iType, LHU:iType, LW: iType, LWU:iType, 
    SB: iType, SH: iType, SW: iType,
    
    ADDI: iType, ANDI: iType, ORI: iType, XORI: iType, 
    LUI: iType, SLTI: iType, BEQ: iType, BNE: iType,
     
    J: jType, JAL: jType, JALR: rType, JR: rType,
}


def getRegister(value):
    print("VALUE: ", value)
    return registers[value[1:]]


def getSeparatedInstruction(line):
    line_split = line.split(" ")
    split_second = line_split.pop(1).split(",")
    line_split.extend(split_second)
    print("LINE SPLIT : ", line_split)
    return line_split


def convertToHex(line):
    separated = getSeparatedInstruction(line)
    # if separated[0] == 'subi':
    #     old = separated[:]
    #     separated[0] = ADDI
    #     separated[3] = str(-1 * int(separated[3]))
    #     print('taking ', old, 'as ---->', separated)
    print("SEPARETED: ", separated)
    converted = instructionHandler[separated[0]](separated)

    return converted


def main():
    inp_file = open('input_i.txt', 'r')
    out_file = open('output.mem', 'w')
    line = inp_file.readline()
    choice = int(input("Choose conversion to binary [1] or hexa [0]: "))
    print('Converting file assembler to .mem binary...')
    while line:
        bin_hex = convertToHex(line[:-2])
        out_file.write(str(bin_hex[choice]) + '\n')
        line = inp_file.readline()

    print ('Conversion ready.')
    print ('Saved in output.mem')
    inp_file.close()
    out_file.close()


if __name__ == "__main__":
    main()
