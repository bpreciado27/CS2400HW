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
; Infinity in 754 : &7F800000
IEEE_754		DCD	&41FE0000, &00000000	; Here's an IEEE-754 single (32-bit) floating point for 0x1F.C
IEEE_TNS		DCD	&7E000104, &00000000	; Here's an IEEE-TNS single (32-bit) floating point for 0x1F.C
ERRORMSG		DCB	&0D,&0A,"Error bad conversion.",&0D,&0A,0
SUCCESSMSG		DCB	&0D,&0A,"Good conversion!",&0D,&0A,0
INPUTMSG		DCB	"Input:",&0D,&0A,0
EXPECTEDMSG		DCB	&0D,&0A,"Expected:",&0D,&0A,0
ACTUALMSG		DCB	&0D,&0A,"Actual:",&0D,&0A,0
			ALIGN



; Loops through each number in IEEE_754 and IEEE_TNS. The loop terminates when it reaches the last element (zero).
			ENTRY
			ADR	r7, IEEE_754
			ADR	r8, IEEE_TNS		
start
			LDR	r10, [r7], #4 
			LDR	r11, [r8], #4
			
			CMP	r10, #&00000000
			SWIEQ	SWI_Exit	; Exit the program
			
			ADR	r1,  IEEE754MSG		; Get the pointer.
			BL	print_string		; Print the message.
			 
			ADR	r9, Conv754ToTNS	; The first argument is the address of the function to call.
			BL	run_test		; Print results for failed conversions.

			ADR	r1,  IEEETNSMSG		; Get the pointer.
			BL	print_string		; Print the message.

			ADR	r9, ConvTNSTo754	; The first argument is the address of the function to call.
			MOV	r0, r10			; Put into a temporary.
			MOV	r10, r11		; Swap.
			MOV	r11, r0			; Swap.
			BL	run_test		; Print results for failed conversions.

			B	start


; Runs a test and prints the results plus information useful for the debugger.
;
; @arg r9 is the pointer to the conversion proceedure.
; @arg r10 is the input.
; @arg r11 is the expected result.
run_test
			MOV r13, r14			; Save return pointer.

			; Show what is going in and what should come out.
			; Print input
			ADR	r1,  INPUTMSG		; Get the pointer.
			BL	print_string		; Print the message.
			MOV	r1, r10			; Load the argument.
			BL	PrintHx			; Print the number in hex.
			; Excepted result
			ADR	r1,  EXPECTEDMSG	; Get the pointer.
			BL	print_string		; Print the message.
			MOV	r1, r11			; Load the argument.
			BL	PrintHx			; Print the number in hex.

			; Run test by moving the program counter and setting the return register.
			MOV	r1, r10			; The argument is the IEEE 754 float.
			ADR	r14, run_test_return	; Load the return address
			MOV	pc, r9			; Make the call. r1 is the return in IEEE TNS format.
run_test_return
			MOV	r12, r1			; Save the actual result.
			; Show the actual result.
			ADR	r1,  ACTUALMSG		; Get the pointer.
			BL	print_string		; Print the message.
			MOV	r1, r12			; Load the argument.
			BL	PrintHx			; Print the actual number in hex.
			; Determine if the outcome is successful and respond accordingly.
			
			TEQ	r12, r11		; Test to make sure conversion was correct. r12 should = r11.
			; Display correct message
			ADREQ	r1,  SUCCESSMSG		; Display a success message when the conversion succeeded.
			ADRNE	r1,  ERRORMSG		; Display a error message when the conversion failed.
			BL	print_string		; Display the message.

			MOV	pc, r13			; Return with the saved pointer.

IEEE754MSG		DCB	&0D,&0A,"Converting 1F.C from IEEE 754 to IEEE TNS...",&0D,&0A,0
IEEETNSMSG		DCB	&0D,&0A,"Converting 1F.C from IEEE TNS to IEEE 754...",&0D,&0A,0
			ALIGN
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
; -IEEE-TNS does not have infinity or zero
Conv754ToTNS
			; Unpack each component
			AND	r2, r1, #&80000000	; Grab the sign bit only.
			MOV	r5, #&70000000		; The goal is to make #&7F800000
			ORR	r5, r5, #&0F800000	; The goal is to make #&7F800000
			AND	r3, r1, r5		; Grab 8 bits the exponent.
			CMP	r3, r5			; Check for infinity or not a number
			MOVEQ	pc, r14			; Error. Cannot convert.
			MOV	r5, #&000000FE		; The goal is to make #&007FFFFE
			ORR	r5, r5, #&007F0000	; The goal is to make #&007FFFFE
			ORR	r5, r5, #&0000FF00	; The goal is to make #&007FFFFE
			AND	r4, r1,r5		; Grab 22 bits of the significant, truncating off the LSB of the significant
			
			; The exponent and significant change positions
			MOV	r3, r3, LSR #23		; Shift the exponent right by 23 bits.
			MOV	r4, r4, LSL #8		; Shift the significant left by 8 bits.
			; Convert exponent from Excess 127 to Excess 256
			SUB	r3, r3, #127		; r3-= 127; Convert exponent from Excess 127 to 2's compliment
			ADD	r3, r3, #256		; r3+= 256; Convert exponent from 2's compliment to Excess 256
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
			MOV	r5, #&000000FF		; The goal is to make #&000001FF
			ORR	r5, r5, #&00000100	; The goal is to make #&000001FF
			AND	r3, r1, r5	; Grab 9 bits the exponent
			MOV	r5, #&7F000000		; The goal is to make #&7FFFFE00
			ORR	r5, r5, #&0000FE00	; The goal is to make #&7FFFFE00
			ORR	r5, r5, #&00FF0000	; The goal is to make #&7FFFFE00
			AND	r4, r1, r5		; Grab 22 bits the significant.
			; Convert exponent from Excess 127 to Excess 256
			SUB	r3, r3, #256		; r3-= 256; Convert exponent from 2's compliment to Excess 256
			AND	r3, r3, #&000000FF	; Truncate the MSB.
			ADD	r3, r3, #127		; r3+= 127; Convert exponent from Excess 127 to 2's compliment

			; The exponent and significant change positions
			MOV	r3, r3, LSL #23		; Shift the exponent left by 23 bits.
			MOV	r4, r4, LSR #8		; Shift the significant right by 9 bits.
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
