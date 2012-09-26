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
3. print String: Copy r1 to r2 so we can change the value.
4. Compare r2 to 0 to check for the null.
5. If we got a null, then return.
6. Print the character that the address in r2 points to.
7. Increment r2.
8. Goto #4

