*-----------------------------------------------------------
* Title      : Input Branch Tutorial
* Written by : Jeremy DeHaan
* Date       : 04/10/2017
* Description: This code will ask for you to input a number.
*              It then checks if the number is between 20 and
*              25 and goes to various banches accordingly.
*
*              If the input is equal to the SID number, it
*              terminates the program.
*-----------------------------------------------------------

*-----Text replacements-------
CR      EQU     $0D
LF      EQU     $0A
SID     EQU     1673458

START   ORG     $1000   ; first instruction of program
*-------Code for output-------
LOOP    LEA MESSAGE,A1  ; loads the address of MESSAGE into A1  
        MOVE.B  #14,D0  ; moves 14 iunto D0
        TRAP    #15     ; runs the I/O command with code #14(print text)

*------Code for input---------
        MOVE.B  #4,D0   ; moves 4 into D0
        TRAP    #15     ; runs the I/O command with code #4(read number into D1)
        CMP.L   #SID,D1  ; compare the input with the SID number
        BEQ     DONE    ; if they are equal, we go to DONE (and end the program)

        CMP.L   #20,D1  ; compare 20 with the value in D1
        BLT     INVALID ; if this value is less than 20, go to INVALID
        CMP.L   #25,D1  ; compare 25 with the value in D1
        BGT     INVALID ; if this value is greater than 25, go to IVALID
        BRA     VALID   ; if the value in D1 is between 20 and 25, it is a valid number

INVALID LEA     INV,A1  ; load the address of INV into A1 (invalid value message)
        MOVE.B  #14,D0  ; moves 14 iunto D0 
        TRAP    #15     ; runs the I/O command with code #14(print text)
        BRA     LOOP    ; go to the start of the loop

VALID   LEA     VLD,A1  ; load the address of VLD into A1 (valid value message)
        MOVE.B  #14,D0  ; moves 14 iunto D0 
        TRAP    #15     ; runs the I/O command with code #14(print text)
        BRA     LOOP    ; go to the start of the loop


DONE    MOVE.B  #9,D0   ; moves 9 into D0
        TRAP    #15     ; runs the I/O command with code #9(halt program)
        
*-------Constants-------------
MESSAGE DC.B    'Enter a number between 20 and 25, or enter my SID to exit: ',0
VLD     DC.B    'Hooray! You can follow instructions!',CR,LF,0
INV     DC.B    'That is not between 20 and 25. Please try again.',CR,LF,0

        END     START        ; last line of source




*~Font name~Courier New~
*~Font size~14~
*~Tab type~1~
*~Tab size~4~
