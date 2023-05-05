.data
plaintext9: .ascii "AUUzjBOfoQq"
overrun9: .asciiz "You should be able to read me."
ciphertext9: .asciiz "fpoeolyocouce zs mzeuulmice ito malpldd begkorlarfzkbfz mzeucarbg oce e*aolgbdo lf mai yuulbfz s marhmnarse*"
# decrypts to: lazycatnap
.align 2
nr9: .word 36
nc9: .word 3
indices9: .word 0, 0, 3, 2, 3, 3, 0, 0, 5, 2, 6, 4, 2, 5
num_indices9: .word 14

.text
.globl main
main:
la $a0, plaintext9
la $a1, ciphertext9
lw $a2, nr9
lw $a3, nc9
addi $sp, $sp, -8
la $t1, indices9
sw $t1, 4($sp)
lw $t1, num_indices9
sw $t1, 0($sp)
li $t1, 229399  # trashing $t1
jal decrypt_sf
addi $sp, $sp, 8
move $s0, $v0
la $a0, plaintext9
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

la $a0, overrun9
li $v0, 4
syscall

li $v0, 10
syscall

.include "../hw9.asm"
