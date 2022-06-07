        # Basic LB/SB test
	.text
main:
        #;;  Set a base address
        lui $t0, 0x1001
        ori $t0 ,0x0101
        lui $t1, 0x1002
        ori $t1 ,0x0102


        addiu  $t2, $zero, 255
        add    $t3, $t2, $t2
        add    $t4, $t3, $t3
        add    $t5, $t3, $t4
        
        #;; Place a test pattern in memory
        sb $t2 , 0($t0) #miss to save
        sb $t3 , 0($t0) #hit to save
        lb $t6 , 0($t0) #hit to load
        sb $t5 , 0($t1) #miss to save , dirty bit = 1
        lb $t7 , 0($t0) #miss to load , dirty bit = 1
        lb $t8 , 0($t1) #miss to load , dirty bit = 0
        

        #;; Calculate a "checksum" for easy comparison
        add    $s0, $t7, $t8
        
        #;;  Quit out 
        addiu $v0, $zero, 0xa
        syscall
        
