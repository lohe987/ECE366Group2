.data
P:	.word 5
R:	.word -1

.text
	addi $s0, $0, 6		# initialize $s0 = 6; initial (base) value
	addi $s1, $0, 17	# 17 used for modulation
	lw   $s2, 0x2000($0)	# load P from memory into $s2
	
	addi  $t0, $0, 6	# initialize $t0 as 6
	slti  $s3, $s2, 2	# used for edge case of P = 1 --> branch to end
	bne   $s3, $0, done	
	
power:	sll   $t0, $s0, 2	# $t0 = 4*(base), e.g. $t0 = 6 * [2^2]
	addu  $t0, $t0, $s0	# $t0 = 4*(base) + (base) = 5*(base)
	addu  $t0, $t0, $s0	# $t0 = 5*(base) + (base) = 6*(base)
	
	add  $s0, $0, $t0	# save the product after multiplying by 6, used as new (base)
	addi $s2, $s2, -1	# decrement the counter until P = 1
	bne  $s2, 1, power	# branch to loop for respective power

	sll  $s1, $s1, 15	# shift 17 to the left by 15 bits for higher efficiency

loop:	jal chk
	srl  $s1, $s1, 1	# shift to right by 3 repeatedly
	bne  $s1, 8, loop

	j    done 

chk: 	slt  $s2, $t0, $s1
	bne  $s2, $0, skip	
sub:	sub  $t0, $t0, $s1	# subtract from base value
	slt  $s2, $s1, $t0	# checks if (17 LSL 10) can be subtracted from base
	bne  $s2, $0, sub
	
skip:	jr   $ra		# after loop is done, jump back to pc+4 of jal instruction

done:	sw   $t0, 0x2004($0)	#stores $t0 into the address of result, R
	
