; We're going to use the semi-colon mark for comments just like ARM
; We're supporting 8 registers, R0-R6 and a flag register
; R0 is read only, and always set to 0
; All other registers are both read and write
; R1-R4 are our general data registers
; R5 and R6 are our pointer registers, our instructions that access memory will specifically
; reference these two pointers to know which address to access
; We also have a flag register for our comparsion instruction (SLT, we're just going to borrow from MIPS for this)
; All instructions besides B will simply make pc = pc + 1

; I think we have room to sneak in an branch instruction that branches if R6 == 0 if we combine AND and XOR
; I don't think it's necessary though, and I'm too lazy to go back and change the code we've written so far. 
; Quick example of the suggested change
; BNLT #i ;machine code: 110 iiii
; XOR Rx, Ry ; machine code: 101 1xxy
; AND Rx, Ry ; machine code: 101 0xxy

; This would probably be changed to BLT, for branch when less than and/or bacon, lettuce, and tomato
B #i	; machine code: 000 iiii	
; If R6==1, pc = pc + imm, supports imm range: [-8, 7]
; else pc = pc + 1
; We're going to use imm == 0 as our halt instruction

ADD Rx, Ry	;machine code: 001 xxyy
; Functionality: Rx = Rx + Ry
; Supports registers [1,4]

ADDI Rx, #i	; machine code: 010 xxii
; Supports registers [1, 4]
; Supports imm range: [-2, 1], although excluding 0
; if (#i == 0 ), then Rx = 0
; Rx = Rx + #i	

SUB Rx, Ry	; machine code: 011 xxyy
; Supports registers [1, 4]
; Rx = Rx - Ry

SLT Rx, Ry	; machine code: 100 xxyy
; Supports registers [0, 3]
; If Rx < Ry, then R6 = 1
; else aka Rx >= Ry, then R6 = 0
; Note: This is signed comparsion so we can just follow the template provided in class

XOR Rx, Ry	; machine code: 101 xxyy
; Supports registers [0,3]
; Does bit-wise XOR between Rx and Ry and stores the results in Rx
; Remember that R0 is read-only
; I think we can combine XOR and AND because we don't really need them to support more than two registers right? 

AND Rx, Ry	; machine code: 110 xxyy
; Does bit-wise AND between Rx and Ry and stores the results in Rx
; Supports registers [0,3]

STORE Rx, [Rp]	; machine code: 111 10xp
; Supports R2, R3
; if Rx == R2, then x = 0 
; else if Rx == R3, then x = 1
; if Rp == R5, then p = 0 
; else if Rp = R6, then p = 1
; Rx = value at memory address of the value in Rp

LOAD Rx, [Rp]	; machine code: 111 11xp
; Supports R2, R3
; if Rx == R2, then x = 0 
; else if Rx == R3, then x = 1
; if Rp = R5, then p = 0
; else if Rp = R6, then p = 1
; Rx = memory_data[ Rp ] 

AddPtr Rp, #n	; machine code: 111 00ip
; Supports R5, R6
; if Rp == R5, then p = 0 
; else if Rp == R6, then p = 1
; if n == -1, then i = 0
; else if n == 1, then i = 1
; Rp = Rp + n

; f will represent free variable
ResetPtr Rp, #f	; machine code: 111 01fp
; Supports R5, R6
; if Rp == R5, then p = 0 
; else if, Rp == R6, then p = 1
; Rp = 0
; Doesn't really matter what the last bit is actually, we could sneak in another instruction here if we wanted to. 
