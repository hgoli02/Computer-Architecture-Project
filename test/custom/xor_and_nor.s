.text 

main:
	addi $t0,$zero,15
	addi $t1,$zero,10
	addi $t2,$zero,-16
	nop
	nop
	xor $s0,$t0,$t1
	or $s1,$t0,$t2
	nor $s2,$t0,$t1
	and $s3,$t0,$t1
	
	addi $v0,$zero,10
	nop
	nop
	nop
	syscall
	