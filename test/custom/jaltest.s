	.text
main:   
        addi $a0, $0, 5
        addi $a1, $0, 10
        jal jamkon
        addi $t0, $v0, 0
        addi $v0, $0, 10
        syscall
jamkon:
       add $v0, $a0, $a1
       jr $ra
       