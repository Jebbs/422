*-----------------------------------------------------------
* Title      :  Pattern Finding
* Written by :  Jeremy DeHaan
* Date       :  04/18/2017
* Description:  This program takes user input to try to find
*               memory locations with data that matches the
*               input.
*-----------------------------------------------------------
            ORG    $1000
START:                          ; first instruction of program


            LEA MSSG, A1        ; load the first message into A1
            MOVE.B #14,D0
            TRAP #15            ; display it
            
            MOVE.B #2,D0        ; set up for input
            TRAP #15            ; get a string from user and put address into A1
            CLR D0              ; clear D0 before going to the conversion subroutine
            JSR CNVFRMASCII     ; convert the string from ascii to number (saves to $A000)

            
            MOVEA.L #$6000, A2   ; put address $6000 into A1, it is out starting address
            MOVE.B ($A000),D1      ; put the contents of A1 into D1
READLOOP    CMPA.L #$8000, A2    ; do a comparison with out current position and $8000 (the ending address)
            BGT NOTFOUND        ; If we went past $8000 and didn't find a match, go to the NOTFOUND label
            CMP.B (A2)+,D1      ; Compare the contents at address locations A2 with D1
            BEQ FOUND           ; If we would a match, go to the FOUND label
            BRA READLOOP        ; If no match was found go to the start of the loop
            
            
            
            
NOTFOUND    MOVEA.L #$6000, A2   ; set the address to $6000 because we never found a match
            MOVE.L A2, Addr1   ; store the address in the Addr1 variable
            BRA ADDLOOPSTRT     ; go the the start of the add loop

FOUND       ADDA.L #-1,A2       ; set back one place to get the address of the actual match
            MOVE.L A2, Addr1    ; store the address in the Addr1 variable
            BRA ADDLOOPSTRT     ; go to the start of the add loop



ADDLOOPSTRT MOVEA.L A2,A3       ; copy the starting address into the ending address
            ADDA.L #512,A3      ; add 512 to it to make it the actual ending address
            MOVE.W #0,Addsum    ; set our addition to 0
            MOVE.B #0,CarryBit
            CLR D2              ; clear D2 just in case
            
ADDLOOP     CMPA.L A3,A2        ; compare our current address with the ending address
            BGE PRINT           ; if the current address is greater than or equal to our ending address
                                ; go to the print label
            MOVE.B (A2)+, D2    ; move the contents of A2 into D2
            ADD.W  D2, Addsum   ; add the current sum with D2
            BCS SETCARRY        ; if the carry was set, goto the SETCARRY label
            BRA ADDLOOP         ; otherwise go to the start of the loop
            
SETCARRY    MOVE.B #1, CarryBit ; copy 1 into the CarryBit variable (to show it was set)
            BRA ADDLOOP
            
            
                 
PRINT       LEA NEWLINE, A1     ; load a blank newline into A1
            MOVE.B #14,D0
            TRAP #15            ; display it
            
            LEA ADDRSTR, A1     ; load the ADDRSTR into A1
            MOVE.B #14,D0
            TRAP #15            ; display it
            
            LEA Addr1, A1       ; load Addr1 into A1
            MOVE.B #4, D5       ; copy 4 into D5 (number of bytes to print)
            JSR PRINTHEX        ; print the number at A1 in hex
            
            LEA NEWLINE, A1     ; load a blank newline into A1
            MOVE.B #14,D0
            TRAP #15            ; display it
            
            LEA ADDSUMSTR, A1   ; load the ADDSUMSTR into A1
            MOVE.B #14,D0
            TRAP #15            ; display it
            
            LEA Addsum, A1       ; load Addsum into A1
            MOVE.B #2, D5       ; copy 2 into D5 (number of bytes to print)
            JSR PRINTHEX        ; print the number at A1 in hex
            
            LEA NEWLINE, A1     ; load a blank newline into A1
            MOVE.B #14,D0
            TRAP #15            ; display it
            
            
            LEA CBSTR, A1     ; load the ADDRSTR into A1
            MOVE.B #14,D0
            TRAP #15            ; display it
            
            
            MOVE.B CarryBit, D1
            LEA MSSG, A1        ; load the first message into A1
            MOVE.B #3,D0
            TRAP #15            ; display it
            
            
            

CNVFRMASCII MOVEA.L #$A000, A3
            MOVE.B (A1),D3      ; copy the first hex character to D3
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
            ADD.B D4, (A3)+    ; move the number value into
            BRA CNVFRMASCII

CNVLET      ADD.B #9, D4
            CMP.B #0, D0
            BEQ SHIFT
            CLR D0
            ADD.B D4, (A3)+
            BRA CNVFRMASCII
            
SHIFT       LSL.B #4, D4
            MOVE.B D4, (A3)
            MOVE.B #1, D0
            BRA CNVFRMASCII
            
            
            
PRINTHEX    CMP.B #0, D5
            BEQ PHEXIT
            MOVE.B (A1),D3
            MOVE.B (A1)+,D4
            
            LSR.B #4, D3
            LSL.B #4, D4
            LSR.B #4, D4
            
            CLR D6
            MOVE.B D3,D1
            CMP.B #10,D3
            BLT PRINTNUM
            BRA PRINTLET

PRINTSEC    MOVE.B D4,D1
            CMP.B #10,D4
            BLT PRINTNUM
            BRA PRINTLET
            
            
PHEXIT      RTS
            
            
            
            
PRINTNUM    ADD.B #$30, D1
            MOVE.B #6, D0
            TRAP #15
            
            CMP.B #0, D6
            BEQ SWAP
            
            SUB.B #1, D5
            BRA PRINTHEX


PRINTLET    SUB.B #9, D1
            ADD.B #$40, D1
            MOVE.B #6, D0
            TRAP #15
            
            CMP.B #0, D6
            BEQ SWAP
            
            SUB.B #1, D5
            BRA PRINTHEX

SWAP        MOVE.B #1, D6
            BRA PRINTSEC
 
 
            
            
            

            

* Put program code here

            SIMHALT             ; halt simulator

* Put variables and constants here

CR          EQU     $0D
LF          EQU     $0A

MSSG        DC.B    'Please enter a byte sized hex number using capital letters:',0
ADDRSTR     DC.B    'Addr1: ',0
ADDSUMSTR   DC.B    'Addsum: ',0
CBSTR       DC.B    'CarryBit: ',0
NEWLINE     DC.B    CR,LF,0


Addr1       DS.L    1
Addsum      DS.W    1
CarryBit    DS.B    1




    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
