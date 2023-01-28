.data 		# To specify the data segment, and initiate variables
inputPrompt:       .asciiz "Enter String: "
printTrue:	   .asciiz "Yes, the string is a palindrome."
printFlase:	   .asciiz "No, the string is not a palindrome."
printError:	   .asciiz "Invalid Input" 
nextLine:	   .asciiz "\n"
strLength: 	   .space 250 		# Reserving Enough Space for sentences  

# If we declare size of string as 50, we can only input 49 characters. Last is reserved for NULL \0

.text 
############### Main Section ###############
main:
	# Print the Prompt
	la $a0, inputPrompt
	li $v0, 4
	syscall
	# Input string
	li $v0, 8
	la $a0, strLength
	li, $a1, 250
	syscall
	
#### Set $s0 and $s1 the starting and ending address of string ####

	# $a0 contains the starting address of String
	move $s0, $a0 		# register $s0 containst the start address of string
	move $s1, $a0		# register $s1 WILL containst the end address of string, B=A
	# loop to set $s1 to end address of string
	endAddressLoop:
		lb $t0, 0($s1)
		beq $t0, $zero, endAddress		# if (*B == 0) 
		addi $s1, $s1, 1		# B = B + 1
		j endAddressLoop
	# move B back past the 0 and the newline
	endAddress:
		sub $s1, $s1, 2   	# B = B - 2 
	# Register $s0 and $s1 now store the start and end address of string	
	
#### Remove Trailing Spaces ####

	# Remove space from staring of the string
	frontSpace: 
		lb $t0, 0($s0)
		bne $t0, 32, backSpace
		add $s0, $s0, 1
		j frontSpace 
	# Remove space from end of the string	
	backSpace:
		lb $t0, 0($s1)
		bne $t0, 32, noSpace
		sub $s1, $s1, 1
		j backSpace
	# ALL Tralling Spcaes Removed 
	noSpace:
	# Register $s0 and $s1 now store the start and end address of string after removal of trailing spaces
		
#### Checking the Validity of the String and Converting Lowercase to UPPERCASE####
	
	sub $t0, $s1, $s0
	bgt $t0, 49, errorSection	# if the difference is more than 49, string length is more than 50, which is error
	li $t0, 0			# counter set to zero
	checkUpper:
		add $t1, $s0, $t0 	# setting $t1 to current i-th address in string
		lb $t2, 0($t1)		# load the character value in $t2 at i-th position in string
		beq $t2, 0, endCheck 	# NULL character is found, end condition
		beq $t2, 10, endCheck 	# New Line is found, end condition
		beq $t2, 32, spaceFound # Internal Space is found
		blt $t2, 65, errorSection  # If a ASCII character is found before 65 (capital alphabets), invalid character in string
		bgt $t2, 90, checkLower    # check If a ASCII character is found after 90, check if it is lowercase capital alphabet
		addi $t0, $t0, 1	   # increment the counter
		j checkUpper
	# check if the character falls between boundries of lower alphabets in ASCII 
	checkLower:
		li $t3, 122
		slti $t4, $t2, 97 		# check is ASCII < 92
		slt $t5, $t3, $t2		# check is 122 < ASCII
		or $t6, $t4, $t5		# $t5 = $t3 OR $t4 ; if $t5 = 0 the ASCII is in lower case range
		beq $t6, 1, errorSection
		#### Convert to Upper Case if Lower-Case Confirmed####
		addi $t2, $t2, -32		# Convert lower-case to UPPER-CASE
		sb $t2, 0($t1)			# store the character value of UPPER-CASE of $t2 at i-th position in string
		add $t0, $t0, 1
		j checkUpper	
	spaceFound:
		addi $t0, $t0, 1
		j checkUpper
	endCheck:

#### Palindrome Checker ####
	checkPalindrome:
		bge $s0, $s1, resultTrue 		# If A>=B, String is a Palindrome
		lb $t0, 0($s0)				# Load the value of *A[i] in $t0
		lb $t1, 0($s1)				# Load the value of *B[i] in $t1
		bne $t0, $t1, resultFalse 		# If *A!=*B, not a plaindrome
		addi $s0, $s0, 1
		addi $s1, $s1, -1
		j checkPalindrome

############### Result Section ###############
# Print result message and terminate the program
resultTrue:
	la $a0, printTrue
	li $v0, 4
	syscall
	j Exit

resultFalse:
	la $a0, printFlase
	li $v0, 4
	syscall
	j Exit
	
############### Error Section ###############
# Print Error message and terminate the program
errorSection:
	la $a0, printError
	li $v0, 4
	syscall
	j Exit

############### Termination ###############
Exit:
	li $v0, 10

