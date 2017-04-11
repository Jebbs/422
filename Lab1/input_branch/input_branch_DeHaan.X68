*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
CR      EQU     $0D
LF      EQU     $0A
SID     EQU     1673458

START   ORG     $1000    ; first instruction of program
*-------Code for output-----------
LOOP    LEA MESSAGE,A1
        MOVE.B  #14,D0
        TRAP    #15
        
        
        MOVE.B  #3,D3
        ADD.B   #-4,D3

*------Code for input---------
        MOVE.B  #4,D0
        TRAP    #15
        CMP.L   SID,D1
        BEQ     DONE

        CMP.L   #22,D1
        BLT     INVALID
        CMP.L   #25,D1
        BGT     INVALID
        BRA     VALID

INVALID LEA     INV,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     LOOP

VALID   LEA     VLD,A1
        MOVE.B  #14,D0
        TRAP    #15
        BRA     LOOP


DONE    MOVE.B  #9,D0
        TRAP    #15     halt simulator

MESSAGE DC.B    'Enter a number between 22 and 25, or enter my SID to exit: ',0
VLD     DC.B    'Hooray! You can follow instructions!',CR,LF,0
INV     DC.B    'That is not between 22 and 25, you asshole.',CR,LF,0

* Put variables and constants here

        END     START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
