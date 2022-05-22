.text

main:
	add $t0,$zero,10
	add $t1,$zero,3
	add $t2,$t1,$t0
	mul $s0,$t0,$t1
	
	addi $t2,$zero,-2
	mul $s1,$t1,$t2
	
	addi $t2,$zero,0
	mul $s2,$t1,$t2
	
	addi $v0,$zero,10
	syscall 
	