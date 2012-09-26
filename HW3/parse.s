	AREA parse, CODE
SWI_WriteC	EQU 	&0	; Output character in r0
SWI_Exit	EQU	&11	; Exit the program
	ENTRY
start
	ADR	r5, INSTR	; Copy in pointer to string
	BL	print_string	; Call print string

	MOV	r2, INSTR	; r1= r0
parse
	LDRB	r1, [r2], #1	; r1= *r2; ++r2
	CMP	r1, #0		; Check for null ; Make previous line copy byte from adr
	BNE	parse_done	; While (char !null)
	BL	check_vowel	; Call check_vowel
	B	parse		; Loop back

parse_done
	ADR	r5, INSTR	; Load pointer for argument
	BL	print_string	; Print result
	SWI	SWI_Exit	; Exit the program
	

print_string
	LDRB 	r0, [r5], #1	; r0= *r5; ++r5; Store the value from the pointer r5 then increment r5
	CMP	r0, #0		; Check for null
	MOVEQ	pc, r14		; If null, Return ; r14 is special
	SWI	SWI_WriteC	; Print signal character in r0
	B	print_string	; Loop back

check_vowel
	TEQ	r1, 'a'		; r1 == 'a'
	TEQNE	r1, 'e'		; r1 == 'e'
	TEQNE	r1, 'o'		; r1 == 'o'
	TEQNE	r1, 'i'		; r1 == 'i'
	TEQNE	r1, 'u'		; r1 == 'u'
	TEQNE	r1, 'y'		; r1 == 'y'
	ADDEQ	r1, r1, #20	; Make uppercase
	ADDEQ	r7, r7, #1	; Increment word counter
	MOV	pc, r14		; Return



INSTR	=	"This is a soft test.", 0
;  OUTSTR	=	"                    ", 0
ALIGN
