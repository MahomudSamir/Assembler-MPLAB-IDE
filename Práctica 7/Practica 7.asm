LIST P=PICF1684
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
MOVLW B'00001111'	;Mueve B'00001111' a W
MOVWF TrisA			;Mueve W a TrisA
MOVLW B'00000000'	;Mueve B'00000000' a W
MOVWF TrisB			;Mueve W a TrisB
BCF Status,5		;Pasa al banco 0
CLRF PortB			;Limpia PortB

Loopra3
BTFSS PortA,3		;¿PortA,3 = 1?
GOTO Loopoffra3		;No, entonces ve a Loopoffra3
GOTO Loopread		;Si, entonces ve a Loopread

Loopoffra3
MOVLW B'01111111'	;Mueve B'01111111' a W
MOVWF PortB			;Prende el Display
GOTO Loopra3		;Ve a Loopra3

Loopread
MOVF PortA,0		;Mueve PortA a W
ANDLW B'00000111'	;Aplica W (AND) B'00000111'
CALL Table			;Llama al ciclo Table
MOVWF PortB			;Mueve W a PorB
GOTO Loopra3		;Ve a Loopra3

Table
ADDWF PCL			;PCL tendra el valor de W
RETLW B'00001010'	;Retorna si PCL = .0
RETLW B'00001001'	;Retorna si PCL = .1
RETLW B'00100011'	;Retorna si PCL = .2
RETLW B'00001111'	;Retorna si PCL = .3
RETLW B'00100000'	;Retorna si PCL = .4
RETLW B'00000111'	;Retorna si PCL = .5
RETLW B'00010111'	;Retorna si PCL = .6
RETLW B'00111111'	;Retorna si PCL = .7

RETURN

END