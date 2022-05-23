.text
main:   
	
	addi $s0,$zero,2793
	andi $s1,$s0,1151
	
	addi $s2,$zero,2793
	ori $s3,$s0,1151
	
	addi $s4,$zero,2793
	xori $s5,$s0,1151
	    
	addi $v0,$zero,10
	syscall
	

