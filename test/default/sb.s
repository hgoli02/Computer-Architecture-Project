lui $1, 0xfafb
nop
nop
nop
ori $1, $1, 0xfcfd
lui $2, 0x0102
nop
nop
nop
ori $2, $2, 0x0304
lui $3, 0xa0b0
nop
nop
nop
ori $3, $3, 0xc0d0
addi $7, $0, 12
nop
nop
nop
sw $1, 8($7)
sw $2, 8($0)
sw $3, 0($7)
lb $8, 8($0)
lb $9, 9($0)
lb $10, 10($0)
lb $11, 11($0)
sb $7, 10($7)
sb $7, 8($0)
sb $7, 3($7)
lw $4, 8($7)
lw $5, 8($0)
lw $6, 0($7)
nop
nop
nop
syscall
