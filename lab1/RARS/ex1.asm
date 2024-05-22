.data
	str1:   .string "1qab9a0bcabcds13"
    	str2:   .string "bcds"

.macro push %a
	addi	sp, sp, -4
	sw 		%a, 0(sp) 
.end_macro

.macro pop %a
	lw 		%a, 0(sp) 
	addi	sp, sp, 4
.end_macro

.macro print %reg, %mode
    ori   a0, %reg, 0
    ori   a7, zero, %mode
    ecall
.end_macro

.text
MAIN:
	lui s0, 0x10010   # original string address
	addi s1, s0, 17   # pattern string address
	addi t4, s0, 0   
	addi t6, s1, 13   # signs the end of original str
	addi s0, s0, -1   # move s0 for program complement
	jal ra, find_substr
	ecall
	jal x0, END
find_substr:
	push s0
	push s1           # save registers into the stack
itering:
	addi s0, s0, 1
	addi t5, s0, 3
	beq s0, t6, failed
	
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
	ori a7, zero, 1
	sub a0, s0, t4
	jal zero, end
failed:
	ori a7, zero, 1
	ori a0, zero, -1
end:
	pop s1
	pop s0
	jalr zero, 0(ra)
END:

