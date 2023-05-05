.data
plaintext8: .ascii "bKSpoIQIKfZHCsCV"
overrun8: .asciiz "You should be able to read me."
ciphertext8: .asciiz "efdbo onhtmlk blso dnlllkhptaaae buetncoeaee oeanr dblm   ygrp dsp ig gyliffvhc*gdgytemnekogisuoiol*yooga o  abosszrspe* oborhucsrbos zeie *"
# decrypts to: greengrassfield
.align 2
nr8: .word 20
nc8: .word 7
indices8: .word 5, 0, 0, 4, 4, 4, 4, 5, 4, 2, 0, 4, 4, 0, 1, 2, 4, 4, 1
num_indices8: .word 19

.text
.globl main
main:
la $a0, plaintext8
la $a1, ciphertext8
lw $a2, nr8
lw $a3, nc8
addi $sp, $sp, -8
la $t0, indices8
sw $t0, 4($sp)
lw $t0, num_indices8
sw $t0, 0($sp)
li $t0, 415151  # trashing $t0
jal decrypt_sf
addi $sp, $sp, 8
move $s0, $v0
la $a0, plaintext8
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

la $a0, overrun8
li $v0, 4
syscall

li $v0, 10
syscall

.include "../hw9.asm"
