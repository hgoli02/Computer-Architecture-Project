.text

main:
	addi $t0,$zero,12
	addi $t1,$zero,15
	sub $t2,$t1,$t0
	
	addi $t1,$zero,-1
	subu $t3,$t1,$t0
	
	addi $v0,$zero,10
	syscall
	