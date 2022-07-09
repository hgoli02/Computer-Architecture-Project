.text

main:
	addi $t0,$zero,10
	addi $t1,$zero,5
	nop
	nop
	nop
	sub $t2,$t0,$t1
	addi $t3,$zero,5
	nop
	nop
	beq $t2,$t3,finish
	nop
	nop
	nop
	addi $v0,$zero,10
	nop
	nop
	nop
	syscall 
	
finish:
	addi $t0,$zero,0
	addi $t1,$zero,0
	addi $t2,$zero,0
	addi $t3,$zero,0
	
	addi $v0,$zero,10
	nop
	nop
	nop
	syscall
	