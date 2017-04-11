*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
START   ORG     $1000 ; first instruction of program

*-------Code for output-------
        LEA     MESSAGE,A1
        MOVE.B  #14,D0
        TRAP    #15
        
        MOVE.B  #9,D0
        TRAP    #15

CR      EQU     $0D
LF      EQU     $0A
MESSAGE DC.B    'Hello. My name is Jeremy DeHaan.',CR,LF
        DC.B    'I like video games, and board games, and I recently started DMing for D&D. So',CR,LF
        DC.B    'far, I am very much enjoying this class. There is a lot that I think will be',CR,LF
        DC.B    'applicable to my independent study.',CR,LF
        DC.B    CR,LF
        DC.B    'Thank you for listening.',CR,LF,0

        END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
