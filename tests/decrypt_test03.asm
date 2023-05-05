.data
plaintext3: .ascii "QySuFpfsAb"
overrun3: .asciiz "You should be able to read me."
ciphertext3: .asciiz "koldeslto nwrscescooaemsccooaecooaepicpenweg ouinase ucs hclt ui hclt hclt rnil*"
# decrypts to: wowsocool
.align 2
nr3: .word 40
nc3: .word 2
indices3: .word 4, 2, 4, 1, 3, 5, 3, 3, 8
num_indices3: .word 9

.text
.globl main
main:
la $a0, plaintext3
la $a1, ciphertext3
lw $a2, nr3
lw $a3, nc3
addi $sp, $sp, -8
la $t4, indices3
sw $t4, 4($sp)
lw $t4, num_indices3
sw $t4, 0($sp)
li $t4, 275434  # trashing $t4
jal decrypt_sf
addi $sp, $sp, 8
move $s0, $v0
la $a0, plaintext3
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

la $a0, overrun3
li $v0, 4
syscall

li $v0, 10
syscall

.include "../hw9.asm"
