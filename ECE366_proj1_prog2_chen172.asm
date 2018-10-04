# ECE366, project1, program  2
# Peter Chen, chen172
# Best match program

.data
	T: .word 12
	#T: .word 0xABCDEF00			#Pattern a
	#T: .word -5				#Pattern b
	# I just used the alternating array with the original word in T to see if it worked properly for that case. 
	best_matching_score: .word -1
	best_matching_count: .word -1
	#Pattern_Array: .word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 17, 18, 19, 20
	#Pattern_Array: 0, 1, 2, 3, 4, -1, -2, -3, -4, -5, 0xEEEEEEEE, 0x44448888, 0x77777777, 0x33333333, 0xAAAAAAAA,
	#		0xFFFF0000, 0xFFFF, 0xCCCCCCCC, 0x66666666, 0x99999999
	#Pattern_Array: .word 1, -2, 3, -4, 5, -6, 7, -8, 9, -10, -5, 5, -5, 5, -5, 1, -2, 3, -4, 5
	Pattern_Array: .word 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1
	#Pattern_Array: .word 0, 1, 2, 3, 0, 5, 6, 7, 0, 9, 10, 11, 0, 0, 15, 16, 17, 18, 19, 28
	
.text 
	addi $s0, $0, 20			# $s0 will be a counter for a loop moving through Pattern_Array
	add $s1, $0, $0				# $s1 will best_matching_count's counter
	addi $s2, $0, 0x200c			# $s2 will be a pointer to values in Pattern_Array
	addi $s3, $0, -1			# $s3 will hold the best score

access_array:
	beq $s0, $0, end
	lw $s4, 0x2000($0)			# $s4 will hold the value at address T
	lw $s5, 0($s2)				# $s5 will hold the value at the whatever index of the array we're at
	addi $s2, $s2, 4
	addi $s0, $s0, -1
	xor $s4, $s4, $s5
	add $t0, $0, $0				# $t0 will be a counter for how many 1's we get from the xor
count_ones: 
	beq $s4, $0, match_score	
	andi $t1, $s4, 1			# t1 == 1 means that the first bit of $s4 has a 1
	srl $s4, $s4, 1
	beq $t1, $0, count_ones
	addi $t0, $t0, 1
	j count_ones

match_score: 
	sub $t1, $0, $t0			# Just making $t1 the negative of $t0
	addi $t0, $t1, 32			# $t0 now holds the current index's match score with the value at address T. 		
	slt $t2, $s3, $0			# $t2 is being used for slt, this checks if $s3 is still my sentinel value of -1 
	beq $t2, $0, compare_score
	add $s3, $0, $t0
	addi $s1, $0, 1
	j access_array
compare_score:
	bne $t0, $s3, not_same			#If this branch doesn't move us, that means the score are the same. 
	addi $s1, $s1, 1
	j access_array
not_same: 
	slt $t2, $s3, $t0			# Checks if the match_score of the value at the current index is higher than the previous high score we got. 
	beq $t2, $0, same_high_score		# same high score in this context just means the high score stays the same, not that we got the same score		
	add $s3, $0, $t0			# New high score
	addi $s1, $0, 1				# Resets counter to 1 since we have a new high score
same_high_score:
	j access_array

end: 
	sw $s3, 0x2004($0)
	sw $s1, 0x2008($0)
stall_loop:
	j stall_loop
