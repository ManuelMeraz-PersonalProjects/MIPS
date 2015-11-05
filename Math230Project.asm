# Manuel Meraz ID:0665823
# Math 230
# Project 3
# Encryption/Descryption
# Last Revision: 11/1/2015


.data
#pre-made promp messages
Prompt_encDec:          .asciiz "Type 'e' to encrypt or 'd' to decrypt: "
Prompt_ChooseBitToggle:  .asciiz "Choose a bit to toggle (0-7): "
Prompt_AddKey:         .asciiz "Choose an addition key: "
Prompt_AskForText:      .asciiz "Enter text: "
encryptOutput:          .asciiz "Encrypted text: "
decryptOutput:          .asciiz "Decrypted text: "
invalid:		      .asciiz "Invalid input."
inputString:             .space 50    # reserve 50 bytes of memory for the inout string 


#inputs
INBUFFER:    .byte 0xff:100 #filling memory with this to make it easy to see

#outputs 
OUTBUFFER:   .byte 0xee:100 #filling memory with this to make it easy to see

.text

#macros
.macro newline
    # makes new line
    li $v0, 11
    li $a0, 10    # read in new line 10 = newline ascii
    syscall
.end_macro

.macro getInput
    # gets input data from user to decrypt or encrypt
    jal getAddKey
    add $s0, $v0, $0      # save result to $s0 <--- addition key
    jal getChooseBitToggle
    add $s1, $v0, $0      # save result to $s1  <--- bit to toggle
    jal getAskForText
    la  $s2, inputString  # save result to $s2 <--- string to encrypt ot decrypt
    
    la $t0, ($s0)   # load addition key to temp
    la $t1, ($s1)   # load bit to toggle to temp
    la $t2, ($s2)   # load input text to temp
.end_macro

MAIN:
    # prompt user to input 'e' or 'd'
    li $v0, 4
    la $a0, Prompt_encDec
    syscall

    # read encrypt or decrypt choice
    li $v0, 12    	# set syscall to read char
    syscall
    add $t0, $v0, $0	# store returned value
    newline

    #jump to encrypt if 'e' or 'E' entered
    beq $t0, 101, ENCRYPT    # lower case e
    beq $t0  69, ENCRYPT     # upper case E
    #jump to decrypt if 'd' or 'D' entered
    beq $t0, 100, DECRYPT    # lower case d
    beq $t0, 68, DECRYPT     # upper case D

INVALID:
    li $v0, 4		# notifies if invalid input
    la $a0, invalid
    syscall
    newline
    j MAIN
 
ENCRYPT:
    getInput
    
    while1:
    lb   $t3, 0($t2)         # load character
    beq  $t3, 10, ENCRYPTED  # checks for new line. If end of string, continue
    
    add  $t3, $t3, $t0    # add addition key to character
    addi $t4, $0, 1       # create a number 2^0
    sllv $t4, $t4, $t1    # shift new number to the left by the value in bit to toggle
    xor  $t3, $t3, $t4    # toggle the bit
    
    sb   $t3, 0($t2)      # put the encrypted character back in the array
    addi $t2, $t2, 1      # move to the next character in the array 
    j while1

     ENCRYPTED:
     
     li $v0, 4               # Print out encrypted text
     la $a0, encryptOutput
     syscall
     la $a0, ($s2)
     syscall
     
    j EXIT
    
DECRYPT:
    getInput
    
    while2:
    lb   $t3, 0($t2)         # load character
    beq  $t3, 10, DECRYPTED  # checks for new line. If end of string, continue
    
    addi $t4, $0, 1       # create a number 2^0
    sllv $t4, $t4, $t1    # shift new number to the left by the value in bit to toggle
    xor  $t3, $t3, $t4    # toggle the bit  
    sub  $t3, $t3, $t0    # subtract addition key to character
    
    sb   $t3, 0($t2)      # put the encrypted character back in the array
    addi $t2, $t2, 1      # move to the next character in the array 
    j while2

     DECRYPTED:
     
     li $v0, 4               # Print out decrypted text
     la $a0, decryptOutput
     syscall
     la $a0, ($s2)
     syscall
     
    j EXIT
    
# functions
getAddKey:
    li $v0, 4
    la $a0, Prompt_AddKey
    syscall  			# display prompt
    li $v0, 5
    syscall    			# read in int
    sle $t0, $v0, 9		# check if input is valid
    beq $t0, 0, INVALID
    sge $t0, $v0, 0
    beq $t0, 0, INVALID
    jr $ra

getChooseBitToggle:
    li $v0, 4
    la $a0, Prompt_ChooseBitToggle
    syscall    			# display prompt
    li $v0, 5
    syscall   			# read in int
    sle $t0, $v0, 7		# check if input is valid
    beq $t0, 0, INVALID
    sge $t0, $v0, 0
    beq $t0, 0, INVALID
    jr $ra

getAskForText:
    li $v0, 4
    la $a0, Prompt_AskForText
    syscall
    li $v0, 8
    la $a0, inputString
    
    lb $t0, 0($a0)
    
    li $a1, 48
    syscall
    jr $ra
    
EXIT:
