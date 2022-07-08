        # Basic addition tests
	.text
main:   
        addi $4, $zero, 512
        nop
        nop
        nop
        add  $5, $4, $zero
        nop
        nop
        nop
        add  $6, $5, $5
        nop
        nop
        nop
        add  $7, $6, $6
        addiu $v0, $zero, 0xa
        nop
        nop
        nop
        syscall
