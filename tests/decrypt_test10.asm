.data
plaintext10: .ascii "xHuntXnXcdWuyTku"
overrun10: .asciiz "You should be able to read me."
ciphertext10: .asciiz "ggswertpcrdohnpessppooie t liaenoee ntdlboorfiaaemndntrdoeoabkn lgpnna  y  rlronl  aiipec ds paal deepapbbltegiyprpmyfltdanpbbe  aamlopagle*ysslee sdrmpasl oa *"
# decrypts to: sweetcandytreat
.align 2
nr10: .word 20
nc10: .word 8
indices10: .word 0, 3, 4, 5, 0, 5, 6, 2, 3, 6, 1, 2, 6, 2, 5, 3, 0, 0, 6
num_indices10: .word 19

.text
.globl main
main:
la $a0, plaintext10
la $a1, ciphertext10
lw $a2, nr10
lw $a3, nc10
addi $sp, $sp, -8
la $t7, indices10
sw $t7, 4($sp)
lw $t7, num_indices10
sw $t7, 0($sp)
li $t7, 136546  # trashing $t7
jal decrypt_sf
addi $sp, $sp, 8
move $s0, $v0
la $a0, plaintext10
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

la $a0, overrun10
li $v0, 4
syscall

li $v0, 10
syscall

.include "../hw9.asm"
