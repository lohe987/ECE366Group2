; Program 1 is suppose to calculate (6^P) % Q where P and Q are 16 bit unsigned integers stored 
; at memory address 0 and 1

Addi R6, 1
Addi R6, 1
Addi R6, 1  ;This makes R6 into 3 which will be where we store a counter value
Addi R3, 1
Add R3, R3  ; R3 == 2
Add R3, R3  ; R3 == 4
Add R3, R3  ; R3 == 8
Add R3, R3  ; R3 == 16
Addi R3, #-1  ;R3 == 15
Store R3, [R6] 
Addi R1, 1
Addi R1, 1
Addi R1, 1
Add R1, R1  ;R1 == 6

; The next block of code will find the mod values 
AddPtr R6, #1
