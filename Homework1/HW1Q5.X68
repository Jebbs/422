*-----------------------------------------------------------
* Title      :  Word Addition
* Written by :  Jeremy DeHaan
* Date       :  04/13/2017
* Description:  This program will ask for two numbers(assumed
*               to be 16bit), and will then add them and
*               display the result.
*
*               It also notifies the user if an overflow
*               occurred during the addition.
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

*-------------CODE----------------          
            
            LEA ENTRMSSG, A1    ; load the first message into A1
            MOVE.B #14,D0
            TRAP #15            ; display it
            
            MOVE.B #4,D0        ; set up for input
            TRAP #15            ; get first number from user
            MOVE.W D1,D2        ; move that number (as word) into D2
            
            LEA SCNDMSSG, A1    ;load second message into A1
            MOVE.B #14,D0
            TRAP #15            ; display it
            
            MOVE.B #4,D0        ; set up for input
            TRAP #15            ; get second number from user
            
            ADD.W D1,D2         ; add the first and second numbers together
            SVS D3              ; check for overflow
            
            MOVE.W D2,$6000     ; move the value of the addition into address $6000
            
            CLR.L D1              ; clear D1 (is is used for printing)
            MOVE.W D2,D1        ; Move our addition into D1 for printing
            CMP #0, D2          ; compare 0 and the added number
            BLT NEGATIVE        ; go to the NEGATIVE label to make sure printing works


*-------------Printing--------------


PRINTNUM    MOVE.B #3,D0        ; set up for number output
            TRAP #15            ; output added number
            
            CMP #0,D3           ; compare the overflow bits to 0
            BNE PRINTERR        ; if the overflow bits aren't zero, go to print an error message
            BRA EXIT            ; otherwise we are done and can exit
            
            
PRINTERR    LEA ERRMSSG, A1     ; load error message into A1
            MOVE.B #14,D0
            TRAP #15            ; display it
            BRA EXIT
            

          
NEGATIVE    ADD.L #$FFFF0000, D1 ; if our added number is negative, make sure the output longword is negative
            BRA   PRINTNUM         
            



EXIT        SIMHALT              ; halt simulator

*--------------Constants----------------


CR          EQU     $0D
LF          EQU     $0A

ENTRMSSG    DC.B    'Enter two numbers to add.',CR,LF
            DC.B    'First:  ',0

SCNDMSSG    DC.B    'Second: ',0

ERRMSSG     DC.B    CR,LF,'An overflow occurred. Addition may not be correct.',CR,LF,0



            END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
