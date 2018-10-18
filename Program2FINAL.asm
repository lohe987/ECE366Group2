; Program 2 is the best-match one

; T is at Mem[3]

; Array goes from Mem[8-107]

; Store best match score at Mem[4]

; Store count of best match score at Mem[5]

; Mem [0-2], Mem[6], Mem[7] are available to us for manipulation. 




;******************************INITIALIZATIONS***********************************


Addi	R2, #1

Addi	R1, #1

Addi	R2, 1


Add 	$2, $2		;R2 = 2
Add 	$2, $2		
Add 	$2, $2		;R2 = 8
Add 	$2, $2		
Add	$3, $2		;R3 = (R2 = 16)**
Add	$3, $3		;R3 = 32
Add	$3, $2		;R3 = 48
Addi	$3, 1
Addi	$3, 1		;R3 = 50
Add	$3, $3		;(R3 = 100)**

ResetPtr $5
Store 	$2, [$5
]	;MEM[0] = 16, used to calculate BMS and to reset loopCtr
AddPtr	$5, 1

Store 	$3, [$5]	;MEM[1] = 100 = arrayCtr


AddPtr	$6, 1
AddPtr	$6, 1
AddPtr 	$6, 1
AddPtr 	$6, 1
AddPtr 	$6, 1
AddPtr 	$6, 1
AddPtr 	$6, 1
AddPtr 	$6, 1		;R6 = 8, and MEM[8] = Pattern_Array[1] initialization
;****************************************************************************
	SLT	$0, $2		;skip the BMS update and BMS check function on first iteration
	B	7		
;---------------------updateBMS Function---------------------------
ResetPtr $5
AddPtr	$5, 1
AddPtr	$5, 1
AddPtr	$5, 1
AddPtr	$5, 1
	SLT	$0, $0	;set up branch link 
	B	7	;link to nextBit
	B	-7	;link to updateBMS
AddPtr	$5, 1 	;R5 = 5, MEM[5] = BMC
Addi	$2, 0	;reset R2 to 0
Addi	$2, 1	;R2 = 1
Store	$2, [$5];when BMS is updated, BMC must be reset to 1
	
;--------------------------------------------------------------------
	SLT	$0, $0	;set up branch link 
	B	6	;skip to nextBit
	B	-7	;link to updateBMS
;********************checkBMS Function*********************************
ResetPtr $5
Load	$2, [$5]	;R2 = 16
AddPtr	$5, 1	

SLT	$0, $0	;set up branch link 
	B	7	;skip to nextBit
	B	-6	;link to updateBMS
	B	-6	;link to checkBMS
AddPtr	$5, 1		;R5 = 2
Load	$3, [$5]	;R3 = MEM[2] = mismatchCtr
Sub	$2, $3		;R2 = 16 - mismatchCtr = Current Match Score, CMS
	SLT	$0, $0	;set up branch link 
	B	3	;skip to nextBit
	B	-7	;link to updateBMS	
	B	-7	;link to checkBMS
	B	7	;skip to nextBit 
AddPtr 	$5, 1
AddPtr 	$5, 1		;R5 = 4
Load 	$3, [$5]	;R3 = MEM[4] = Best Matching Score, BMS
SLT	$3, $2		;when BMS < CMS, R7 = 1
B 	-7		;link to update BMS
	B	-7	;link to checkBMS
	B	5	;initial skip to nextBit

;*********************************************************************

;-----------------------BMC++ Function--------------------------------
Sub	$2, $3		;R2 = CMS - BMS
SLT	$2, $0		;if result is negative, branch forward
B	7		;if result is zero, increment BMC (R2 cannot be positive because we established that BMS > CMS in the SLT above)
	B	-5		;link to checkBMS
	B	7		;skip to nextBit
AddPtr	$5, 1		;R5 = 5
Load 	$2, [$5]	;R2 = Best Match Counter
Addi	$2, 1		;BMC++
Store	$2, [$5]

;----------------------------------------------------------------------
	
	SLT	$0, $0	;set up branch link 
	B	-7	;link to checkBMS

;**********************nextBit Function********************************
ResetPtr $5		;R5 = 0
Load	$3, [$5
]	;R3 = 16
Add	$4, $3		;R4 = 16 = loopCtr
AddPtr	$5, 1
	SLT	$0, $0	;set up branch link 
	B	-6	;link to checkBMS
	B	-6	;link to nextBit
Load	$3, [$5
]
Addi	$3, -1		;MEM[1]-- = arrayCtr--	
Store	$3, [$5
]
AddPtr	$5, 1		
Addi	$2, 0		;reset R2 to 0
	SLT	$0, $0	;set up branch link 
	B	-8	;link to checkBMS
	B	-8	;link to nextBit
Store	$2, [$5
]	;reset mismatchCtr : MEM[2] = R2 = 0
Addi 	$1, 1		;(re)initialize the bitChecker

Addi	$4, -1		;loopCtr--
SLT	$4, $0		;set branch flag when all bits have been checked
B	-6		;link to checkBMS		
Load 	$2, [$5
]	;R2 = Target Pattern
	SLT	$0, $0	;set up branch link 
	B	-8	;
Load 	$3, [$6]	;R3 = Pattern_Array[i], where i = ($6-8)
XOR 	$3, $2		;compare P_A with T
AND 	$3, $1		;AND with bitChecker yields result in R3
SLT 	$0, $3		;R7 = 1 if there is a mismatch
B 	4 *****	
Addi 	$1, $1		;bitChecker LSL 1
SLT 	$0, $2		;force branch condition R7 = 1
B	-8	
Add	$1, $1		;bitChecker LSL 1
AddPtr	$5, -1	
Load	$3, [$5]		
Addi	$3, 1		;MEM[2]++ (mismatch Counter)
Store	$3, [$5]
AddPtr	$5, 1
SLT	$0, $2		;force branch condition
B	-8
;***********************************************************************