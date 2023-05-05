.data
plaintext7: .ascii "oEFgJCJKsucAK"
overrun7: .asciiz "You should be able to read me."
ciphertext7: .asciiz "setpa begkitunsupgmrr begkxrn vteodurislgt aoljtnhotgbdo g se nrr oagbdo picaeu u saanloefpoeorg toolyolhbisf oapgmolyoeeeednrsnatl oysrldd y"
# decrypts to: hotsummerday
.align 2
nr7: .word 47
nc7: .word 3
indices7: .word 8, 2, 0, 5, 3, 2, 7, 7, 0, 1, 8, 5, 1, 0, 0, 3
num_indices7: .word 16

.text
.globl main
main:
la $a0, plaintext7
la $a1, ciphertext7
lw $a2, nr7
lw $a3, nc7
addi $sp, $sp, -8
la $t3, indices7
sw $t3, 4($sp)
lw $t3, num_indices7
sw $t3, 0($sp)
li $t3, 381278  # trashing $t3
jal decrypt_sf
addi $sp, $sp, 8
move $s0, $v0
la $a0, plaintext7
li $v0, 4
syscall
li $a0, '\n'
li $v0, 11
syscall

move $a0, $s0
li $v0, 1
syscall
li $a0, '\n'
li $v0, 11
syscall

la $a0, overrun7
li $v0, 4
syscall

li $v0, 10
syscall

.include "../hw9.asm"
