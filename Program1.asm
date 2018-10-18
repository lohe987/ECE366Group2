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

Addi R2, #0
Addi R2, #1

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

;This block of code will process P to see which bits of its binary representation is a 1, later blocks will multiplies the values as necessary
Load R3, [R6]	;R3 == P
AddPtr R6, #1
AddPtr R6, #1	;R6 == 2
Load R2, [R6]
B #-4			;linked branch set 2
And R3, R2
Addi R3, #-1 	;This is needed to make this SLT logic work out, otherwise, R2 always >= 0
Addi R4, #-1
AddPtr R5, #1
Add R2, R2		;"left shift" R2  
SLT R3, R0
B #-7	;R3 == 0 before I did the subtraction, thus there was a 0 at this digit; linked branch set 2

;Note the value in R1 should be the result of all the multiplication that we need to do
;Its value will need to be shifted back into one of the registers that have access to memory after everything is said and done
;This had to happen though in order to preserve some of the values that would be used.
;Stores the bitchecker value  
Store R2, [R6]
ResetPtr R6
Addi R2, #0
B #-4  		;Linked branch set 3, although this is going to be linked to set 2 from this point above 
Load R3, [R5]
SLT R0, R1 		;This will only evaluate to false during the first run that we found a 1 
B #4
Add R1, R3	;This is initializing R1 since it should be zero when this line executes
SLT R1, R0	;force branch back to the up to start of checking digits 
B #-6		;Linked branch set 3
;Start of the repeated addition loop
Add R2, R1
Addi R3, #-2
B #-3		;Linked branch set 4, although it will be linked to branch set 3 from now on
Add R1, R2
Addi R3, #-1
SLT R0, R3 
B #-3
SLT R4, R0		;branch out when R4 is negative 
B 3	
SLT R0, R1
B #-8 		;Linked branch set 4 

Addi R2, #0 
Add R2, R1
Addi R1, #0 
ResetPtr R5
AddPtr R5, #1
Load R3, [R5]  
AddPtr R5, #1
SLT R2, R3
B #4		 	;exits when R2 < Q 
Sub R2, R3
SLT R0, R3		;Essentially a force branch
B #-4			;Branch for the mod, and it's being used as part of Linked branch, set 1 
Store R2, [R5]	;So...R2 should be the value that I'm looking for now...and R2 == 2
B #0			;stall branch  
