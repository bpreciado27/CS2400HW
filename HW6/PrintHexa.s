	; **********************************
	;  File: PrintHexa.s
	;  Programmer: I. Georgiev
	;  Description: A Program to print a register in hexadecimal form
	;               in hexadecimal form
	;  Project: PrintHexa.arj               
	;  Date: October 2002
	;************************************
	
	AREA PrintHexa, CODE, READONLY
	EXPORT	printhexa
SWI_WriteC		EQU 	&0			; Software interupt will write character in r0 to output
	ALIGN
printhexa	MOV	r2,#8		;count of nibbles = 8
LOOP	MOV	r0,r1,LSR #28	;get top nibble
	CMP 	r0, #9		;hexanumber 0-9 or A-F
	ADDGT 	r0,r0, #"A"-10	;ASCII alphabetic
	ADDLE 	r0,r0, #"0"	;ASCII numeric
	SWI 	SWI_WriteC	; print character
	MOV	r1,r1,LSL #4	;shift left one nibble
	SUBS	r2,r2, #1	;decrement nibble count
	BNE	LOOP		;if more nibbles,loop back
	MOV 	pc, r14		;return

	END
;*****************************
;The program works and prints!
;***************************** 