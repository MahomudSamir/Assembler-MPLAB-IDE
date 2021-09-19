LIST P=PIC16F84
#INCLUDE <p16f84.inc>
__CONFIG _CP_OFF &_WDT_OFF &_PWRTE_ON &_XT_OSC

Status EQU 0x03
PortA EQU 0x05
TrisA EQU 0x85
PortB EQU 0x06
TrisB EQU 0x86
	ORG 0x00
	GOTO Main
	ORG 0x05

Main
BSF Status,5		;Pasa al banco 1
MOVLW B'00011111'	;Mueve B'00011111' a W
MOVWF TrisA			;Mueve W a TrisA
MOVLW B'00000000'	;Mueve B'00000000' a W
MOVWF TrisB			;Mueve W a TrisB
BCF Status,5		;Pasa al banco 0

Loopra4
BTFSS PortA,4		;¿PortA,4 = 1?
GOTO Loopoffra4		;No, entonces ve a Loopoffra4
GOTO Loopread		;Si, entonces ve a Loopread

Loopoffra4
MOVLW B'01111111'	;Mueve B'01111111' a W
MOVWF PortB			;Prende el Display
GOTO Loopra4		;Ve a Loopra4

Loopread
MOVF PortA,0		;Mueve PortA a W
ANDLW B'00001111'	;Aplica W (AND) B'00001111'
CALL Table			;Llama al ciclo Table
MOVWF PortB			;Mueve W a PortB
GOTO Loopra4		;Ve a Loopra4

Table
ADDWF PCL			;PCL Tendra el valor de W
RETLW B'01110111'	;Retorna si PCL = .0
RETLW B'01111100'	;Retorna si PCL = .1
RETLW B'01100001'	;Retorna si PCL = .2
RETLW B'01011110'	;Retorna si PCL = .3
RETLW B'01111001'	;Retorna si PCL = .4
RETLW B'01110001'	;Retorna si PCL = .5
RETLW B'01101111'	;Retorna si PCL = .6
RETLW B'01110110'	;Retorna si PCL = .7
RETLW B'00000110'	;Retorna si PCL = .8
RETLW B'00001111'	;Retorna si PCL = .9
RETLW B'01000000'	;Retorna si PCL = .10
RETLW B'00111000'	;Retorna si PCL = .11
RETLW B'00110111'	;Retorna si PCL = .12
RETLW B'00100011'	;Retorna si PCL = .13
RETLW B'01100011'	;Retorna si PCL = .14
RETLW B'01110011'	;Retorna si PCL = .15

RETURN

END