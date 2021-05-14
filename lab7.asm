#
# Calculate sum from A to B.
#
# Authors: 
#	X Y, Z Q 
#
# Group: ...
#

.text
main:
	#
	# Your code goes here...
	#
	# we use A = 10 and B = 20 as an example
addi $t0, $0, -20 # = A
addi $t1, $0, 30 # = B 
addi $t2, $0, 0 # = S, this will hold our sum, we intially set it to 20 since this will be the least value we return in case A = B
beq $t0, $t1, specialCase
slt $t3, $t0, $t1 # if A > B then $t3 = 0 and we go to loop 2
beq $t3, $0, case2
addi $t1, $t1, 1 # adding an offset of one for the loop
j loop1 # A < B so we proceed to loop1

# if A < B
loop1:
beq $t0, $t1, end
add $t2, $t2, $t0 
addi $t0, $t0, 1
j loop1

# if A > B
case2: 
addi $t0, $t0, 1 # adding an offset of one for the loop

loop2:
beq $t1, $t0, end
add $t2, $t2, $t1 
addi $t1, $t1, 1
j loop2

	# Put your sum S into register $t2
end:	
	j	end	# Infinite loop at the end of the program. 

specialCase:
add $t2, $0, $t0
j end