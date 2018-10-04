# Code for Program 1 of Project 1  
# ECE366, Fall 2018, Wenjing Rao
# Peter Chen, chen172
# This program is suppose to calculate the result of ( 6 to the power of P ) mod 17 for P from 1 to 1200
# The result should be stored at the memory address, R. 

# 1200 = 1024 + 128 + 32 + 16 so I'll need to calculate up to 6 ^(2^10) mod 17 
# I should probably do something like, load P, and then find out how many digits it has by doing something like
# shifting the bits to the left until I get a 1 instead of the semi-brute force way that I'm doing it. 
# However many bits I need to shift will tell me how many bits I am from 2^31. 

#Assume compact memory configuration, so data address starts at 0x2000
.data 
	P: .word 201
	R: .word -1 
	powers_of_six_mod_results: .word -1
	# I think it's going to be faster to calculate the results of the ( ( 6^P ) mod 17 ) 
	#for when P is some power of 2 and store these values in memory for when I need to use them later. 
.text
	addi $s0, $0, 0x2008			#pointer to powers_of_six_mod_results
	addi $s3, $0, 10 			#$s3 is a counter for loop that repeatedly calls the find_mod function.
						#Increment $s3 to calculate more of ( 6^(powers of 2) ) mod 17
	#addi $a0, $0, 17
	#jal find_mod				#Code for testing to make sure that the find_mod function works for when the number is divisible by 17 or whatever. 
	#sw $a0, 0x2004($0)
	
	addi $a0, $0, 6				#Not going to bother sending 6^(2^0) to the function since 6 mod 17 = 6, plus, it's my "base case" 
	sw $a0, 0($s0)
	add $s2, $0, $a0			#$s2 is going to essentially be a duplicate of what the find_mod function returns.
						# This way, I can use it to calculate the mod of the next 6 ^ power of 2. 
	add $s1, $0, $a0 			#Saves the value of $a0 in $s1 so I can use $s1 as my counter for the multiplication loop 
	add $a0, $0, $0				#Reset $a0 so that my multiplication loop works properly. 
	addi $s0, $s0, 4
	#j stall_loop
multiply_a0_s2: 				#This should have been a function
	add $a0, $a0, $s2
	addi $s1, $s1, -1
	bne $s1, $0, multiply_a0_s2
	jal find_mod
	add $s2, $0, $a0			
	add $s1, $0, $a0
	sw $a0, 0($s0)
	add $a0, $0, $0
	addi $s0, $s0, 4
	addi $s3, $s3, -1
	bne $s3, $0, multiply_a0_s2
	
	#At this point in the code, I should have all the values that I need to calculate the values of ( 6^P ) mod 17 for P from 1 to 1200
	#stored in the memory starting at address 0x2008 which will have the value of 6^(2^0) mod 17.
	addi $s0, $0, 0x2008			#Resets are important, $s0 is a pointer once again to the values of ( 6^P ) mod 17
	add $a0, $0, $0
	lw $s4, 0x2000($0)			#So $s4 now holds the value of P
get_digit:
	beq $s4, $0, no_more_digits					
	andi $s1, $s4, 1			# $s1 tells me if the binary representation of P at the "first" digit, although I'll be 
	lw $s2, 0($s0)				# shifting this digit to suit my needs. 
	addi $s0, $s0, 4
	srl $s4, $s4, 1
	beq $s1, $0, get_digit
	#jal multiply_a0_s2_two			# $s2 is going to be a counter
	add $s1, $0, $a0 			# Pretty sure that I'm not using $s1 anymore at this point, but let's see...
	beq $a0, $0, initialize_a0
	addi $s2, $s2, -1			# NOTE: 5 times 5 only requires adding four 5s to 5 i.e. 5 * 5 == 5 + 5 + 5 + 5 + 5, there's only 4 plus signs!
	j add_loop
initialize_a0: 
	add $a0, $0, $s2			# "Base" case, so I don't subtract 1 and just initialize the value 
	j get_digit
add_loop: 					 
	beq $s2, $0, get_digit
	add $a0, $a0, $s1
	addi $s2, $s2, -1 
	j add_loop
no_more_digits:
	jal find_mod
	sw $a0, 0x2004($0)
	j stall_loop

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	#I'm going to write this to be like a function, but I didn't want to deal with the whole memory management issue (shame on me)
	#so I'm just going to use $a0 essentially as a parameter that's passed by reference so I can "return" it too. 
	#Also, since I'm not doing nested function calls, I'm not going to bother with preserving $ra either...
	#We weren't allowed to use $sp anyways so I don't we're suppose to do that stuff yet. 

	# $t0 will be repeatedly used for slt in this function

find_mod: 					#mod of 17	
	addi $t1, $0, 17			#Change this to do mod by some number other than 17; make adjustments for the make_neg and end of repeat_sub too. 
compare_t1_a0: 	
	sltu $t0, $t1, $a0
	beq $t0, $0, bigger_than
	sll $t1, $t1, 1
	j compare_t1_a0
bigger_than:  
	slti $t0, $t1, 18			#Change 18 to (new number) + 1 to make sure this works for other numbers. 
	bne $t0, $0, make_neg
	srl $t1, $t1, 1 			#Moves $t1's value back to something smaller than $a0 so I can subtract it
	sub $a0, $a0, $t1			#Using sub here shouldn't cause any issues as long as the unsigned value is small enough. 
	j find_mod 				#!!! Let's try this and see what happens, I think if I jump at this point, I won't need to loop subtraction later			
make_neg: 
	addi $t1, $0, -17			#No subu workaround, and I need to reset $t1 here anyways if I did some multiplication by shifting
repeat_sub:					#Technically should be repeat add negative
	addu $a0, $a0, $t1			#$a0 should be less than 17 at this point. 
	slt $t0, $a0, $0			# Checks if $a0 < 0
	beq $t0, $0, repeat_sub			#Just some extra code to make sure that $a0 becomes negative before moving on, I'll test it without these conditions later
						#I'm pretty sure I need this line of code here in order to handle when the result is 0. 
	addi $a0, $a0, 17			#$a0 is now some negative number obtained by subtracting 17 from it, basically my final "division", and this negative
						#value added to 17 should give me what the remainder should be. Ex: 6 - 17 = -11, -11 + 17 = 6, which is what 6 mod 17 is. 
	jr $ra

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

stall_loop:
	j stall_loop
