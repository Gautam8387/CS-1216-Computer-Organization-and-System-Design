# CS1216 Homwwrok_3 Gautam Ahuja
# Question 4
# A MIPS assembly program that takes an integer as input, validates it to be greater than 0 and prints the sum of squares up to that number
# The program uses two methods:
# 1. Naive: A loop which iterates over and stores the sum of squares
# 2. Interesting: It uses the formulae ((n)*(n+1)*(2n+1))/6 to calculate sum of squares of natural numbers upto n (input)


.data 		# To specify the data segment, and initiate variables
inputPrompt:       .asciiz "Enter N: "
printNaive:        .asciiz "Naive: "
printInteresting:  .asciiz "\nInteresting: "
printError:	   .asciiz "Input is erroneous" 

.text 	# This Segment Will Have Actual Statements and Instructions

main: 
	# Print the statement "Enter N: "
	la $a0, inputPrompt
	li $v0, 4
	syscall 
	# Input an integer
	li $v0, 5
	syscall
	# Value of N is stored in $s0
	move $s0, $v0 
	# Checking if N > 0 
	blt $s0, 1, errorSection
	
	##### Naive Section ####
	move $a0, $s0
	jal Naive
	# Return Value of Naive is stored in $t1 
	move $t1, $v0 
	# Print Naive Result
	la $a0, printNaive
	li $v0, 4
	syscall
	move $a0, $t1
	li $v0, 1
	syscall
	
	##### Interesting Section ####
	move $a0, $s0
	jal Interesting
	# return value of Interesting is stored in $t2
	move $t2, $v0 
	# Print Interesting Result
	la $a0, printInteresting
	li $v0, 4
	syscall
	move $a0, $t2
	li $v0, 1
	syscall
	
	#### Terminate Program ####	
	j Exit

############### Naive Section ##############
	# The argument $a0 contains the input number N
Naive:
	li $s1, 0  	# Stores Sum
	li $t1, 1 	# initiating i=1
	Loop:
		bgt $t1, $a0, endNaive  # if i>N  exit the loop
		mult $t1, $t1 		# calculated i^2
		mflo $t2 		# $t2 = i^2
		addu $s1, $s1, $t2 	# sum = sum + i^2
		addi $t1, $t1, 1
		j Loop
	endNaive:
		move $v0, $s1 		# return register contains the calculated result
		jr $ra			# control flow moves back to address in $ra


############### Interesting Section ##############
Interesting:
	# The argument $a0 contains the input number N
	move $t1, $a0	
	addiu $t1, $t1, 1	# (n+1)
	move $t2, $a0		# n
	mul $t2, $t1, $t2	# $t2 = n*(n+1)
	move $t3, $a0		
	sll $t3, $t3, 1		# 2*n
	addiu $t3, $t3, 1	# 2*n + 1
	mul $t3, $t3, $t2 	# $t3 = (2*n+1)*n*(n+1)
	li $t4, 6		# $t4 = 6
	div $t3, $t4		# lo = (2*n+1)*n*(n+1) / 6
	mflo $v0		# return register contains the calculated result
	jr $ra			# control flow moves back to address in $ra

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
	syscall
