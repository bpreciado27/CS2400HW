	; **********************************
	;  File:......
	;  Programmer: Chuck Domino 
	;  A Program to transfer string to string
	;  Project: ......                 
	;  Date
	;************************************
	
	AREA Blockcopy, CODE, READONLY
SWI_WriteC	EQU	&0     ;output character in r0 
SWI_Exit	EQU	&11    ;finish program
	ENTRY
	ADR	r1, TABLE1	;r1 points to TABLE1 
	ADR	r2, TABLE2	;r1 points toTABLE2
	ADR	r3, T1END	;r3 points to T1END
LOOP1	LDR	r0,[r1], #4	;get TABLE1 1st word
        STR	r0,[r2], #4	;copy into TABLE2
	CMP r1, r3		;finished??
	BLT LOOP1    		;if not, branch to loop body
	ADR r1,TABLE2	;r1 points to TABLE2
LOOP2	LDRB	r0,[r1],#1	; Get next byte
	CMP r0, #0		;check for text end
	SWINE SWI_Exit		; if not, print
	BNE	LOOP2		;finish
TABLE1	=	"This is the right string!",&0a, &0d,0
T1END
	ALIGN			;ensure word alignment
TABLE2	=	"This is the wrong string!", 0
	END