# INTRUCTIONS:
# R-TYPE
# sll, srl, sra, sllv, srlv, srav, addu, subu, and, or, xor, nor, slt
# I-TYPE
# lb, lh, lw, lwu, lbu, lhu, sb, sh, sw, addi, andi, ori, xori, lui, slti, bew, bne, j, jal
# J-TYPE
# jr, jalr

# sllv, srlv, srav, addu, subu,
# lwu, lbu, lhu, sb, sh, ori, xori, lui, slti, bew,bne， jal, jalr


from numpy import *


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
    shamt = ['sll', 'srl', 'sra'] # Instructions that use shamt field 
    shift_value = ['sllv', 'srlv', 'srav'] # Instructions of type $rd = $rt <<>> $rs

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
    # print("bin opcode: ", bin(opcode))
    # print("bin opcode[2:0]=", bin(opcode)[2:])
    # print("bin(opcode)[2:].zfill(6)= ", bin(opcode)[2:].zfill(6))
    result.append(bin(opcode)[2:].zfill(6))  # OPCODE

    if instruction[0] == 'sw' or instruction[0] == 'lw':
        baseAndImm = instruction[2].split('(')
        rs = getRegister(baseAndImm[1][:-1])
        result.append(bin(rs)[2:].zfill(5))  # rs

        rt = getRegister(instruction[1])
        result.append(bin(rt)[2:].zfill(5))  # rt

        imm = bin(int(baseAndImm[0]))[2:]       # imm
        result.append(imm.zfill(16))             # imm

    else:
        rs = getRegister(instruction[2])
        result.append(bin(rs)[2:].zfill(5))  # rs

        rt = getRegister(instruction[1])         # rt
        result.append(bin(rt)[2:].zfill(5))      # rt

        if instruction[0] == 'beq':
            # TODO: Ver es
            new_pc = int((int(instruction[3]) - 4) / 4) # VER
            print("NEW_PC: ", new_pc)
            ba = bin(new_pc)[2:]                     # br_addr
            result.append(ba.zfill(16))              # br_addr

        elif instruction[0] == 'andi' or instruction[0] == 'addi':
            sig = 0
            ind = bin(int(instruction[3])).find('0b')
            if ind != 0:
                sig = 1
            imm = bin(int(instruction[3]))[ind + 2:]       # imm
            result.append(str(sig) + imm.zfill(15))             # imm

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
    
    'add': (0, 0x20), 'addu':(0, 0x21), 'sub': (0, 0x22),'subu': (0,0x23),
    'and': (0, 0x24), 'or': (0, 0x25),'nor': (0, 0x27),
    
    'sll': (0, 0x00), 'srl': (0, 0x02), 'sra':(0,0x3),'sllv':(0, 0x4), 'srlv':(0,0x6), 'srav':(0, 0x7),
    'slt': (0, 0x2a), 
     
    'lb': (0x20, 0),'lw': (0x23, 0), 'lbu': (0x25, 0), 'lhu': (0x21, 0),
    'sb':(0x28,0), 'sh':(0x29,0), 'sw': (0x2b, 0),
     
    'addi': (0x8, 0), 'andi': (0xc,0), 'ori':(0xd, 0), 'xori':(0xe, 0), 
    'lui':(0, 0xf), 'slti':(0xa,0), 'beq': (0x4, 0), 'bne':(0x5,0), 
     
    'j': (0x2, 0),'jalr':(0, 0x9), 'jr':(0, 0x8), 'jal':(0x3,0), 
}


instructionHandler = {
    'add': rType, 'addu': rType, 'sub': rType, 'subu':rType,
    'and': rType, 'or': rType, 'nor': rType,

    'sll': rType, 'sllv': rType, 'srlv':rType, 'srav':rType, 
    'slt': rType, 'srl': rType,'sra':rType, 

    'lb': iType, 'lw': iType, 'lbu': iType, 'lhu':iType,
    'sb': iType, 'sh': iType, 'sw': iType,
    
    'addi': iType, 'andi': iType, 'ori': iType, 'xori': iType, 
    'lui': iType, 'slti': iType, 'beq': iType, 'bne': iType,
     
    'j': jType, 'jal': jType, 'jalr': iType, 'jr': iType,
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
    if separated[0] == 'subi':
        old = separated[:]
        separated[0] = 'addi'
        separated[3] = str(-1 * int(separated[3]))
        print('taking ', old, 'as ---->', separated)
    print("SEPARETED: ", separated)
    converted = instructionHandler[separated[0]](separated)

    return converted


def main():
    inp_file = open('input_shift.txt', 'r')
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
