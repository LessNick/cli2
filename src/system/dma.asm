;---------------------------------------
; CLi² (Command Line Interface) dma
; 2016 © breeze/fishbone crew
;---------------------------------------

;---------------------------------------
; Code by Budder^MGN
;---------------------------------------
DMAPL   CP #FC:JR Z,PDST3
        CP #FB:JR Z,PDST4
        CP #FA:JR Z,PDST5
        CP #F9:JR Z,PDST6
        CP #F8:JR Z,PDST7

        CP #FF:JR Z,DSTS
        CP #FE:JR Z,PDST1
        CP #FD:JR Z,PDST2

        OR A:JR Z,PDISD
        DEC A:JR Z,PDIS
        DEC A:JR Z,PDID
        DEC A:JR Z,PDISP
        DEC A:JR Z,PDIDP
        DEC A:JR Z,PDIT
        DEC A:JR Z,PDIN;6

        DEC A:JP Z,PDITN
        DEC A:JP Z,PDISSA
        DEC A:JP Z,PDISDA
        DEC A:JP Z,PDISAS
        DEC A:JP Z,PDISDS;11
        RET
