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
SWI_WriteC		EQU 	&0			; Software interupt will write character in r0 to output
SWI_Exit		EQU	&11			; Software interupt will exit the program
			ALIGN

			ENTRY
start
			SWI	SWI_Exit	; Exit the program

; Takes a byte and counts the number of 1s.
; 
; @arg r0 is the in number to count
; 
; @return r2 is the count of 1s
;
; Outline:
; .  r2= 0
; 1. If( r0 == 0 ) return r2
; . Add 1 to r2
; 2. Let the temporary number (r1) = r0.
; 3. Subtract 1 from r0.
; 4. r0 = r1 XOR r0.
; 5. Goto #1
;
count1sb
			MOV	pc, r14			; Return

; Takes a byte and counts the number of 0s.
; 
; @arg r0 is the in number to count
; 
; @return r2 is the count of 0s
;
; TODO:
; -finish outline.
; Outline:
; .  r2= 0
; 1. If( r0 == 0 ) return r2
; . Add 1 to r2
; 2. Let the temporary number (r1) = r0.
; 3. Subtract 1 from r0.
; 4. r0 = r1 XOR r0.
; 5. Goto #1
;
count1sb
			MOV	pc, r14			; Return


