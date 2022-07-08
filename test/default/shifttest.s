        # Basic shift tests
	.text
main:   
        ori $3, $zero, 65535
        nop
        nop
        nop
        sll   $4, $3, 16
        sll   $5, $3, 6
        nop
        nop
        sra   $6, $4, 10
        sra   $7, $5, 16
        srl   $8, $4, 8
        srl   $9, $5, 16
        addiu $2, $zero, 0xa
        nop
        nop
        nop
        syscall
