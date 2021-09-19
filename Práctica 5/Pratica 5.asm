LIST P=PIC16F84
#INCLUDE <p16f84.inc>
__CONFIG _CP_OFF &_WDT_OFF &_PWRTE_ON &_XT_OSC

Status EQU 0x03
PortA EQU 0x05
TrisA EQU 0x85
PortB EQU 0x06
TrisB EQU 0x86
Count EQU 0x0C
Count2 EQU 0x0D
Count3 EQU 0x0E
	ORG 0x00
	GOTO Main
	ORG 0x03

Main
BSF Status,5		;Ve al banco 1
MOVLW B'00000011'	;Mueve B'00000011' a W
MOVWF TrisA			;Mueve W a TrisA
MOVLW B'00000000'	;Mueve B'00000000' a W
MOVWF TrisB			;Mueve W a TrisB
BCF Status,5		;Ve al banco 0

Loopra0
BTFSS PortA,0		;¿PortA = 1?
GOTO Loopoffra0		;No, entonces ve a Loopoffra0
GOTO Loopled		;Si, entonces ve a Loopled

Loopoffra0
CLRF PortB			;Borra PortB
GOTO Loopra0		;Ve a Loopra0

Loopled
CALL Delay			;Llama Delay
RLF PortB			;Rota a la izquierda PortB
BTFSC PortB,6		;¿PortB,6 = 0?
GOTO Loopra0		;No, entonces ve a Loopra0
BTFSS PortB,4		;Si, pero ¿PortB,4 = 1?
GOTO Loopled		;No, entonces ve a Loopled
GOTO Loopra1		;Si, entonces ve a Loopra1

Loopra1
BTFSS PortA,1		;¿PortA,1 = 1?
GOTO Loopra1		;No, entonces ve a Loopra1
GOTO Loopled		;Si, entonces ve a Loopled

Delay
MOVLW .256			;Mueve .256 a W
MOVWF Count			;Mueve W a Count
Loopcount2
MOVLW .256			;Mueve .256 a W
MOVWF Count2		;Mueve .256 a Count2
Loopcount3
MOVLW .14			;Mueve .14 a W
MOVWF Count3		;Mueve W a Count3
Loopdec
DECFSZ Count3		;¿Count3 decrementó = 0?
GOTO Loopdec		;No, entonces ve a Loopdec
DECFSZ Count2		;Si, entonces ¿Count2 decrementó = 0?
GOTO Loopcount3		;No, entonces ve a Loopcount3
DECFSZ Count		;Si, entonces ¿Count decrementó = 0?
GOTO Loopcount2		;No, entonces ve a Loopcount2

RETURN

END

