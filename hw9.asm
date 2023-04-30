.text
null_cipher_sf:
    move $t0, $a0 # address of next byte to write
    move $t1, $a1 # address of current byte in input
    move $t2, $a2 # address of current char index
    move $t5, $a3 # size of array

    li $v0, 0 # number of characters in $t0

    null_cipher_sf_loop_a3_times:
        # check if we still need to read words
        beq $t5, $0, null_cipher_sf_done

        lb $t3, 0($t2) # grab the index we need
        
        # if the index is 0, we marked the word as handled and skip to next word
        beq $t3, $0, null_cipher_sf_loop_a3_times_skip_to_next_word

        # subtract 1 to get 0-indexed
        addi $t3, $t3, -1

        # shift left 2 times to multiply by 4 and get address offset
        # sll $t3, $t3, 2

        # apply offset on t1 to get address of the character we need to store
        add $t1, $t1, $t3

        # reuse t3 to store the character
        lb $t3, 0($t1)

        # store the character at the ouput address and move
        sb $t3, 0($t0)
        addi $t0, $t0, 1
        addi $v0, $v0, 1

        # t1 is currently the character we already read
        null_cipher_sf_loop_a3_times_skip_to_next_word:
            # move t1 so we can check next character
            addi $t1, $t1, 1

            # reuse t3 again to store the character
            lb $t3, 0($t1)

            # if t3 is space, the next letter is the new word
            li $t4, ' '
            beq $t3, $t4, null_cipher_sf_loop_update_pointers
            
            # check if t3 is null
            beq $t3, $0, null_cipher_sf_done
            
            j null_cipher_sf_loop_a3_times_skip_to_next_word
        null_cipher_sf_loop_update_pointers:
            addi $t1, $t1, 1
            addi $t2, $t2, 4
            addi $t5, $t5, -1
            j null_cipher_sf_loop_a3_times

    null_cipher_sf_done:
        # reuse t1 to store byte of t0
        lb $t1, 0($t0)

        # we check if we need to set null at the end
        beq $t1, $0, null_cipher_sf_done_actually
        sb $0, 0($t0)
    null_cipher_sf_done_actually:
        jr $ra

transposition_cipher_sf:

    jr $ra

decrypt_sf:

    jr $ra
