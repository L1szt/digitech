#
# Sum of Absolute Differences Algorithm
#
# Authors: 
#	X Y, Z Q 
#
# Group: ...
#

.text


main:


# Initializing data in memory... 
# Store in $s0 the address of the first element in memory
	# lui sets the upper 16 bits of thte specified register
	# ori the lower ones
	# (to be precise, lui also sets the lower 16 bits to 0, ori ORs it with the given immediate)
	     lui     $s0, 0x0000 # Address of first element in the vector
	     ori     $s0, 0x0000
	     addi   $t0, $0, 5	# left_image[0]	
	     sw      $t0, 0($s0)
	     addi   $t0, $0, 16	# left_image[1]		
	     sw      $t0, 4($s0)
	     # TODO1: initilize the rest of the memory.
	     addi   $t0, $0, 7		
	     sw      $t0, 8($s0)
	     addi   $t0, $0, 1			
	     sw      $t0, 12($s0)
	     addi   $t0, $0, 1		
	     sw      $t0, 16($s0)
	     addi   $t0, $0, 13			
	     sw      $t0, 20($s0)
	     addi   $t0, $0, 2		
	     sw      $t0, 24($s0)
	     addi   $t0, $0, 8			
	     sw      $t0, 28($s0)
	     addi   $t0, $0, 10	
	     sw      $t0, 32($s0)
	     
	     # loading right array
	     addi   $t0, $0, 4	
	     sw      $t0, 36($s0)
	     addi   $t0, $0, 15
	     sw      $t0, 40($s0)
	     addi   $t0, $0, 8
	     sw      $t0, 44($s0)
	     addi   $t0, $0, 0
	     sw      $t0, 48($s0)
	     addi   $t0, $0, 2
	     sw      $t0, 52($s0)
	     addi   $t0, $0, 12
	     sw      $t0, 56($s0)
	     addi   $t0, $0, 3	
	     sw      $t0, 60($s0)
	     addi   $t0, $0, 7	
	     sw      $t0, 64($s0)
	     addi   $t0, $0, 11	
	     sw      $t0, 68($s0)
	
	# from 72($s0) to 98($s0) we store the sad_array
	     
	     
	     
	# TODO4: Loop over the elements of left_image and right_image
	
	
	addi $s1, $0, 0 # $s1 = i = 0
	addi $s2, $0, 9	# $s2 = image_size = 9
	
loop:
	
	# Check if we have traversed all the elements 
	# of the loop. If so, jump to end_loop:
	beq $s1, $s2, end_loop
	
	# Load left_image{i} and put the value in the corresponding register
	# before doing the function call
	sll $t0, $s1, 2  # i * 4, gives us the correct offset for the left array
	add $t0, $t0, $s0   # add the offset to the starting address
	lw $a0, 0($t0)  # $a0 = left_image[i]
	
	
	# Load right_image{i} and put the value in the corresponding register
	addi $t0, $t0, 36  # adding according offset to access right_image[], i = i + 36 
	lw $a1, 0($t0)  # $a1 = right_image[i]
	
	# Call abs_diff
	jal abs_diff
	# return value is stored in $v0
	
	#Store the returned value in sad_array[i]
	addi $t0, $t0, 36  # adding according offset to access sad_image[], i = i + 36 
	sw $v0, 0($t0)  # $a1 = right_image[i]
	 
	
	
	# Increment variable i and repeat loop:
	addi $s1, $s1, 1 
	j loop
	

	
end_loop:

	#TODO5: Call recursive_sum and store the result in $t2
	#Calculate the base address of sad_array (first argument
	#of the function call)and store in the corresponding register   
	addi $a0, $s0, 72
		
	# Prepare the second argument of the function call: the size of the array
	addu $a1, $0, 9
	addi $s3, $0, 0
	
	# Call to function
	jal recursive_sum

	
	#Store the returned value in $t2
	add $t2, $0, $v0

end:	
	j	end	# Infinite loop at the end of the program. 

		

# TODO2: Implement the abs_diff routine here, or use the one provided

# $a0 = left_image[i], $a1 = right_image[i]
abs_diff:
	sub $t1, $a0, $a1
	sra $t2, $t1, 31
	add $t1, $t1, $t2
	xor $v0, $t1, $t2
	
	jr $ra


# TODO3: Implement the recursive_sum routine here, or use the one provided

# $a0 = base address, $a1 = size
recursive_sum:
	addi $sp, $sp, -8  # allocate 2 words on the stack
	sw $ra, 4($sp)  # save $ra in upper word
	sw $s3, 0($sp)  # save becaus it will get overwritten (saved in lower word)
	
	beq $a1, $0, basecase # if size == 0, basecase
	addi $t0, $a1, -1  # $t1 = size-1
	sll $t0, $t0, 2  # compute correct offset, i.e. $t0 = (size-1) * 4
	add $t0, $t0, $a0  # get memory address of element at stake
	lw $s3, 0($t0)
	addi $a1, $a1, -1  # decrement size by -1, preperation for next recursive call
	jal recursive_sum
	add $v0, $v0, $s3
	j end_sum

basecase:
	addi $v0, $0, 0  # return 0
	
	# after base case we come here to unfold all the recursive calls
	# cleanup recursion code 
end_sum:
	lw $s3, 0($sp) # restore the last saved arr[i] from the stack
	lw $ra, 4($sp) # restore the line in code we have to jump to from the stack 
	addi $sp, $sp, 8  # move stack pointer up 
	jr $ra  # jump to proceeding function call
	
	
	
	
