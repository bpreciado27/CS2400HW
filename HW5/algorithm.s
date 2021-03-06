			;*****************************************************************************
			; File: algorithm.s
			; Programmer: Josh Gillham
			; Description: Generate a series of random numbers with randomnumber.s and put
			;  them into a string of words. Call a subroutine to count the 1s and another
			;  to count the 0s. Print the results to the console.
			;	
			;
			; Project: HW5
			; Date: 10-9-12
			;******************************************************************************

			AREA parse, CODE
			IMPORT randomnumber
			IMPORT seed
			IMPORT printhexa
			IMPORT print_string
SWI_WriteC		EQU 	&0			; Software interupt will write character in r0 to output
SWI_Exit		EQU	&11			; Software interupt will exit the program
RANDOMSERIES        	DCD     &55555555, &55555555, &55555555, &00000000
NUMBERMSG		DCB	&0D,&0A, &0D,&0A,"Random Number:",&0D,&0A,0
TELL0SMSG		DCB	&0D,&0A,"Count 0s:",&0D,&0A,0
TELL1SMSG		DCB	&0D,&0A,"Count 1s:",&0D,&0A,0
			ALIGN

; Outline:
; 1. Store the results into a string of bytes.
; . While seedpointer is not zero.
; . Call RANDOM.S
; . Copy seedPointer to RANDOMSERIES
; . go back
; 2. For each byte count the 1s and 0s
; 3. Print the results to the screen.
			ENTRY
			
			
			ADR     r5, RANDOMSERIES
                     	
start
                     	BL      randomnumber
			
			MOV	r13, r0
			ADR	r1, NUMBERMSG
			BL	print_string
			MOV	r1, r13
			BL	printhexa

			ADR	r1, TELL1SMSG
			BL	print_string
			MOV	r0, r13
			BL	count1sb
			MOV	r1, r2
			BL	printhexa

			ADR	r1, TELL0SMSG
			BL	print_string			
			MOV	r0, r13
			BL	count0sb
			MOV	r1, r2
			BL	printhexa


			LDR	r11, [r5]
			CMP	r11, #&00000000		; End byte is zero
			STR	r13, [r5]		; Store random number
			ADDNE	r5, r5, #4		; Increment r5
			BNE	start			;
			
			;ADR	r12, RANDOMSERIES	; Get a pointer to RANDOMSERIES
main_process
			;LDRB	r11, [r12], #1		; r11=*( r12++ )
			
			SWI	SWI_Exit	; Exit the program

; Takes a byte and counts the number of 1s.
; 
; @arg r0 is the number to count
; 
; @return r2 is the count of 1s
;
; Outline:
; 1. r2= 0
; 2. If( r0 == 0 ) return r2
; 3. Add 1 to r2
; 4. Let the temporary number (r1) = r0.
; 5. Subtract 1 from r0.
; 6. r0 = r1 AND r0.
; 7. Goto #1
;
; TODO:
; -Handle when r2 is negative (r2 should be unsigned)
count1sb
			MOV	r2, #0			; Set r2 to 0
count1sb_loop
			CMP	r0, #&00000000		; If r0 == 0
			MOVEQ	pc, r14			; Then return
			ADD	r2, r2, #1		; ++r2
			MOV	r1, r0			; r1= r0
			SUB	r0, r0, #1		; --r0; Handle negatives?
			AND	r0, r0, r1		; r0&= r1
			B	count1sb_loop		; Goto count1sb_loop
			

; Takes a byte and counts the number of 0s.
; 
; @arg r0 is the in number to count
; 
; @return r2 is the count of 0s
;
; Outline:
; 1.  r2= 0
; 2. If( r0 == 0xFFFF FFFF ) return r2
; 3. Add 1 to r2
; 4. Let the temporary number (r1) = r0.
; 5. Add 1 to r0.
; 6. r0 = r1 OR r0.
; 7. Goto #1
;
count0sb
			MOV	r2, #0			; r2= 0
count0sb_loop
			CMP	r0, #&FFFFFFFF		; If r0 == value when all bits are on
			MOVEQ	pc, r14			; Then return
			ADD	r2, r2, #1		; ++r2
			MOV	r1, r0			; r1= r0
			ADD	r0, r0, #1		; ++r0
			ORR	r0, r0, r1		; r0|=r1
			B	count0sb_loop		; Goto count0sb_loop

			END


