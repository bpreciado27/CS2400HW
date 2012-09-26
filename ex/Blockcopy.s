	; **********************************
	;  File: Blockcopy.s
	;  Programmer: I. Georgiev
	;  Description: A Program to transfer string to string
	;               word (4 bytes) after a word.
	;  Project: TABLE1.arj.                
	;  Date: October 2002
	;************************************
	
	AREA Blockcopy, CODE, READONLY
SWI_WriteC	EQU	&0     ;output character in r0 
SWI_Exit	EQU	&11    ;finish program
	ENTRY
	ADR	r1, STRING1	;r1 points to STRING1
	ADR	r2, STRING2	;r1 points to STRING2
	ADR	r3, T1END	;r3 points to T1END
LOOP1	LDR	r0,[r1], #4	;get TABLE1 1st word
        STR	r0,[r2], #4	;copy into TABLE2
	CMP 	r1, r3		;finished??
	BLT 	LOOP1    	;if not, branch to loop body
	ADR 	r1,STRING2	;r1 points to TABLE2
LOOP2	LDRB	r0,[r1],#1	; Get next byte
	CMP 	r0, #0		;check for text end
	SWINE 	SWI_WriteC	;if not, print
	BNE	LOOP2		;... and loop back
	SWI 	SWI_Exit	;finish
STRING1	=	"CSI2400 ARM loop-oriented programming style!",&0a, &0d,0
T1END
	ALIGN			;ensure word alignment
STRING2	DCB	"This is the wrong string! Must be replaced!?",&0a, &0d,0
	END
;*****************************
;The program works and prints!
;***************************** 