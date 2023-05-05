.data
plaintext4: .ascii "mVUHnIWrHBTIYnVa"
overrun4: .asciiz "You should be able to read me."
ciphertext4: .asciiz "fpttoiaucedopreihr tuyedresdldere*ihormnaasslaoasn*ei eec ns etomic*nla nert s ed te*dldet e skc luy *s vm cssuehfen h*hlepsatucdol isi*ionlcnaccacadvcg*"
# decrypts to: ilovecatssomuch
.align 2
nr4: .word 17
nc4: .word 9
indices4: .word 3, 3, 2, 3, 1, 2, 2, 4, 1, 1, 0, 3, 0, 5, 1, 2, 1
num_indices4: .word 17

.text
.globl main
main:
la $a0, plaintext4
la $a1, ciphertext4
lw $a2, nr4
lw $a3, nc4
addi $sp, $sp, -8
la $t5, indices4
sw $t5, 4($sp)
lw $t5, num_indices4
sw $t5, 0($sp)
li $t5, 335279  # trashing $t5
jal decrypt_sf
addi $sp, $sp, 8
move $s0, $v0
la $a0, plaintext4
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

la $a0, overrun4
li $v0, 4
syscall

li $v0, 10
syscall

.include "../hw9.asm"
