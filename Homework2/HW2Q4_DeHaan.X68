*-----------------------------------------------------------
* Title      :  Floating point decoder
* Written by :  Jeremy DeHaan
* Date       :  04/18/2017
* Description:  This program takes in a 32bit IEEE floating
*               point number in HEX and decodes it to the
*               various parts.
*-----------------------------------------------------------
    ORG    $4000
START:                  ; first instruction of program

* Put program code here
            LEA MSSG, A1        ; load the first message into A1
            MOVE.B #14,D0
            TRAP #15            ; display it
            
            MOVE.B #2,D0        ; set up for input
            TRAP #15            ; get a string from user and put address into A1
            CLR D0              ; clear D0 before going to the conversion subroutine
            MOVEA.L #$A000, A2  ; use $A000 as some random memory address (A2 is used in the subroutine)
            JSR CNVFRMASCII     ; convert the string from ascii to number (saves to $A000)
            
            MOVE.L $A000,D3
            LSL.L #1, D3      ; rotate the binary representation
            
            
            SCS D0
            MOVE.B D0, SignBit
            
            MOVE.L D3, $A000
            
            MOVE.B $A000, Exponant
            MOVE.B Exponant, D1
            
            
            MOVE.L $A000,D3
            LSL.L #8, D3      ; rotate the binary representation
            LSR.L #8, D3
            LSR.L #1, D3
            
SHIFTLOOP   LSR.L #1,D3
            BCS SHIFTEND
            BRA SHIFTLOOP
            
SHIFTEND    LSL.L #1, D3
            ADD.L #1, D3
            MOVE.L D3, Mantissa
            
            
            LEA NEWLINE, A1     ; load a blank newline into A1
            MOVE.B #14,D0
            TRAP #15            ; display it
            
            
            
            CLR D1
            MOVE.B SignBit, D1
            MOVE.B #3,D0
            TRAP #15            ; display it
            
            LEA NEWLINE, A1     ; load a blank newline into A1
            MOVE.B #14,D0
            TRAP #15            ; display it
            
            CLR D1
            MOVE.B Exponant, D1
            MOVE.B #3,D0
            TRAP #15            ; display it
            
            
            LEA NEWLINE, A1     ; load a blank newline into A1
            MOVE.B #14,D0
            TRAP #15            ; display it
            
            
            CLR D1
            MOVE.L Mantissa, D1
            MOVE.B #3,D0
            TRAP #15            ; display it
            
            
            SIMHALT             ; halt simulator



CNVFRMASCII MOVE.B (A1),D3      ; copy the first hex character to D3
            CMP.B #0, D3        ; check if we found the null terminator
            BEQ CFAEXIT         ; If we do, return from subroutine
            MOVE.B (A1)+,D4     ; copy the first hex character to D4
            LSR.B #4, D3        ; shift D3 to just get the top 4 bits
            LSL.B #4, D4        ; shift D4 twice get just the bottom 4 bits
            LSR.B #4, D4
            CMP.B #3,D3         ; if D3 is equal to 3, this hex value is a number
            BEQ CNVNUM          ; convert to a number
            BRA CNVLET
            
CFAEXIT     RTS                 ;


CNVNUM      CMP.B #0, D0
            BEQ SHIFT
            CLR D0
            ADD.B D4, (A2)+    ; move the number value into
            BRA CNVFRMASCII

CNVLET      ADD.B #9, D4
            CMP.B #0, D0
            BEQ SHIFT
            CLR D0
            ADD.B D4, (A2)+
            BRA CNVFRMASCII
            
SHIFT       LSL.B #4, D4
            MOVE.B D4, (A2)
            MOVE.B #1, D0
            BRA CNVFRMASCII
            
            
            
            


            SIMHALT             ; halt simulator

* Put variables and constants here
CR          EQU     $0D
LF          EQU     $0A

NEWLINE     DC.B    CR,LF,0

MSSG        DC.B    'Please enter a 32bit hex representation of a floating point number: ',CR,LF,0
SBSTR       DC.B    'Sign bit: ',0
SignBit     DS.B    1
EXPSTR      DC.B    'Exponant: ',0
Exponant    DS.B    1
MNTSTR      DC.B    'Mantissa: ',0
Mantissa    DS.L    1    



            END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
