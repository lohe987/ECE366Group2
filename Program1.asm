; Program 1 is suppose to calculate (6^P) % Q where P and Q are 16 bit unsigned integers stored 
; at memory address 0 and 1

AddPtr R6, #1
AddPtr R6, #1  ;This makes R6 into 2 which will be where we store a counter value, although we will eventually write the results
			;at this memory address
Addi R3, #1
Add R3, R3  ; R3 == 2
Add R3, R3  ; R3 == 4
Add R3, R3  ; R3 == 8
Add R3, R3  ; R3 == 16
Addi R3, #-1  ;R3 == 15
Store R3, [R6] 
AddPtr R6, #-1

Addi R2, #1  
Addi R2, #1  
Addi R2, #1  ; R2 == 3
Add R2, R2  ; R2 == 6

;Addi R1, 1
;Addi R1, 1
;Addi R1, 1
;Add R1, R1  ;R1 == 6

AddPtr R5, #1
AddPtr R5, #1
AddPtr R5, #1	;R5 now points to the array that will hold the mod values we need 

; The next block of code will find R2 mod R3 and store the value in R2, note that R3 == Q for this part of the code 
Load R3, [R6]	;R6 == 1, R3 == Q 
SLT R2, R3
B #4		 	;exits when R2 < Q 
Sub R2, R3
SLT R0, R3		;Essentially a force branch
B #-5			;Branch for the mod, and it's being used as part of Linked branch, set 1  
SLT R0, R0		;resets flag register to 0 
 
;Storing the mod value into memory in the order that we want
Store R2, [R5]
AddPtr R5, #1	;Moves down the array   

;This next block calculates the next value that we need to mod to get a "mod value" to store in the array 
Addi R1, #0 	
Add R3, R2		;R3 = R2, and R3 will be used as a counter again, although this is a different value and will not need to be stored in memory 
B #-6			;Linked branch, set 1
Addi R3, #-2	;We need to decrement it by 2 though due to 5 * 5 only having 4 plus signs and how our SLT works  
Add R1, R2		;R1 is acting as an intermediate here; it's the number that we're going to repeatedly add to do our multiplication 
Add R2, R1 
Addi R3, #-1	;Decrement counterB 
SLT R0, R3		;Branches if R3 >= 0   
B #-3
AddPtr R6, #1	;R6 == 2 since counter is at Mem[2]
B #-8			;linked branch, set 1
Load R3, [R6]
Addi R3, #-1	;decrement counterA
Store R3, [R6]
AddPtr R6, #-1	;R6 == 1
SLT R3, R0		;Branches out if counterA < 0
B #3
SLT R0, R2 		;This happens when R3 < 0 
B #-8 			;Repeat the mod process; linked branch, set 1

;Clean slate!!! 
Addi R1, #0
Addi R1, #1		;This is the register that will shift the 1 to check whether there's a 1 at a position or not 

Addi R3, #0

Addi R4, #0	;I should have used R4 earlier as my counter
Addi R4, #1
Addi R4, R4	;R4 == 2
Addi R4, R4	;R4 == 4
Addi R4, R4	;R4 == 8
Addi R4, R4	;R4 == 16
Addi R4, #-1 ;R4 == 15 
  
ResetPtr R5
ResetPtr R6
AddPtr R5, #1
AddPtr R5, #1	;R5 == 3

;This block of code will process P to see which bits of its binary representation is a 1, then multiplies the values as necessary
Load R2, [R5]	;R2 == P 
And R2, R1
Addi R2, #-1 	;This is needed to make this SLT logic work out, otherwise, R2 always >= 0
SLT R2, R0
