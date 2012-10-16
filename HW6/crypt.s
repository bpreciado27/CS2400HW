			;*****************************************************************************
			; File: crypt.s
			; Programmer: Josh Gillham
			; Description: This program takes a message and encrypts it then decrypts. Each
			;  step has printed output. The result is compared to the original for accuracy.
			;	
			;
			; Project: HW6
			; Date: 10-16-12
			;******************************************************************************

			AREA parse, CODE
			IMPORT printhexa
			IMPORT print_string
SWI_WriteC		EQU 	&0						; Software interupt will write character in r0 to output
SWI_Exit		EQU	&11						; Software interupt will exit the program
MSG			DCB	"This is a secret!",&0,&0,&0			; Store secret message
MSGOUT			DCB	"This the result!!",&0,&0,&0			; Store secret message
KEY			DCD	&F1A57D2B					; Encryption key
MSG_XOR_MASK		DCB	"The result of XOR_mask:",&0			; Status message
MSG_PERMUTATION		DCB	"The result of permutation:",&0			; Status message
			ALIGN

			ENTRY
; Structure:
;  -The main subroutine calls in sequence the encryption subroutine,
;    the decryption subroutine and the compare subroutine
start

; Structure:
;  -Calls print_string to show the input then calls permutation and XOR_mask
encrypt

; Structure:
;  -Calls print_string to show the input then calls permutation and XOR_mask
decrypt

; Structure:
;  -Calls print_string to show the results. 
compare
; Accepts a word and swapps the bytes 1 with 4 and 2 with 3.
;
; Outline:
; . r0= High byte
; . r1= 2nd Byte
; . r2= 3rd Byte
; . r3= 4th Byte
; . shift r0 right by 24 bits.
; . shift r3 left by 24 bits.
; . shift r1 right by 8 bits.
; . shift r2 left byt 8 bits.
; . repack word
;
; @arg r0 is the word input.
;
; @return r0 is the word output.
;
; Affected Registers:
;
; Structure:
;  -Calls print_string to show the result. 
BYTE1			DCD	&FF000000		; Mask for the high.
permutation
			; Extract each byte.
			AND r1, r0, #&00FF0000		; Grab the 2nd byte.
			AND r2, r0, #&0000FF00		; Grab the 3nd byte.
			AND r3, r0, #&000000FF		; Grab the last byte.
			AND r0, r0, #&FF000000		; Grab the first byte.
			; Swap byte positions.
			MOV r0, r0, LSR #24		; Move the highest to the lowest.
			MOV r1, r1, LSR #8		; Move the 2nd to the 3rd.
			MOV r2, r2, LSL #8		; Move the 3nd to the 2rd.
			MOV r3, r3, LSL #24		; Move the lowest to the highest.
			; Repack
			ORR r0, r0, r1			; Pack on r1
			ORR r0, r0, r2			; Pack on r2
			ORR r0, r0, r3			; Pack on r2
			; Show results
			STMFD sp!, { r0, lr }		; Push routine registers
			ADR r0, MSG_PERMUTATION		; Get address of message to display
			BL print_string			; Show message
			LDMFD sp!, { r0, lr }		; Pop routine registers
			STMFD sp!, { r0, lr }		; Push routine registers
			BL printhexa			; Show result
			LDMFD sp!, { r0, lr }		; Pop routine registers
			MOV pc, lr			; Return


; Accepts a word and encrypts it with a 32-bit key.
;
; Outline
; . Load key into r1
; . XOR r0 with r1
; . Print message
; . Print output
;
; @arg r0 is the word plaintext
;
; @return r0 is the word encrypted.
;
; Affected Registers: r0, r1, sp
;
; Structure:
;  -Calls print_string to show the result. 
XOR_mask
			LDR r1, KEY			; Copy the key into r1.
			EOR r0, r0, r1			; Encrypt word.
			STMFD sp!, {r0,lr}		; Push routine registers
			ADR r0, MSG_XOR_MASK		; Get the address of the message to display.
			BL print_string			; Show message
			LDMFD sp!, { r0, lr }		; Pop routine registers
			STMFD sp!, { r0, lr }		; Push routine registers
			BL printhexa			; Show result
			LDMFD sp!, { r0, lr }		; Pop routine registers
			MOV pc, lr			; Return

; Demostrates that I can save all the registers and restore them later. Only for testing purposes.
stack_test
			MOV r0, #1			; Store values
			MOV r1, #1			; Store values
			MOV r2, #1			; Store values
			MOV r3, #1			; Store values
			MOV r4, #1			; Store values
			MOV r5, #1			; Store values
			MOV r6, #1			; Store values
			MOV r7, #1			; Store values
			MOV r8, #1			; Store values
			MOV r9, #1			; Store values
			MOV r10, #1			; Store values
			MOV r11, #1			; Store values
			STMFD sp!, {r0-r14}		; Store all the registers
			MOV r0, #0			; Mess up the registers
			MOV r2, #5			; Mess up the registers
			MOV r3, #2			; Mess up the registers
			MOV r5, #3			; Mess up the registers
			MOV r8, #7			; Mess up the registers
			MOV r10, #9			; Mess up the registers
			LDMFD sp!, {r0-r14}		;Restore all the registers
			SWI	SWI_Exit					; Exit the program

			END
