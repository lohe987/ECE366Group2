# Written by: Singee Nguyen - September 23rd, 2018 
#	Project 2: Best Match Count
.data
T: .word 16
best_matching_score: .word -1 # best score = ? within [0, 32]
best_matching_count: .word -1 # how many patterns achieve the best score?
Pattern_Array: .word  11, 3, 56, 82, 21, 2, 1, 93, 76, 15, 30, 9, -5, -71, -32, -7, 38, 17, 13, 4

.text

	addi	$t0, $0, 0x2008		# holds the address of Pattern_Array
	lw	$s0, 0x2000($0)		# load T into $s0
#	lw 	$t1, 0($t0)		# loads first number of Pattern_Array
	addi	$s4, $s4, 20		# counter for numbers left in array	

next:	addi	$t0, $t0, 4		# moves address to next value
	lw	$t1, 0($t0)		# loads the new value into $t1
	xor	$s1, $t1, $s0		# checks for mismatching bits, stores into $s1	
	addi 	$s2, $0, 32		# refreshes loop counter
	addi 	$s3, $0, 1		# refreshes bit checker
	add	$t2, $0, $0		# set matching score back to 0
	
bit:	and	$t3, $s1, $s3		# checks specific bit @ bit check
	slt	$t3, $0, $t3		# $t3 = 1 if 0 < $t3
	beq	$t3, $0, skip		# if $t3 is non-zero. increment bit counter
	addi	$t2, $t2, -1		# decrement $t2 when there is a match, used to calculated match score by adding 32 

skip:	sll	$s3, $s3, 1		# shift the bit checker to the next bit(left)
	addi	$s2, $s2, -1		# decrement loop counter
	bne	$s2, $0, bit
	addi	$t2, $t2, 32		# $t2 = matching score
	addi	$s4, $s4, -1		# subtracts 1 value from the counter for the array
	beq	$s4, $0, done
 	#bne	$s4, $0, next		# branches back to Inc when counter for array is not zero, ends when $t6 is zero
 	
 	slt	$t3, $t4, $t2		# $t4 is best score; if best score is less than current score, $t3 = 1
 	bne	$t3, $0, bestS		# branch to bestS, which sets $t4 = $t2
 	beq	$t2, $t4, bestC		# if same best score is encountered, increment best matching score
 	bne	$s4, $0, next		# if nothing applies, branch and check the next array value

 
 bestS: sw	$t2, 0x2004($0)		# update best match score
 	lw	$t4, 0x2004($0)		# load best match score into $t4
 	addi 	$t5, $0, 1		# reset best match count to 0 since new best match score
 	# then update best match count in bestC
 bestC:	addi	$t5, $t5, 1
 	sw	$t5, 0x2008($0)		# update best match count
 	bne	$s4, $0, next		# branch and check the next array value
 	
 done:
 	