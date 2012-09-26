	; **********************************
	;  File: PrintText.s
	;  Programmer: I. Georgiev
	;  Description: A Program to ouput a text string immediately
	;               following the call
	;========Example: BL  Print
	;                 =   "Text to print", &0a,&0d,0
	;                 ALIGN
	;  Project: PrintText.arj               
	;  Date: October 2002
	;************************************
	
	AREA PrintText, CODE, READONLY
SWI_WriteC	EQU	&0     ;output character in r0 
SWI_Exit	EQU	&11    ;finish program
		ENTRY
	
		BL  Print	;call print subroutine
		=   "Text to print",&0a,&0d,0   
		ALIGN
		SWI 	SWI_Exit	;finish
Print		LDRB	r0,[r14], #1	;get a character
		CMP 	r0, #0		;end mark NUL?
		SWINE 	SWI_WriteC	;if not, print
		BNE	Print
		ADD	r14, r14, #3	; pass next word boundary
		BIC	r14, r14, #3	; round back to boundary
		MOV	pc, r14		;return
 		END	
;*****************************
;The program works and prints!
;***************************** 