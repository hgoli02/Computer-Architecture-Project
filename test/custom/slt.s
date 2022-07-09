	.text
main:   
        addi $v0,$zero,10
        addi $t0,$zero,5
        addi $t1,$zero,-3
        nop
	nop
	nop
        slt $t2,$t0,$t1
        slt $t3,$t1,$t0
        slti $t4,$t1,2
        slti $t5,$t1,-5
        slti $t6,$t0,2
        slti $t7,$t0,10
        add $t1,$zero,$t0
        nop
	nop
	nop
        slt $t8,$t1,$t0
        slti $t9,$zero,0
        nop
	nop
	nop
        syscall