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
; IEEE-754	Sign 1-Bit| Exponent 	8-bit	| Significant 	23-bits
; IEEE-TNS	Sign 1-Bit| Significant 22-bits	| Exponent 	9-bit
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
; -debug
Conv754ToTNS
			; Unpack each component
			AND	r2, r1, #&80000000	; Grab the sign bit only.
			MOV	r5, #&70000000		; The goal is to make #&7F800000
			ORR	r5, r5, #&0F800000	; The goal is to make #&7F800000
			ORR	r3, r1, r5		; Grab 8 bits the exponent.
			MOV	r5, #&000000FF		; The goal is to make #&003FFFFF
			ORR	r5, r5, #&003F0000	; The goal is to make #&003FFFFF
			ORR	r5, r5, #&0000FF00	; The goal is to make #&003FFFFF
			AND	r4, r1, r5		; Grab 22 bits of the significant, truncating off the MSB of the significant
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
; @arg r1 is the IEEE-TNS 32-bit floating point number
;
; TODO:
; -debug
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

			END