	.text
        .set noreorder
main:   
        addi $a0, $0, 5
        addi $a1, $0, 10
        jal jamkon
        nop
	nop
	nop
        addi $t0, $v0, 0
        addi $v0, $0, 10
        nop
	nop
	nop
        syscall
jamkon:
        add $v0, $a0, $a1
        jr $ra
        nop
        nop
        nop
       