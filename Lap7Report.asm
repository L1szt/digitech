
main:
	addi $s0, $0, 1  # R1
	addi $s1, $0, 2  # G1
	addi $s2, $0, 3  # B1
	addi $s3, $0, 4  # R2
	addi $s4, $0, 5  # G2
	addi $s5, $0, 6  # B2
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	
	jal abs_diff_color
	j end


abs_diff_color:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	
	# |R1-R2|
	addi $sp, $sp, -4
	sw $ra, 0($sp)  # store returning address
	add $a0, $0, $s0
	add $a1, $0, $s3
	jal abs_diff
	add $t6, $0, $v0  # $t6 will hold our result
	
	# |G1-G2|
	add $a0, $0, $s1
	add $a1, $0, $s4
	jal abs_diff
	add $t6, $t6, $v0  # $t6 will hold our result
	
	# |B1-B2|
	add $a0, $0, $s2
	add $a1, $0, $s5
	jal abs_diff
	add $t6, $t6, $v0  # $t6 will hold our result
	
	add $v0, $0, $t6
	lw $ra, 0($sp)
	# we didn't change any caller registers so no need to restore anything
	
	addi $sp, $sp, 28  # cleanup stack
	jr $ra

end:
	j end
	

abs_diff:
	sub $t1, $a0, $a1
	sra $t2, $t1, 31
	add $t1, $t1, $t2
	xor $v0, $t1, $t2
	
	jr $ra

	