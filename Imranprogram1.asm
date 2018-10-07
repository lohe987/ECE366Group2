.data

P: .word 1005
R: .word -1 # R will be stored here

.text
	addi $11, $0, 0x2000 # load start address of data in $11
   
	addi $8, $0, 1
	sw $8, 4($11)   # save a 1 in the result
	lw $9, 0($11)   # load exponent in $9
	addi $10, $0, 6  # load base (6) in $10
	addi $11, $0, 17  # load a 17 in $11 for the modulus calculations
loop1:
	beq $9, $0, end    # if exponent is zero, end
	andi $12, $9, 1	# else, get lowest bit value
	beq  $12, $0, next  # if the bit is zero, go to next
	
	add $16, $0, $8     # multiply current value of R by current base power of 2
	add $17, $0, $10
	jal multiply
	add $8, $0, $18

next:
	add $16, $0, $10   # elevate the base to next power of 2 
	add $17, $0, $10
	jal multiply
	add $10, $0, $18

    jal mod17          # calculate modulus of current power exponent

    srl $9, $9, 1   # advance to next bit in exponent
    j   loop1        # repeat

    #calculate the multiplication of $16 and $17, return result in $18
multiply:      
    addi $18, $0, 0
    beq  $16, $0, mulret    # if $16 is zero, result is zero
loop2:
    beq  $17, $0, mulret    # if $17 is zero, return
    add  $18, $18, $16      # add $16
    addi $17, $17, -1       
    j    loop2              # repeat while $17 is not zero
mulret:    
    jr  $31


    #calculate the modulus 17 of register $10, returns modulus in $10
mod17:
    slt $12, $10, $11   # if num < 17, it's already the modulus
    bne $12, $0, return
    sub $10, $10, $11   # subtract num = num - 17
    j   mod17           # repeat
return:
    jr   $31

end:
	add  $10, $0, $8    # calculate modulus 17 of result 
    jal mod17
	addi $9, $0, 0x2004 # load address of R in $9
	sw  $10, 0($9)       # save result

