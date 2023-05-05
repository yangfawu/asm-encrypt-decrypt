.data
plaintext5: .ascii "TUnqVoBVU"
overrun5: .asciiz "You should be able to read me."
ciphertext5: .asciiz "sr a mthlgdmbfz edeaipi mzeaipi edeonpidmme aeerauulsdd rcaobfz rcaosdd ueitraoncln a mzekalptitnuulptitnkaljry"
# decrypts to: iamhappy
.align 2
nr5: .word 37
nc5: .word 3
indices5: .word 3, 3, 1, 2, 3, 0, 0, 1, 0, 1, 0, 7
num_indices5: .word 12

.text
.globl main
main:
la $a0, plaintext5
la $a1, ciphertext5
lw $a2, nr5
lw $a3, nc5
addi $sp, $sp, -8
la $t7, indices5
sw $t7, 4($sp)
lw $t7, num_indices5
sw $t7, 0($sp)
li $t7, 189192  # trashing $t7
jal decrypt_sf
addi $sp, $sp, 8
move $s0, $v0
la $a0, plaintext5
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

la $a0, overrun5
li $v0, 4
syscall

li $v0, 10
syscall

.include "../hw9.asm"
