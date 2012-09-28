	AREA parse, CODE
SWI_WriteC	EQU 	&0	; Output character in r0
SWI_Exit	EQU	&11	; Exit the program

	ENTRY
start
	ADR	r1, STR1	; Copy in pointer to string
	BL	print_string	; Call print string

	MOV	r7, #0		; Set r7= 0
	ADR	r2, STR1	; void* r2= address of STR1
parse1
	LDRB	r1, [r2], #1	; byte r1= *r2; ++r2
	CMP	r1, #0		; Check for null
	BEQ	parse_done	; While (char !null)
	BL	check_vowel	; Call check_vowel
	B	parse1		; Loop back

parse_done
	ADR	r1, STR1	; void* r1= &STR1; Load pointer for argument
	BL	print_string	; Print result
	ADR	r1, MSG1	; Load message pointer
	BL	print_string	; Call print string
	BL	hex_encode	; Print count of the vowels in hex code

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
	MOVEQ	r3, #'*'	; test
	MOVNE   r3, r1
	SUB	r4, r2, #1	; void* r4= r2 - 1

	STRB	r3, [r4]
;	ADDEQ	r3, r1, #&20	; r3= r1 + 0x20 ; Make uppercase
;	STREQ  	r3, [r2]	; r2= r3
	ADDEQ	r7, r7, #1	; Increment vowel counter

	TEQ	r1, #'A'	; r1 == 'A'
	TEQNE	r1, #'E'	; r1 == 'E'
	TEQNE	r1, #'I'	; r1 == 'I'
	TEQNE	r1, #'0'	; r1 == 'O'
	TEQNE	r1, #'U'	; r1 == 'U'
	TEQNE	r1, #'Y'	; r1 == 'Y'
	ADDEQ	r7, r7, #1	; Increment vowel counter

	MOV	pc, r14		; Return

; @arg r7
hex_encode
	ADR	r0, LOWNIB	; void* r0= &LOWNIB; Get the address of LOWNIB
	LDR	r0, [r0]	; int r0= *r0; Get the value from the address in r0
	AND	r5, r7, r0	; char r5= r7 & *r0; Get the low nibble
	ADR	r0, HEXCODE	; void* r0= &HEXCODE; Get the address of HEXCODE
	ADD	r0, r5, r0	; r0+= r5 ; Treat the address of HEXCODE like an array
	LDR	r0, [r0]	; char r0= *r0
	SWI	SWI_WriteC	; Print signal character in r0
	MOV	pc, r14		; Return
 
LOWNIB	DCB	&0F,&00
STR1	DCB	"This is a soft test.", 0
HEXCODE DCB	"0123456789ABCDEF", 0
MSG1	DCB	"This sentence had this many vowels: ",0

;  OUTSTR	=	"                    ", 0
	ALIGN
	END
