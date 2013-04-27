## This file is provided for your enjoyment.  Load both it and your debugged problem1.s
## into QtSpimbot and watch it go!

.text

# spimbot constants
ANGLE = 0xffff0014
ANGLE_CONTROL = 0xffff0018
TIMER = 0xffff001c
HEAD_X = 0xffff0020
HEAD_Y = 0xffff0024

PRINT_INT = 0xffff0080
PRINT_FLOAT = 0xffff0084

OTHER_BOT_HEAD_X = 0xffff00a0
OTHER_BOT_HEAD_Y = 0xffff00a4
PIVOT_NODES_X = 0xffff00c0						#
PIVOT_NODES_Y = 0xffff00c4						#
OTHER_PIVOT_NODES_X = 0xffff00c8				#
OTHER_PIVOT_NODES_Y = 0xffff00cc				#
PRIVATE_APPLE_X = 0xffff00b0
PRIVATE_APPLE_Y = 0xffff00b4

APPLE_QUERY = 0xffff0078
PUBLIC_APPLE_X = 0xffff0070
PUBLIC_APPLE_Y = 0xffff0074

REQUEST_PUZZLE = 0xffff0090
SUBMIT_PUZZLE = 0xffff0094

.globl main
main:
	sub	$sp, $sp, 16
	sw	$ra, 0($sp)
	sw	$s0, 0($sp)
	sw	$s1, 0($sp)
	
	li 	$s0, 1  # absolute angle
	li	$s1, 0  # prev_angle

iterate_apples:
	lw 	$a0, HEAD_X
	lw 	$a1, HEAD_Y
	sw 	$0,  APPLE_QUERY
	lw 	$a2, PUBLIC_APPLE_X
	lw 	$a3, PUBLIC_APPLE_Y
	
	jal	movement


	sub	$t0, $s1, $v0	     # prev_angle - angle
	abs	$t0, $t0	     # if the abs of angle diffs is 180
	bne	$t0, 180, set_direction	# then this would be a U-turn
	add	$t0, $v0, 90         # can't do U-turns
	sw 	$t0, ANGLE      # set angle to + 90
	sw 	$s1, ANGLE_CONTROL

	li	$t0, 2500	     # and wait ~5000 cycles
wait:	add	$t0, $t0, -1
	bne	$t0, $0, wait

set_direction:	
	sw 	$v0, ANGLE
	sw 	$s0, ANGLE_CONTROL
	move	$s1, $v0	     # remember previous direction
	
	j	iterate_apples


	# this code is never reached, but I'm showing it for good style.
	lw	$ra, 0($sp)
	lw	$s0, 0($sp)
	lw	$s1, 0($sp)
	add	$sp, $sp, 16

	jr	$ra
	
	
	
	
.text
.globl movement
movement:
	beq		$a0, $a2, melse_angle	#if (my_x != apple_x) {
	bge		$a0, $a2, mface_right	#  if (my_x < apple_x) {
	add		$v0, $0, $0				#Face left
	j 		return
	
mface_right:
	add 	$v0, $0, 180			#Face right
	j 		return					#
	
melse_angle:
	bge 	$a1, $a3, mface_down		#if (my_y < apple_y) {
	add 	$v0, $0, 90				# face up
	j 		return
	
mface_down:
	add 	$v0, $0, 270			# face down
	
return:
	jr		$ra						#return to the return address

.text
.globl whos_closer
whos_closer:
	
	jr $ra
	
	
	
	
	
.text
.globl puzzle_solver
puzzle_solver:
	
	jr $ra
	

