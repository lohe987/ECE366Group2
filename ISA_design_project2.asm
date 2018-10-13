; We're going to use the semi-colon mark for comments just like ARM
; We're supporting 7 registers, R0-R6
; R0 is read only, and always set to 0
; All other registers are both read and write
; R1-R3 are our general data registers
; R4 and R5 are our pointer registers, our instructions that access memory will specifically
; reference these two pointers to know which address to access
; R6 will be the flag register of our comparsion instruction (SLT, we're just going to borrow from MIPS for this)

; F will represent free variable

; A potentially useful modification to our current ISA
; Re-introduce R4, so our ISA uses a total of 8 registers
; Change it so that ADD's supported range is [1,4]
; Allow ADDI to handle initializing/re-initializing registers back to 0 whenever the immediate
; value is equal to zero. 
 
B #i	; machine code: 000 iiii	
; If R6==1, pc = pc + imm, supports [-8, 7]
; else pc = pc + 1
; We're going to use imm == 0 as our halt instruction

; I think we have room to sneak in an branch instruction that branches if R6 == 0 if we combine AND and XOR
; I don't think it's necessary though, and I'm too lazy to go back and change the code we've written so far. 

ADD Rx, Ry	;machine code: 001 xxyy
; If Ry == R0, then Rx = R0
; else Rx = Rx + Ry
; Is this add unsigned? I think it should be upon first thought, but we should give it more consideration

ADDI Rx, #i	; machine code: 010 xxii
; Rx = Rx + #i	
; Supports [-2, 1]
; Supporting 0 for this is kind of useless, but I think it'll make the hardware implementation easier

SUB Rx, Ry	; machine code: 011 xxyy
; Rx = Rx - Ry
; We should make this SUB instruction an unsigned subtraction, but I'm not sure how to implement that in hardware
; It should be unsigned subtraction so that our mod function can fully support the 16 bit-value that we can load from memory
; Our professor didn't specify whether or not the value was going to be unsigned, but let's assume it is since 
; this will make our program more flexible

SLT Rx, Ry	; machine code: 100 xxyy
; If Rx < Ry, then R6 = 1
; else aka Rx >= Ry, then R6 = 0

XOR Rx, Ry	; machine code: 101 xxyy
; Does bit-wise XOR between Rx and Ry and stores the results in Rx
; Remember that R0 is read-only
; I think we can combine XOR and AND because we don't really need them to support more than two registers right? 

AND Rx, Ry	; machine code: 110 xxyy
; Does bit-wise AND between Rx and Ry and stores the results in Rx

STORE Rx, [Rp]	; machine code: 111 10xp
; if x == 0, then Rx == R1
; else, Rx == R2
; if p == 0, then Rp == R4
; else, Rp == R5
; Rx = value at memory address of the value in Rp

LOAD Rx, [Rp]	; machine code: 111 11xp
; if x == 0, then Rx == R1
; else, Rx == R2
; if p == 0, then Rp == R4
; else, Rp == R5
; Rx = value at memory address of the value in Rp

AddPtr Rp, #i	; machine code: 111 00pi
; if p == 0, then Rp == R4
; else, Rp == R5
; if i == 0, then n = -1
; else, n = 1
; Rp = Rp + n

ResetPtr Rp, #f	; machine code: 111 01pf
; if p == 0, then Rp == R4
; else, Rp == R5
; Rp = 0
; Doesn't really matter what the last bit is actually, we could sneak in another instruction here if we wanted to. 
