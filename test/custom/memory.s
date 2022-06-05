        # Basic LW/SW test
	.text
main:
        #;;  Set a base address
        lui $t0, 0x1001
        ori $t0 ,0x0100
        lui $t1, 0x1002
        ori $t1 ,0x0104


        addiu  $t2, $zero, 255
        add    $t3, $t2, $t3
        add    $t4, $t3, $t3
        add    $t5, $t3, $t4
        
        #;; Place a test pattern in memory
        sw $t2 , 0($t0)
        sw $t3 , 0($t0)
        lw $t6 , 0($t0)
        sw $t5 , 0($t1)
        lw $t7 , 0($t0)
        lw $t8 , 0($t1)
        

        #;; Calculate a "checksum" for easy comparison
        add    $s0, $t7, $t8
        
        #;;  Quit out 
        addiu $v0, $zero, 0xa
        syscall
        
