	
	AREA PrintText, CODE, READONLY
		EXPORT	print_string
SWI_WriteC	EQU	&0     ;output character in r0 
SWI_Exit	EQU	&11    ;finish program

; print_string iterates through each character in the string and prints them.
; @arg r1 is address to the string
print_string
	LDRB 	r0, [r1], #1	; r0= *(r1++); Store the value from the pointer r5 then increment r5
	CMP	r0, #0		; Check for null
	MOVEQ	pc, r14		; If null, Return ; r14 is special
	SWI	SWI_WriteC	; Print single character in r0
	B	print_string	; Loop back
 		END	
;*****************************
;The program works and prints!
;***************************** 