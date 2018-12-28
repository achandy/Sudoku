#Allan Chandy & Nihar Junagade
#CISC323

.data
newline:.asciiz "\n"		# useful for printing commands
star:	.asciiz "*"
board1: .word 128 511 511 16 511 511 4 2 511 64 511 4 1 511 511 8 511 511 1 2 511 511 511 256 511 511 128 32 16 511 511 256 4 511 128 511 511 256 511 511 511 511 511 1 511 511 128 511 32 2 511 511 256 4 2 511 511 8 511 511 511 32 64 511 511 32 511 511 128 1 511 2 511 64 8 511 511 32 511 511 16
board2: .word 128 8 256 16 32 64 4 2 1 64 32 4 1 128 2 8 16 256 1 2 16 4 8 256 32 64 128 32 16 1 64 256 4 2 128 8 4 256 2 128 16 8 64 1 32 8 128 64 32 2 1 16 256 4 2 1 128 8 4 16 256 32 64 16 4 32 256 64 128 1 8 2 256 64 8 2 1 32 128 4 16
	
.text
# main function
main:
	sub  	$sp, $sp, 4
	sw   	$ra, 0($sp) # save $ra on stack

	# test singleton (true case)
	li	$a0, 0x010
	jal	singleton
	move	$a0, $v0
	jal	print_int_and_space
	# this should print 1

	# test singleton (false case)
	li	$a0, 0x10b
	jal	singleton
	move	$a0, $v0
	jal	print_int_and_space
	# this should print 0

	# test get_singleton 
	li	$a0, 0x010
	jal	get_singleton
	move	$a0, $v0
	jal	print_int_and_space
	# this should print 4

	# test get_singleton 
	li	$a0, 0x008
	jal	get_singleton
	move	$a0, $v0
	jal	print_int_and_space
	# this should print 3

	# test board_done (true case)
	la	$a0, board2
	jal	board_done
	move	$a0, $v0
	jal	print_int_and_space
	# this should print 1
	
	# test board_done (false case)
	la	$a0, board1
	jal	board_done
	move	$a0, $v0
	jal	print_int_and_space
	# this should print 0

	# print a newline
	li	$v0, 4
	la	$a0, newline
	syscall	

	# test print_board
	la	$a0, board1
	jal	print_board

	# should print the following:
	# 8**5**32*
	# 7*31**4**
	# 12***9**8
	# 65**93*8*
	# *9*****1*
	# *8*62**93
	# 2**4***67
	# **6**81*2
	# *74**6**5

	lw   	$ra, 0($sp) 	# restore $ra from stack
	add  	$sp, $sp, 4
	jr	$ra

print_int_and_space:
	li   	$v0, 1         	# load the syscall option for printing ints
	syscall              	# print the element

	li   	$a0, 32        	# print a black space (ASCII 32)
	li   	$v0, 11        	# load the syscall option for printing chars
	syscall              	# print the char
	
	jr      $ra          	# return to the calling procedure

print_newline:
	li	$v0, 4		# at the end of a line, print a newline char.
	la	$a0, newline
	syscall	    
	jr	$ra

print_star:
	li	$v0, 4		# print a "*"
	la	$a0, star
	syscall
	jr	$ra
	
	
# ALL your code goes below this line.
#
# We will delete EVERYTHING above the line; DO NOT delete 
# the line.
#
# ---------------------------------------------------------------------
	
## bool singleton(int value) {  // This function checks whether
##   return (value != 0) && !(value & (value - 1));
## }
singleton:
	addi $sp, $sp, -8 #Moves the stack pointer
	sw $ra, 1($sp) #Stores ra register
	sw $a0, 4($sp) #value variable

	addi $t0, $a0, -1 #temporary variable for value - 1
	and $t1, $a0, $t0 #temporary variable for value & value - 1
	beq $a0, $1, end_singleton #if statement to check if value is true
	beq $t1, $1, end_singleton #if statement to check if t1 variable is true
	li $v0, 1 #returns true
	j Exit
end_singleton:
	li $v0, 0; #returns false
	j exit
exit:
	lw $ra, 0($sp) #load word
	lw $a0, 4($sp)
	addi $sp, $sp, 8 #moves the stack pointer back
	jr $ra



## int get_singleton(int value) {
##   for (int i = 0 ; i < GRID_SQUARED ; ++ i) {
## 	 if (value == (1<<i)) {
## 		return i;
## 	 }
##   }
##   return 0;
## }

get_singleton:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $a0, 4($sp)

	li $s1, 0	#initialize i
	li $s2, 9	#initialize grid squared
	li $v0, 0	#initalizes v0
	j get_singleton_loop	#jumps to for loop
get_singleton_loop:
	bgt $s1, $s2, exit1	#if i is greater than grid squared then loop exits
	sll $t1, 1, $s1 #shifts bit left
	beq $a0, $t1, end_get_singleton #if bits equal go to end_get_singleton
	addi $s1, $s1, 1	#increments i
	j gt_sigleton_Loop	
end_get_singleton:
	addi $v0, $s1, 0;	#returns i
	j Exit1
exit:
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	addi $sp, $sp, 8
	jr	$ra


## bool
## board_done(int board[GRID_SQUARED][GRID_SQUARED]) {
##   for (int i = 0 ; i < GRID_SQUARED ; ++ i) {
## 	 for (int j = 0 ; j < GRID_SQUARED ; ++ j) {
## 		if (!singleton(board[i][j])) {
## 		  return false;
## 		}
## 	 }
##   }
##   return true;
## }

board_done:
	addi $sp, $sp, -8     
	sw $ra, 0($sp)         
	sw $a0, 4($sp)        
	li $s0, 0   #iniatilize i
	li $s1, 0   #initialize j
	li $s2, 0	
	j for_outter	#jumps to outter for loop

for_outter:
	bgt $s0, 9, Exit2   #if i greater than 9 then exits outter for loop
	addi $s0, $s0, 1    # increments i
	li $s1, 0           #sets j to 0
	j for_inner         #goes to inner for loop

for_inner:
	bgt $s1, 9, for_outter   #goes to outter for loop if j greater than 9
	jal singleton       #call singleton
	addi $s2, $v0, 0    #sets s2 to return from singleton
	beq $s2, $0, end_board   #if returned is false then returns false
	addi $s1, $s1, 1    #increment j
	j for_inner

end_board:
	li $v0, 0            #returns false
	j Exit3             
	
Exit2:
	li $v0,1             #returns true if exits outter loop
	j Exit3              

Exit3:
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	addi $sp, $sp, 8 
	jr $ra
	
## void
## print_board(int board[GRID_SQUARED][GRID_SQUARED]) {
##   for (int i = 0 ; i < GRID_SQUARED ; ++ i) {
## 	 for (int j = 0 ; j < GRID_SQUARED ; ++ j) {
## 		int value = board[i][j];
## 		char c = '*';
## 		if (singleton(value)) {
## 		  c = get_singleton(value) + '1';
## 		}
## 		printf("%c", c);
## 	 }
## 	 printf("\n");
##   }
## }

print_board:
	addi $sp, $sp, -8     
	sw $ra, 0($sp)         
	sw $a0, 4($sp)        
	li $s0, 0             #iniatilize i
	li $s1, 0             #initialize j
	li $s2, 0
	li $t0, 0
	j For_outter

print_inner:
	bgt $s0, 9, print_newline #if i greater than 9 then print new line
	addi $s0, $s0, 1 #add 1 to i
	li $s1, 0	
	j print_outter

print_outter:
	bgt $s1, 9, print_inner      
	addi $t0, $a0, 0     
	addi $t1, $0, *       #t1 set to *
	#add an if statement here for singleton by adding jal singleton
	jal get_singleton     #calls get_singleton
	add $s2, $v0, $0      #s2 is set to get+singleton
	beq $a0, 0, print_star #print star
	addi $t1, s2, 1       #get singleton + 1
	addi $s1, $s1, 1      ##increment j
	j print_outter

EndA:
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	addi $sp, $sp, 8 
	jr $ra