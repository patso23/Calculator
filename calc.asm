#Patrick O'Shea
#CS-402
#Calculator project



	.data
	operation1:	.word 0
	operand1:	.word 0
	operand2:	.word 0
	operation2:	.word 0
	operand3:	.word 0
	priority:	.word 0

	msg1:	.asciiz	"\nPlease enter 1st operand: "
	msg2:	.asciiz "Please enter 1st operation (1 = +, 2 = -, 3 = *, 4 = /): "
	msg3:	.asciiz "Please enter 2nd operand: "
	msg4:	.asciiz "Please enter 2nd operation (1 = +, 2 = -, 3 = *, 4 = /): "
	msg5:	.asciiz "Please enter 3rd operand: "
	msg6:	.asciiz "Which operation should have precedence? (1, 2 or 0 for default precedence): "
	msg7:	.asciiz "The result is: "
	
	
	.text
	.globl main

main:
		#get 1st operation
		li $v0, 4			#system call for print str
		la $a0,msg1			#addr of string to print
		syscall

		li $v0, 5 			#read 1st operand
		syscall
		sw $v0, operand1		
		

		#get 1st operand
		li $v0, 4
		la $a0, msg2
		syscall
	
		li $v0, 5			#read 1st operation
		syscall		
		sw $v0, operation1
		
		
		#get 2nd operand
		li $v0, 4
		la $a0, msg3
		syscall

		li $v0, 5
		syscall
		sw $v0, operand2

		#get 2nd operation
		li $v0, 4
		la $a0, msg4
		syscall

		li $v0, 5
		syscall
		sw $v0, operation2

		#get 3rd operand
		li $v0, 4
		la $a0, msg5
		syscall
	
		li $v0, 5
		syscall
		sw $v0, operand3

		#get operation priority
		li $v0, 4
		la $a0, msg6
		syscall

		li $v0, 5
		syscall
		sw $v0, priority
		

		#put operations and operands into $t0-$t5
		lw $t0, operation1
		lw $t1, operand1
		lw $t2, operand2
		lw $t3, operation2
		lw $t4, operand3
		lw $t5, priority

		
		#determine which priority to use
		

		#default operation priority
		beq $t5, 0, default

		#1st operation priority
		beq $t5, 1, first

		#2nd operation priority
		beq $t5, 2, second


		
		li	$v0, 10		# system call code for exit = 10
		syscall	

default:			
		beq $t0, 3, first
		beq $t0, 4, first
		beq $t3, 3, second
		beq $t3, 4, second


first:		

		#perform operation1 on operand1 and operand2
		#set priority to 1 for default operations
		li $t5, 1
		move $a0, $t1
		move $a1, $t2	
		beq $t0, 1, addit1
		beq $t0, 2, subtr1
		beq $t0, 3, multi1
		beq $t0, 4, divis1
first2:
		#perform operation2 on result and operand3
		#place operand in $a1
		move $a1, $t4
				
		beq $t3, 1, addit2
		beq $t3, 2, subtr2
		beq $t3, 3, multi2
		beq $t3, 4, divis2

		j Exit

		

second:		#perform operation2 on operan2 and operand3
		#set priority to 2 for default operations
		li $t5, 2
		move $a0, $t2
		move $a1, $t4
		beq $t3, 1, addit2
		beq $t3, 2, subtr2
		beq $t3, 3, multi2
		beq $t3, 4, divis2	
second2:
		#perform operation 1 on operand1 and result 
		move $a1, $a0	#puts result into $a1
		move $a3, $a0	#saves result in case it's lost on 2nd pass
		move $a0, $t1
		beq $t0, 1, addit1
		beq $t0, 2, subtr1
		beq $t0, 3, multi1
		beq $t0, 4, divis1		 

		move $a0, $a3	#retains result
		j Exit

		
addit1:		
		#place the operands in $a0 and $a1
		#reset operation
		li $t0, 0
		jal addition

		
		
addit2:		
		#place the operands in $a0 and $a1
		#reset operation
		li $t3, 0
		
		jal addition
		
	
subtr1:		#place the operands in $a0 and $a1
		#reset operation
		li $t0, 0
		
		jal subtraction
	

subtr2:		#place the operands in $a0 and $a1
		#reset operation
		li $t3, 0
		
		jal subtraction
		

multi1:		#place the operands in $a0 and $a1
		#reset operation
		li $t0, 0
		
		jal multiplication
		

multi2: 	#place the operands in $a0 and $a1
		#reset operation
		li $t3, 0
		
		jal multiplication
		

divis1:		#place the operands in $a0 and $a1
		#reset operation
		li $t0, 0
		
		jal division
		
		
divis2:  	#place the operands in $a0 and $a1
		#reset operation
		li $t3, 0
		
		jal division

		
addition:
		#take the operands perform addition
		add $a0, $a0, $a1
		
		beq $t5, 1, Jumpfirst
		beq $t5, 2, Jumpsecond


subtraction:	#take the operands perform subtraction
		sub $a0, $a0, $a1
		

		beq $t5, 1, Jumpfirst
		beq $t5, 2, Jumpsecond


multiplication:  #take the operands perform multiplication
		mult $a0, $a1
		mflo $a0

		beq $t5, 1, Jumpfirst
		beq $t5, 2, Jumpsecond


division:	#take the operands perform division
		div $a0, $a0, $a1
		
		beq $t5, 1, Jumpfirst
		beq $t5, 2, Jumpsecond


Jumpfirst:
		j first2


Jumpsecond:
		j second2


Exit:  		##prints result
		move $v1, $a0
		li $v0, 4
		la $a0, msg7
		syscall
		li $v0, 1
		move $a0, $v1
		syscall
	
		#jumps back to main
		j main

		
