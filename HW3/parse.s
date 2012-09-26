	AREA parse, CODE
SWI_WriteC	EQU 	&0	; Output character in r0
SWI_Exit	EQU	&11	; Exit the program

	ENTRY
start
	ADR	r1, STR1	; Copy in pointer to string
	BL	print_string	; Call print string

	ADR	r2, STR1	; r2= address of STR1
parse1
	LDRB	r1, [r2], #1	; byte r1= *r2; ++r2
	CMP	r1, #0		; Check for null ; Make previous line copy byte from adr
	BEQ	parse_done	; While (char !null)
	BL	check_vowel	; Call check_vowel
	B	parse1		; Loop back

parse_done
	ADR	r1, STR1	; Load pointer for argument
	BL	print_string	; Print result
	SWI	SWI_Exit	; Exit the program
	

print_string
	LDRB 	r0, [r1], #1	; r0= *r5; ++r5; Store the value from the pointer r5 then increment r5
	CMP	r0, #0		; Check for null
	MOVEQ	pc, r14		; If null, Return ; r14 is special
	SWI	SWI_WriteC	; Print signal character in r0
	B	print_string	; Loop back

check_vowel
	TEQ	r1, #'a'	; r1 == 'a'
	TEQNE	r1, #'e'	; r1 == 'e'
	TEQNE	r1, #'o'	; r1 == 'o'
	TEQNE	r1, #'i'	; r1 == 'i'
	TEQNE	r1, #'u'	; r1 == 'u'
	TEQNE	r1, #'y'	; r1 == 'y'
	ADDEQ	r2, r2, #20	; Make uppercase
	ADDEQ	r7, r7, #1	; Increment vowel counter

	TEQ	r1, #'A'	; r1 == 'A'
	TEQNE	r1, #'E'	; r1 == 'E'
	TEQNE	r1, #'I'	; r1 == 'I'
	TEQNE	r1, #'0'	; r1 == 'O'
	TEQNE	r1, #'U'	; r1 == 'U'
	TEQNE	r1, #'Y'	; r1 == 'Y'
	ADDEQ	r7, r7, #1	; Increment vowel counter

	MOV	pc, r14		; Return


STR1	DCB	"This is a soft test.", 0
;  OUTSTR	=	"                    ", 0
	ALIGN
	END
