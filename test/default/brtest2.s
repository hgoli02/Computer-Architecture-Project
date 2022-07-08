        # Basic branch test
	.text
        .set noreorder

main:
        addiu $v0, $zero, 0xa
l_0:    
        j l_1
        nop
        nop
        nop
l_1:
        bne $zero, $zero, l_3
        nop
        nop
        nop
l_2:
        beq $zero, $zero, l_4
        nop
        nop
        nop
        addiu $7, $zero, 0x347
        syscall
l_3:
	addiu $7, $zero, 0x1337
        # Should not reach here
l_4:
        addiu $7, $zero, 0xd00d
        nop
        nop
        nop
        syscall
        
         
        
