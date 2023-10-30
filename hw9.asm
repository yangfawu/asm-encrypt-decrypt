.text
null_cipher_sf:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # $a0 -> address of next byte to write
    # $a1 -> address of current byte in input
    # $a2 -> address of current char index
    # $a3 -> size of array

    li $v0, 0 # number of characters in $a0

null_cipher_sf_loop_a3_times:
    # check if we still need to read words
    beq $a3, $0, null_cipher_sf_done

    lb $t1, 0($a2) # grab the index we need
    
    # if the index is 0, we marked the word as handled and skip to next word
    beq $t1, $0, null_cipher_sf_loop_a3_times_skip_to_next_word

    # subtract 1 to get 0-indexed
    addi $t1, $t1, -1

    # apply offset on a1 to get address of the character we need to store
    add $a1, $a1, $t1

    # reuse t1 to store the character
    lb $t1, 0($a1)

    # store the character at the ouput address and move
    sb $t1, 0($a0)
    addi $a0, $a0, 1
    addi $v0, $v0, 1

    # a1 is currently the character we already read
null_cipher_sf_loop_a3_times_skip_to_next_word:
    # move a1 so we can check next character
    addi $a1, $a1, 1

    # reuse t1 again to store the character
    lb $t1, 0($a1)

    # if t1 is space, the next letter is the new word
    li $t2, ' '
    beq $t1, $t2, null_cipher_sf_loop_update_pointers
    
    # check if t1 is null
    beq $t1, $0, null_cipher_sf_done
    
    j null_cipher_sf_loop_a3_times_skip_to_next_word
null_cipher_sf_loop_update_pointers:
    addi $a1, $a1, 1
    addi $a2, $a2, 4
    addi $a3, $a3, -1
    j null_cipher_sf_loop_a3_times
null_cipher_sf_done:
    #  set null at the end
    sb $0, 0($a0)

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    
    jr $ra

######################################

transposition_cipher_sf:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    # we dont return anything, but ill use this as a counter
    li $v0, 0

    li $t0, 0
transposition_cipher_sf_loop:
    lb $t1, 0($a1)
    beq $t1, $0, transposition_cipher_sf_loop_end

    div $t0, $a2 # divide index by a2 (num_rows)
    mflo $t2 # quotient gives column index
    mfhi $t3 # remainder gives row index

    # get index to store t3*a3 + t2

    # t3*a3
    mul $t4, $t3, $a3

    # +t2
    add $t4, $t4, $t2

    # get address to store
    add $t4, $t4, $a0
    sb $t1, 0($t4)


    # only update v0 if we did not store *
    li $t4, '*' # reuse t4
    beq $t1, $t4, transposition_cipher_sf_loop_update_pointers
    addi $v0, $v0, 1
transposition_cipher_sf_loop_update_pointers:
    addi $a1, $a1, 1
    addi $t0, $t0, 1
    j transposition_cipher_sf_loop
transposition_cipher_sf_loop_end:

    # set null at first *
    add $a0, $a0, $v0
    sb $0, 0($a0)

    lw $ra, 0($sp)
    addi $sp, $sp, 4

    jr $ra

######################################

decrypt_sf:
    addi $sp, $sp, -8

    # reminder:
    # now 8($sp) -> num_indexes
    # now 12($sp) -> indices

    sw $ra, 0($sp) # store so we can call a inner function
    sw $a0, 4($sp) # store reference to plaintext (we need this later)

    # allocate space for new plaintext for transposition_cipher_sf
    mul $t0, $a2, $a3 # rows*cols
    addi $t0, $t0, 1 # +1 for null

    # now $t0 has how many bytes we need to store new plaintext
    # but it may not be word aligned
    # so the next part adds more to $t0 to ensure it is a multiple of 4

    # check if last 2 bits are set at all
    andi $t1, $t0, 0x3

    # if t1 is 0, that means t0 is alreayd multiple of 4
    beq $t1, $0, decrypt_sf_t0_aligned

    # now we determine how much we need to add to t0 to make multiple of 4
    li $t2, 4
    sub $t2, $t2, $t1

    # now t0 is multiple of 4
    add $t0, $t0, $t2

    # note: t1, t2 no longer needed
decrypt_sf_t0_aligned:
    # move sp to allocate by word aligned amount
    sub $sp, $sp, $t0

    # reminder:
    # now (t0)($sp) -> decrypt_sf's $ra
    # now (4+t0)($sp) -> original a0
    # now (8+t0)($sp) -> num_indexes
    # now (12+t0)($sp) -> indices

    # we change a0 to the our newly allocated memory
    move $a0, $sp

    # since we need t0 after running transposition_cipher_sf, we caller-save it
    addi $sp, $sp, -8
    sw $t0, 0($sp)

    sw $a0, 4($sp) # we also save a0 reference because transposition_cipher_sf can modify
    
    # we run transposition_cipher_sf and it modify t0 all it wants
    jal transposition_cipher_sf

    # we load t0 back in
    lw $t0, 0($sp)

    # a0 is transpos's output and we move it to input for null cipher
    # HOWEVER, a0 may have been modified by transposition_cipher_sf
    # so we pull a0 from stack instead
    lw $a1, 4($sp)

    addi $sp, $sp, 8

    # reminder:
    # now (t0)($sp) -> decrypt_sf's $ra
    # now (4+t0)($sp) -> original a0
    # now (8+t0)($sp) -> num_indexes
    # now (12+t0)($sp) -> indices

    add $t1, $sp, $t0
    addi $t1, $t1, 4
    lw $a0, 0($t1) # load in original a0 now

    addi $t1, $t1, 4
    lw $a3, 0($t1) # load in num_indices

    addi $t1, $t1, 4
    lw $a2, 0($t1) # load in indices

    # store t0 once again because we need it after running null_cipher_sf
    addi $sp, $sp, -4
    sw $t0, 0($sp)

    # null_cipher_sf can modify t0 all it wants
    jal null_cipher_sf
    
    # v0 from null_cipher_sf is what we return, so no modification

    # we load t0 back in
    lw $t0, 0($sp)
    addi $sp, $sp, 4

    add $sp, $sp, $t0 # deallocate our new plaintext

    # reminder:
    # now (0)($sp) -> decrypt_sf's $ra
    # now (4)($sp) -> original a0
    # now (8)($sp) -> num_indexes
    # now (12)($sp) -> indices

    lw $ra, 0($sp)
    # lw $a0, 4($sp) # loading a0 from stack instead of relying on output of null cipher
    addi $sp, $sp, 8

    # reminder:
    # now (0)($sp) -> num_indexes
    # now (4)($sp) -> indices
    
    jr $ra
