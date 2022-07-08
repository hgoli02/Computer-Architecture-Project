        # Basic LW/SW test
	.text
main:
        #;;  Set a base address
        lui    $3, 0x1000

        addiu  $5, $zero, 255
        nop
        nop
        nop
        add    $6, $5, $5
        nop
        nop
        nop
        add    $7, $6, $6
        nop
        nop
        nop
        addiu  $8, $7, 30000
        
        #;; Place a test pattern in memory
        sw     $5, 0($3)
        sw     $6, 4($3)
        sw     $7, 8($3)
        sw     $8, 12($3)

        lw     $9,  0($3)
        lw     $10, 4($3)
        lw     $11, 8($3)
        lw     $12, 12($3)

        addiu  $3, $3, 4
        nop
        nop
        nop
        sw     $5, 0($3)
        sw     $6, 4($3)
        sw     $7, 8($3)
        sw     $8, 12($3)

        lw     $13,  -4($3)
        lw     $14,  0($3)
        lw     $15,  4($3)
        lw     $16,  8($3)
               
        #;; Calculate a "checksum" for easy comparison
        add    $17, $zero, $9
        nop
        nop
        nop
        add    $17, $17, $10
        nop
        nop
        nop
        add    $17, $17, $11
        nop
        nop
        nop
        add    $17, $17, $12
        nop
        nop
        nop
        add    $17, $17, $13
        nop
        nop
        nop
        add    $17, $17, $14
        nop
        nop
        nop
        add    $17, $17, $15
        nop
        nop
        nop
        add    $17, $17, $16
        
        #;;  Quit out 
        addiu $v0, $zero, 0xa
        nop
        nop
        nop
        syscall
        
