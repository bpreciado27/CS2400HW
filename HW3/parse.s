;*****************************************************************************
; File: parse.s
; Programmer: Josh Gillham
; Description:
;	Takes the string in STR1 and analyses it. Modifies the
; string while analysing to replace the lower case vowels with
; upper case corresponding letters. Prints the count of vowel
; letters at the end of the program.
;
; Project: HW3
; Date: 9-28-12
;******************************************************************************


	AREA parse, CODE
SWI_WriteC	EQU 	&0	; Software interupt will write character in r0 to output
SWI_Exit	EQU	&11	; Software interupt will exit the program

	ENTRY
start
	ADR	r1, STR1	; Copy in pointer to string
	BL	print_string	; Call print string

	MOV	r7, #0		; Set r7= 0
	ADR	r2, STR1	; void* r2= address of STR1

; The loop iterates through all the characters in the string and calls check_vowel for each
parse1
	LDRB	r1, [r2], #1	; byte r1= *r2; ++r2
	CMP	r1, #0		; Check for null
	BEQ	parse_done	; While (char !null)
	BL	check_vowel	; Call check_vowel
	B	parse1		; Loop back

; This is called to break the parse1 loop
parse_done
	ADR	r1, STR1	; void* r1= &STR1; Load pointer for argument
	BL	print_string	; Print result
	ADR	r1, MSG1	; Load message pointer
	BL	print_string	; Call print string
	MOV	r1, r7		; r1= r7
	BL	PrintHx		; Call print hex

	SWI	SWI_Exit	; Exit the program
	
; @arg r1 is address to the string
print_string
	LDRB 	r0, [r1], #1	; r0= *r5; ++r5; Store the value from the pointer r5 then increment r5
	CMP	r0, #0		; Check for null
	MOVEQ	pc, r14		; If null, Return ; r14 is special
	SWI	SWI_WriteC	; Print signal character in r0
	B	print_string	; Loop back

; @arg r1 is the character
check_vowel
	; if( r1 == 'a' || r1 == 'e' || r1 == 'o' ect.
	TEQ	r1, #'a'	; r1 == 'a'
	TEQNE	r1, #'e'	; r1 == 'e'
	TEQNE	r1, #'o'	; r1 == 'o'
	TEQNE	r1, #'i'	; r1 == 'i'
	TEQNE	r1, #'u'	; r1 == 'u'
;	TEQNE	r1, #'y'	; r1 == 'y'	; Does not count y's

	; This block always overwrites the character in memory with the same.
	; Therefore the memory is unchanged unless the above evaulated true.
	; In that case, the letter will be converted to uppercase
	MOV	r3, r1		; r3= r1		; This line is need because I can't have a STRBEQ
	SUBEQ	r3, r3, #&20	; r3= r3 + 0x20 	; Make uppercase
	SUB	r4, r2, #1	; void* r4= r2 - 1	; Because LDR in the parse1 loop is already one past the current position
	STRB	r3, [r4]	; *(r4)= r3		; Store the value of r3 into the memory at r4
	
	; This should continue from the above testing for capital vowels
	TEQNE	r1, #'A'	; r1 == 'A'
	TEQNE	r1, #'E'	; r1 == 'E'
	TEQNE	r1, #'I'	; r1 == 'I'
	TEQNE	r1, #'O'	; r1 == 'O'
	TEQNE	r1, #'U'	; r1 == 'U'
;	TEQNE	r1, #'Y'	; r1 == 'Y'	; Does not count Y's
	ADDEQ	r7, r7, #1	; Increment vowel counter

	MOV	pc, r14		; Return

; PrintHx has been borrowed from PrintHexa.s by Dr. I. Georgiev
; arg@ r1 the number to print
PrintHx	MOV	r2,#8		;count of nibbles = 8
LOOP	MOV	r0,r1,LSR #28	;get top nibble
	CMP 	r0, #9		;hexanumber 0-9 or A-F
	ADDGT 	r0,r0, #"A"-10	;ASCII alphabetic
	ADDLE 	r0,r0, #"0"	;ASCII numeric
	SWI 	SWI_WriteC	; print character
	MOV	r1,r1,LSL #4	;shift left one nibble
	SUBS	r2,r2, #1	;decrement nibble count
	BNE	LOOP		;if more nibbles,loop back
	MOV 	pc, r14		;return

; The sentence to analyse
STR1	DCB	 "What an earth shuttering discovery!",&0D,&0A,0
; Message to print before printing the vowel count
MSG1	DCB	"This sentence had this many vowels (in hex): 0x",0

	ALIGN
	END
