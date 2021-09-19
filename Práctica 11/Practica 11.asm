LIST P=PIC16F84A
#INCLUDE <p16f84a.inc>
__CONFIG _CP_OFF &_WDT_OFF &_PWRTE_ON &_XT_OSC

Status EQU 0x03
PortA EQU 0x05
TrisA EQU 0x85
PortB EQU 0x06
TrisB EQU 0x86
Key	EQU 0x0C
;Count2 EQU 0x0D
;Count3 EQU 0x0E
	ORG 0x00
	GOTO Main
	ORG 0x05

Main
BSF Status,5
MOVLW B'00010000'	;B'00011011' (0,2) B'0001110' (0,1)
MOVWF TrisA
MOVLW B'00000000'
MOVWF TrisB
BCF Status,5
CLRF PortB

Loopra4
BTFSS PortA,4
GOTO Loopoffra4
GOTO Load

Loopoffra4
MOVLW B'01100001'	;Retorna si PCL = .2
MOVWF PortB			;Prende el Display
GOTO Loopra4		;Ve a Loopra4

Load
BCF Status,2
BCF Status,0
CLRF Key  
MOVF PortA,0
MOVWF Key
MOVLW B'00010000'
XORWF Key,0
;GOTO Find
;Find
;SUBLW .5
;BTFSS Status,2
;GOTO Loopkeya12
;BTFSS Status,0
;GOTO Loopkeya12
;MOVLW B'00111111'	;0
;GOTO Show
;RETURN
;Loopkeya12 
;BCF Status,2
;BCF Status,0
;SUBLW .9
;BTFSS Status,2
;GOTO Loopkeya21
;BTFSS Status,0
;GOTO Loopkeya21
;MOVLW B'00000110'	;1
;GOTO Show
;RETURN
;Loopkeya21
;BCF Status,2
;BCF Status,0
;SUBLW .6
;BTFSS Status,2
;GOTO Loopkeya22
;BTFSS Status,0
;GOTO Loopkeya22
;MOVLW B'01011011'	;2
;GOTO Show
;RETURN
;Loopkeya22
;BCF Status,2
;BCF Status,0
;SUBLW .10
;BTFSS Status,2
;GOTO Looprb7
;BTFSS Status,0
;GOTO Looprb7
;MOVLW B'11001111'	;3
;GOTO Show
;RETURN

;CALL DelayLCD
;Show
CALL Table
MOVWF PortB
GOTO Loopra4

;Looprb7
;MOVLW B'10000000'
;MOVWF PortB
;GOTO Loopra4

Table
ADDWF PCL
RETLW B'10000000'	;Retorna .0
RETLW B'10000000'	;Retorna .1
RETLW B'10000000'	;Retorna .2
RETLW B'10000000'	;Retorna .3
RETLW B'10000000'	;Retorna .4
RETLW B'00111111'	;Retorna .5  (a11)
RETLW B'01011011'	;Retorna .6  (a21)
RETLW B'10000000'	;Retorna .7
RETLW B'10000000'	;Retorna .8
RETLW B'00000110'	;Retorna .9  (a12)
RETLW B'11001111'	;Retorna .10 (a22)
RETLW B'10000000'	;Retorna .11
RETLW B'10000000'	;Retorna .12
RETLW B'10000000'	;Retorna .13
RETLW B'10000000'	;Retorna .14
RETLW B'10000000'	;Retorna .15
RETLW B'10000000'	;Retorna .16

;Find
;SUBLW .5
;BTFSS Status,2
;GOTO Loopkeya12
;BTFSS Status,0
;GOTO Loopkeya12
;MOVLW B'00111111'	;0
;RETURN
;Loopkeya12 
;BCF Status,2
;BCF Status,0
;SUBLW .9
;BTFSS Status,2
;GOTO Loopkeya21
;BTFSS Status,0
;GOTO Loopkeya21
;MOVLW B'00000110'	;1
;RETURN
;Loopkeya21
;BCF Status,2
;BCF Status,0
;SUBLW .6
;BTFSS Status,2
;GOTO Loopkeya22
;BTFSS Status,0
;GOTO Loopkeya22
;MOVLW B'01011011'	;2
;RETURN
;Loopkeya22
;BCF Status,2
;BCF Status,0
;SUBLW .10
;BTFSS Status,2
;GOTO Looprb7
;BTFSS Status,0
;GOTO Looprb7
;MOVLW B'11001111'	;3
;RETURN

;DelayLCD
;MOVLW .256			;Mueve .256 a W
;MOVWF Count2		;Mueve W a Count2
;Loopcount3
;MOVLW .256			;Mueve .256 a W
;MOVWF Count3		;Mueve .256 a Count3
;Loopdec
;DECFSZ Count3		;¿Count3 decrementó = 0?
;GOTO Loopdec		;No, entonces ve a Loopdec
;DECFSZ Count2		;Si, entonces ¿Count2 decrementó = 0?
;GOTO Loopcount3		;No, entonces ve a Loopcount2
;RETURN

RETURN

END