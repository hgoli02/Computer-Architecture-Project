.text

main:
	addi $t0,$zero,10
	addi $t1,$zero,5
	sub $t2,$t0,$t1
	addi $t3,$zero,5
	
	beq $t2,$t3,finish
	
	addi $v0,$zero,10
	syscall 
	
finish:
	addi $t0,$zero,0
	addi $t1,$zero,0
	addi $t2,$zero,0
	addi $t3,$zero,0
	
	addi $v0,$zero,10
	syscall
	