# ECE 366 Project 2 Disassembler
# Jenshen
# Imran Babar
# Singee
# This file disassembles two project files

p1_input_file = open("Program1_Bin.txt", "r")
p1_output_file = open("Program1_Asm.txt", "w")

p2_input_file = open("Program2_Bin.txt", "r")
p2_output_file = open("Program2_Asm.txt", "w")


def convert_bin_to_asm(input_file, output_file):
    for line in input_file:

        if line == "\n":  # empty lines ignored
            continue
        line = line.replace("\n", "")  # remove 'endline' character
        print("Machine Instr: ", line)  # show the asm instruction to screen

        if line[0:3] == '001':  # add instruction
            op = line[0:3]
            rx = line[3:5]
            ry = line[5:7]
            parity = line[7:8]

            c = int(rx, 2)
            d = int(ry, 2)
            a = "ADD"
            output_file.write(str(a) + " " + '$' + str(c) + "," + " " + '$' + str(d) + "\n")

        if line[0:3] == '011':  # sub instruction
                op = line[0:3]
                rx = line[3:5]
                ry = line[5:7]
                parity = line[7:8]

            if line[3:5] == '00':
                c = "0"
            elif line[3:5] == '01':
                c = "1"
            elif line[3:5] == '10':
                c = "2"
            else:
                c = "3"

            if line[5:7] == '00':
                d = "0"
            elif line[5:7] == '01':
                d = "1"
            elif line[5:7] == '10':
                d = "2"
            else:
                d = "3"
            a = "SUB"
            output_file.write(str(a) + " " + '$' + str(c) + "," + " " + '$' + str(d) + "\n")


        if line[0:4] == '100':  # SLT instruction
            op = line[0:3]
            rx = line[3:5]
            ry = line[5:7]
            parity = line[7:8]
            if line[3:5] == '00':
                c = "0"
            elif line[3:5] == '01':
                c = "1"
            elif line[3:5] == '10':
                c = "2"
            else:
                c = "3"

            if line[5:7] == '00':
                d = "0"
            elif line[5:7] == '01':
                d = "1"
            elif line[5:7] == '10':
                d = "2"
            else:
                d = "3"
            a = "SLT"
            output_file.write(str(a) + " " + '$' + str(c) + "," + " " + '$' + str(d) + "\n")

        if line[0:3] == '000':  # Branch instruction
            op = line[0:3]
            imm = line[3:7]
            parity = line[7:8]
            a = "Branch"
            d = int(imm, 2)
            output_file.write(
                str(a) + " " + str(d) + "\n")

        if line[0:5] == '010':  # ADDI instruction
            op = line[0:3]
            rx = line[3:5]
            imm = line[5:7]
            parity = line[7:8]

            if line[3:5] == '00':
                c = "0"
            elif line[3:5] == '01':
                c = "1"
            elif line[3:5] == '10':
                c = "2"
            else:
                c = "3"
            if line[5:7] == '00':
                c = "-1"
            elif line[5:7] == '01':
                c = "0"
            elif line[5:7] == '10':
                c = "1"
            else:
                c = "2"

            a = "ADDI"
            output_file.write(
                str(a) + " " + "$" + str(c) + "\n")

        if line[0:5] == '11110':  # STORE instruction
            op = line[0:5]
            RX = line[5:6]
            RY = line[6:7]
            parity = line[7:8]
            if line[5:6] == '0':
                d = '3'
            else:
                d = '2'
            if line[6:7] == '0':
                c = "5"
            else:
                c = "5"
            a = "STORE"
            output_file.write(str(a) + " " + "$" + str(d) + "," + " " + str(c) + "\n")
        if line[0:5] == '11111':  # STORE instruction
            op = line[0:5]
            RX = line[5:6]
            RY = line[6:7]
            parity = line[7:8]
            if line[5:6] == '0':
                d = '2'
            else:
                d = '3'
            if line[6:7] == '0':
                c = "5"
            else:
                c = "5"
            a = "LOAD"
            output_file.write(str(a) + " " + "$" + str(d) + "," + " " + str(c) + "\n")


        if line[0:7] == '101':  # XOR instruction
            op = line[0:3]
            RX = line[3:5]
            RY = line[5:7]
            parity = line[7:8]
            if line[3:5] == '00':
                c = "0"
            elif line[3:5] == '01':
                c = "1"
            elif line[3:5] == '10':
                c = "2"
            else:
                c = "3"

            if line[5:7] == '00':
                d = "0"
            elif line[5:7] == '01':
                d = "1"
            elif line[5:7] == '10':
                d = "2"
            else:
                d = "3"
            a = "XOR"
            output_file.write(str(a) + " " + '$' + str(c) + "," + " " + '$' + str(d) + "\n")


        if line[0:7] == '110':  # AND instruction
            op = line[0:3]
            RX = line[3:5]
            RY = line[5:7]
            parity = line[7:8]
            if line[3:5] == '00':
                c = "0"
            elif line[3:5] == '01':
                c = "1"
            elif line[3:5] == '10':
                c = "2"
            else:
                c = "3"

            if line[5:7] == '00':
                d = "0"
            elif line[5:7] == '01':
                d = "1"
            elif line[5:7] == '10':
                d = "2"
            else:
                d = "3"
            a = "AND"
            output_file.write(str(a) + " " + '$' + str(c) + "," + " " + '$' + str(d) + "\n")

convert_bin_to_asm(p1_input_file, p1_output_file)
convert_bin_to_asm(p2_input_file, p2_output_file)
