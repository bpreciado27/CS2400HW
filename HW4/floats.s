			;*****************************************************************************
			; File: floats.s
			; Programmer: Josh Gillham
			; Description: There will be two subroutines. The first, will convert from 
			;  IEEE-754 to IEEE-TNS. The second will be the reverse of the first. The main
			;  will call each proceedure to check that the conversions are correct.
			;	
			;
			; Project: HW4
			; Date: 10-1-12
			;******************************************************************************

			AREA parse, CODE
SWI_WriteC		EQU 	&0			; Software interupt will write character in r0 to output
SWI_Exit		EQU	&11			; Software interupt will exit the program
; Using DCD preserves the order of the bytes
IEEE_754		DCD	&41FE0000		; Here's an IEEE-754 single (32-bit) floating point for 0x1F.C
IEEE_TNS		DCD	&7E000104		; Here's an IEEE-TNS single (32-bit) floating point for 0x1F.C
ERRORMSG		DCB	"Error bad conversion",&0D,&0A,0
SUCCESSMSG		DCB	"Good job!",&0D,&0A,0
INPUTMSG		DCB	"Input:",&0D,&0A,0
EXPECTEDMSG		DCB	&0D,&0A,"Expected:",&0D,&0A,0
ACTUALMSG		DCB	&0D,&0A,"Actual:",&0D,&0A,0
			ALIGN

			ENTRY

			LDR	r1, IEEE_754		; Here's the argument
			BL	Conv754ToTNS		; Make the call. r1 is the return.
			LDR	r2, IEEE_TNS		; Here's the argument
			TEQ	r2, r1			; r1 should = r2
			MOV	r10, r1			;
			ADRNE	r1,  ERRORMSG		;
			ADREQ	r1,  SUCCESSMSG		;
			BL	print_string		;
			TEQ	r10, r1			; r1 should = r2
			BLNE	print_feedback		;
			
			
			SWI	SWI_Exit	; Exit the program

print_feedback
			MOV r13, r14			; Save return pointer
			; Print input
			
			ADR	r1,  INPUTMSG		;
			BL	print_string		;
			MOV	r1, r10			;
			BL	PrintHx			;
			; Print result
			ADR	r1,  ACTUALMSG		;
			BL	print_string		;
			LDR	r1, IEEE_754		;
			BL	PrintHx			;
			; Excepted result
			ADR	r1,  EXPECTEDMSG	;
			BL	print_string		;
			LDR	r1, IEEE_TNS		;
			BL	PrintHx			;
			MOV	pc, r13			; Return

; Converts IEEE-754 single floating point to IEEE-TNS.
; IEEE-754	Sign 1-Bit| Exponent 	8-bit	(Excess 127)	| Significant 	23-bits
; IEEE-TNS	Sign 1-Bit| Significant 22-bits			| Exponent 	9-bit (Excess 256)
;
; Outline:
; 1. Unpack (with AND) the sign bit, exponent, and significant.
; 2. Shift exponent right by 23 bits.
; 3. Shift significant left by 9 bits
; 4. Repack (with OR) the sign bit, exponent, and significant.
;
; Registers Affected: r2, r3, r4, r5
;
; @arg r1 is the IEEE-754 32-bit floating point number.
;
; @return r1 is the IEEE-TNS
;
; TODO:
; -debug
; -IEEE-TNS does not have infinity or zero
; -Handle truncating better
; -Handle Excess Code Conversions
Conv754ToTNS
			; Unpack each component
			AND	r2, r1, #&80000000	; Grab the sign bit only.
			MOV	r5, #&70000000		; The goal is to make #&7F800000
			ORR	r5, r5, #&0F800000	; The goal is to make #&7F800000
			AND	r3, r1, r5		; Grab 8 bits the exponent.
			MOV	r5, #&000000FF		; The goal is to make #&003FFFFF
			ORR	r5, r5, #&003F0000	; The goal is to make #&003FFFFF
			ORR	r5, r5, #&0000FF00	; The goal is to make #&003FFFFF
			AND	r4, r1,r5		; Grab 22 bits of the significant, truncating off the MSB of the significant
			; The exponent and significant change positions
			MOV	r3, r3, LSR #23		; Shift the exponent right by 23 bits.
			MOV	r4, r4, LSL #9		; Shift the significant left by 9 bits.
			; Pack the components back together
			MOV	r1, r2			; Set r1= r2; Start with the sign bit
			ORR	r1, r1, r3		; Pack the exponent
			ORR	r1, r1, r4		; Pack the significant
			MOV	pc, r14			; Return
			

; Converts an IEEE-TNS single floating point to IEEE-754.
; IEEE-TNS	Sign 1-Bit| Significant 22-bits	| Exponent 	9-bit
; IEEE-754	Sign 1-Bit| Exponent 	8-bit	| Significant 	23-bits
;
; Outline:
; 1. Unpack (with AND) the sign bit, exponent, and significant.
; 2. Shift the exponent left by 23 bits.
; 3. Shift the significant right by 9 bits.
; 4. Repack (with OR) the sign bit, exponent, and significant.
;
; Registers Affected: r2, r3, r4, r5
;
; @arg r1 is the IEEE-TNS 32-bit floating point number
;
; @return r1 is the IEEE-TNS
;
; TODO:
; -debug
; -IEEE-TNS does not have infinity or zero
; -Handle truncating better
; -Handle Excess Code Conversions
ConvTNSTo754
			; Unpack each component
			AND	r2, r1, #&80000000	; Grab the sign bit only.
			AND	r3, r1, #&000000FF	; Grab 8 bits the exponent truncating the MSB.
			MOV	r5, #&7F000000		; The goal is to make #&7FFFFE00
			ORR	r5, r5, #&0000FE00	; The goal is to make #&7FFFFE00
			ORR	r5, r5, #&00FF0000	; The goal is to make #&7FFFFE00
			AND	r4, r1, r5		; Grab 22 bits the significant.
			; The exponent and significant change positions
			MOV	r3, r3, LSL #23		; Shift the exponent left by 23 bits.
			MOV	r4, r4, LSR #9		; Shift the significant right by 9 bits.
			; Pack the components back together
			MOV	r1, r2			; Set r1= r2; Start with the sign bit
			ORR	r1, r1, r3		; Pack the exponent
			ORR	r1, r1, r4		; Pack the significant
			MOV	pc, r14			; Return

; print_string iterates through each character in the string and prints them.
; @arg r1 is address to the string
print_string
	LDRB 	r0, [r1], #1	; r0= *(r1++); Store the value from the pointer r5 then increment r5
	CMP	r0, #0		; Check for null
	MOVEQ	pc, r14		; If null, Return ; r14 is special
	SWI	SWI_WriteC	; Print single character in r0
	B	print_string	; Loop back

; PrintHx has been borrowed from PrintHexa.s by Dr. I. Georgiev
;
; arg@ r1 the number to print
;
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

			END