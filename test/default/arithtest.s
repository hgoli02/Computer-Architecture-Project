        # Basic arithmetic instructions
        # This is a hodgepodge of arithmetic instructions to test
        # your basic functionality.
        # No overflow exceptions should occur
	.text
main:   
        addiu   $2, $zero, 1024
        nop
        nop
        nop
        addu    $3, $2, $2
        nop
        nop
        nop
        or      $4, $3, $2
        add     $5, $zero, 1234
        nop
        nop
        nop
        sll     $6, $5, 16
        nop
        nop
        nop
        addiu   $7, $6, 9999
        nop
        nop
        nop
        subu    $8, $7, $2
        xor     $9, $4, $3
        xori    $10, $2, 255
        srl     $11, $6, 5
        sra     $12, $6, 4
        nop
        nop
        and     $13, $11, $5
        andi    $14, $4, 100
        sub     $15, $zero, $10
        lui     $17, 100
        addiu   $v0, $zero, 0xa
        nop
        nop
        nop
        syscall
        
        
                        
