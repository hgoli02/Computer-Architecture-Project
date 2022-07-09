	.text
main:   
        addi $v0,$zero,10
        addi $t3,$zero,2
        addi $t0,$zero,4
        nop
	nop
	nop
        srl $t1,$t0,1
        sll $t2,$t0,2
        srlv $t4,$t0,$t3
        sllv $t5,$t0,$t3
        nop
	nop
	nop
        syscall