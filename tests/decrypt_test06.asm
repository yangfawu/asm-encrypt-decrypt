.data
plaintext6: .ascii "LPSQVQjsBeSX"
overrun6: .asciiz "You should be able to read me."
ciphertext6: .asciiz "bdcn sniu fednrca ieibtkalfesprnh i mzeoeo icdi crcf vteadfbrgb edernh idislbfz felseeegpteoeaeu nalbtiesdd idifespkluulcf*"
# decrypts to: bigredapple
.align 2
nr6: .word 41
nc6: .word 3
indices6: .word 1, 3, 5, 6, 5, 2, 2, 0, 0, 10, 10, 4, 0, 5
num_indices6: .word 14

.text
.globl main
main:
la $a0, plaintext6
la $a1, ciphertext6
lw $a2, nr6
lw $a3, nc6
addi $sp, $sp, -8
la $t1, indices6
sw $t1, 4($sp)
lw $t1, num_indices6
sw $t1, 0($sp)
li $t1, 174625  # trashing $t1
jal decrypt_sf
addi $sp, $sp, 8
move $s0, $v0
la $a0, plaintext6
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

la $a0, overrun6
li $v0, 4
syscall

li $v0, 10
syscall

.include "../hw9.asm"
