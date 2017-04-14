*-----------------------------------------------------------
* Title      : Hello 68K World
* Written by : Jeremy DeHaan
* Date       : 04/10/2017
* Description: This program is my introduction into the world
*              of 68k Assembly. It gives a breif description
*              of me, and then exits.
*-----------------------------------------------------------
START   ORG     $1000 ; first instruction of program

*-------Code for output-------
        LEA     MESSAGE,A1  ; loads MESSAGE address into A1
        MOVE.B  #13,D0      ; moves 14 into D0
        TRAP    #15         ; runs the I/O command with code #14(print text)
        
        MOVE.B  #9,D0       ; moves 9 into D0
        TRAP    #15         ; runs the I/O command with code #9(halt program)


*-----Text replacements-------
CR      EQU     $0D
LF      EQU     $0A

*-------Constants-------------
MESSAGE DC.B    'Hello. My name is Jeremy DeHaan.',CR,LF
        DC.B    'I like video games, and board games, and I recently started DMing for D&D. So',CR,LF
        DC.B    'far, I am very much enjoying this class. There is a lot that I think will be',CR,LF
        DC.B    'useful in understanding how to fine-tune code for the best performance.',CR,LF
        DC.B    CR,LF
        DC.B    'Thank you for listening.',CR,LF,0

        END    START        ; last line of source



*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
