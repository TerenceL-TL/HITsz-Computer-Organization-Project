.data
	next: .string "\n"

.macro push %a
	addi	sp, sp, -4
	sw 		%a, 0(sp) 
.end_macro

.macro pop %a
	lw 		%a, 0(sp) 
	addi	sp, sp, 4
.end_macro

.macro print %reg, %mode
	push  a0
    	ori   a0, %reg, 0
    	ori   a7, zero, %mode
    	ecall
    	pop   a0
.end_macro

.macro input %reg, %mode
	push  a0
	ori   a7, zero, %mode
    	ecall
    	or   %reg, zero, a0
    	pop   a0
.end_macro

.macro inputstr %reg, %max
	push  a0
	push  a1
	ori   a7, zero, 8
	ori   a1, zero, %max
	or   a0, zero, %reg
    	ecall
    	pop   a1
    	pop   a0
.end_macro

.text
MAIN:
	lui s8, 0x10010 
	addi s0, s8, 2# origin address
	addi s1, s0, 64 # pattern address
	input s2, 5
	inputstr s0, 63
	input s3, 5
	inputstr s1, 63
	push a0 # save for return
	push a1 # save function param registers by caller
	push a2
	push a3
	push a4
	add a1, zero, s0
	add a2, zero, s1
	add a3, zero, s2
	add a4, zero, s3
	jal ra, find_substr
	pop a4
	pop a3
	pop a2
	pop a1 # retrive
	# addi s4, a0, 0 # save to s4
	pop a0
	# print s4, 1
	jal zero, END
find_substr: # a1 as str, a2 as pattern, a3 as len1, a4 as len2
	push s0
	push s1
	push s2 # save saved registers by callee
	ori t4, zero , 0
	addi s0, a1, 0
	addi s1, a2, 0
	sub  t6, a3, a4
	addi t6, t6, 1
	add s2, s0, t6   # signs the end of original str complement
	addi s0, s0, -1
itering:
	addi s0, s0, 1
	add t5, s0, a4
	addi t5, t5, -1
	beq s0, s2, failed
	
	addi t0, s0, 0
	addi t1, s1, 0
loop:
	lb t2, 0(t0)
	lb t3, 0(t1)
	bne t2, t3, itering
	beq t0, t5, found
	addi t0, t0, 1
	addi t1, t1, 1
	jal zero, loop
found:
	sub a0, s0, a1
	print a0, 1
	print s8, 4
	ori t4, zero, 1
	jal zero, itering
failed:
	ori a0, zero, -1 # a0 as return
	bne t4, zero, end
	print a0, 1
end:
	pop s2
	pop s1
	pop s0
	jalr zero, 0(ra)
END:
	
	
	

