SUBROUTINES:
parser - iterates through the string
vowel checker - singals for vowel characters
print string - iterates through the string printing each character

MAIN SEQUENCE:
1. Prints entry string
2. Replaces all vowel characters with upper case versions.

3. Prints the result

VOWEL CHECKER SEQUENCE:
1. Evaluates a condition for each vowel on the argument char (c).
2. If all conditions are true, adds 32 (to make upper case) to c.

PRINT STRING:
1. For each char, call software interupt to print it.
2. Watch for null char.

Main Sequence:
1. Copy address of in-string into the r1 register.
2. Call print string

print String:
3. Copy r1 to r2   ; so we can change the value.
4. Compare r2 to 0 ; to check for the null.
5. For nulls, return at #9.
6. Print the character that the address in r2 points to.
7. Increment r2.
8. Goto #4

9. Copy r1 to r2 so we can iterate through chars.
10. Compare r2 to 0 to check for a null.
11. If we got a null then jump to #16.
12. Call check for vowel.

Check for vowel:
13. Compare r2 to vowels.
14. If we got a vowel add 20 (to make capital) to the value the address in r2 points to.

15. Goto #10
16. Call print string
17. Exit program

