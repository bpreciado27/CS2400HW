	AREA parse, CODE
	ENTRY
start
	ADR	r0, INSTR	; Copy in pointer to string
	BL	print_string	; Call print string

	MOV	r1, r0		; r1= r0
	CMP	r1, #0		; Check for null ; Make previous line copy byte from adr
	BNE	end_loop:	; While (char !null)
	BL	check_vowel	; Call check_vowel
	B	start_loop	
