        # Basic LW/SW test
	.text
main:
        #;;  Set a base address
        ori $t0 ,0x8010
        ori $t1 ,0x0010


        addi  $t2, $zero, 0x7d
        addi  $t3, $zero, 0x10 # test -16
        addi  $t4, $zero, 0x1b
        addi  $t5, $zero, 0x45
        
        #;; Place a test pattern in memory
        
        sb $t3 , 3($t0) #miss to save
        sb $t4 , 1($t0) #hit to save
        sb $t5 , 2($t0) #hit to save
        sb $t2 , 0($t0) #hit to save

        lw $t6 , 0($t0) #hit to load #10451b7d
        
        sb $t3 , 0($t1) #miss to save , dirty bit = 1
        sb $t5 , 2($t1) #hit to save
        sb $t4 , 1($t1) #hit to save
        sb $t2 , 3($t1) #hit to save


        lw $t8 , 0($t1) #miss to load  t8 = 7d451b10

        lw $t7 , 0($t0) #miss to load , t7 = 10451b7d

        lb $s0 , 0($t0) #miss to load
        lb $s1 , 1($t0) #hit to load
        lb $s2 , 2($t0) #hit to load
        lb $s3 , 3($t0) #hit to load
        
        lb $s4 , 0($t1) #miss to load
        lb $s5 , 1($t1) #hit to load
        lb $s6 , 2($t1) #hit to load
        lb $s7 , 3($t1) #hit to load
        

        #;;  Quit out 
        addiu $v0, $zero, 0xa
        syscall
        
