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
			ALIGN

			ENTRY
start
			ADR	r1, IEEE_754
			LDR	r2, [r1]
			ADR	r1, IEEE_TNS
			SWI	SWI_Exit	; Exit the program

; Converts IEEE-754 single floating point to IEEE-TNS.
;
; Outline:
; 1. Unpack (with AND) the sign bit, exponent, and significant.
; 2. Shift exponent right by 23 bits.
; 3. Shift significant left by 9 bits
; 4. Repack (with OR) the sign bit, exponent, and significant.
;
; @arg r1 is the IEEE-754 32-bit floating point number.
;
; TODO:
; -Since the exponent and mantissa sizes for both are not the same. How to handle that?
Conv754ToTNS
			; Unpack each component
			AND	r2, r1, #&80000000	; Grab the sign bit only.
			AND	r3, r1, #&7F800000	; Grab the exponent.
			AND	r4, r1, #&007FFFFF	; Grab the significant.
			; The exponent and significant change positions
			MOV	r3, r3, LSR #23		; Shift the exponent right by 23 bits.
			MOV	r4, r4, LSL #9		; Shift the significant left by 9 bits.
			; Pack the components back together
			MOV	r1, r2			; Set r1= r2
			ORR	r1, r1, r3		; Pack the exponent
			ORR	r1, r1, r4		; Pack the significant
			MOV	pc, r14			; Return
			

; Converts an IEEE-TNS single floating point to IEEE-754
;
; Outline:
; 1. Unpack (with AND) the sign bit, exponent, and significant.
; 2. Shift the exponent left by 23 bits.
; 3. Shift the significant right by 9 bits.
; 4. Repack (with OR) the sign bit, exponent, and significant.
;
; @arg r1 is the IEEE-TNS 32-bit floating point number
ConvTNSTo754


			END