.text
null_cipher_sf:
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
        # reuse a1 to store byte of a0
        lb $a1, 0($a0)

        # we check if we need to set null at the end
        beq $a1, $0, null_cipher_sf_done_actually
        sb $0, 0($a0)
    null_cipher_sf_done_actually:
        jr $ra

transposition_cipher_sf:
    
    jr $ra

decrypt_sf:

    jr $ra
