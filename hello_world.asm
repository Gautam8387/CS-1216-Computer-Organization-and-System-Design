# A simple MIPS program to print "Hello World!" in MARS

.data  	# to specify the data segment, and initiate variable
message: .asciiz "Hello World!"  	# store the string in Data Segment and have a null character termination

.text # this segment will have actual statements and instructions

# System calls: predefined functions that MIPS has to input-output stuff

# Print the string "Hello World!"
# $a0 acts as the argument to syscall instruction
la $a0, message 	# put the stating adress of string in register $a0
li $v0, 4		# initiate $v0 = 4, which tells syscall to pint a string
syscall

# Terminate the program
li $v0, 10
syscall



