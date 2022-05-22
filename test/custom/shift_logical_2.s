	.text
main:
	addi $t0,$zero,15
	srl $t0,$t0,1
	addi $t1,$zero,-1
	sll $t1,$t1,2
	add $t2,$t1,$t0
	
	addi $v0,$zero,10
	syscall 
	