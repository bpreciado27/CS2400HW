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
			IMPORT randomnumber
			IMPORT seed
			IMPORT printhexa
			IMPORT print_string
SWI_WriteC		EQU 	&0			; Software interupt will write character in r0 to output
SWI_Exit		EQU	&11			; Software interupt will exit the program
			ALIGN

			ENTRY
start
			SWI	SWI_Exit	; Exit the program