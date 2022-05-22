	.text
main:   
        addi $v0,$zero,10
        addi $t0,$zero,-4
        addi $t1,$zero,4
        sra $t2,$t0,1
        sra $t3,$t1,1
        syscall