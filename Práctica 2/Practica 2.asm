LIST P=PIC16F84
#INCLUDE <p16f84.inc>
__CONFIG _CP_OFF &_WDT_OFF &_PWRTE_ON &_XT_OSC

Status EQU 0x03
PortB EQU 0x06
TrisB EQU 0x86
Count EQU 0x0C
Count2 EQU 0x0D
Count3 EQU 0x0E
	ORG 0x00
	GOTO Main
	ORG 0x05

Main
BSF Status,5		;Pasa al banco 1
MOVLW B'00000001'	;Mueve B'00000001' a W
MOVWF TrisB			;Mueve W a TrisB
BCF Status,5		;Pasa al banco 0

Looprb0
BTFSS PortB,0		;¿PortB,0 = 1?
GOTO Loopoffrb1		;No, entonces ve a Loopoffrb1
GOTO Looprb1		;Si, entonces ve a Looprb1

Loopoffrb1
BCF PortB,1			;Apaga el LED
GOTO Looprb0		;Ve a Looprb0

Looprb1
BSF PortB,1			;Prende el LED
CALL Delay			;Llama al ciclo Delay (5s)
GOTO Loopoffrb1		;Ve a Loopoffrb1

Delay
MOVLW B'00000000'	;Mueve .256 a W
MOVWF Count			;Mueve W a Count

	Loopcount2
	MOVLW B'00000000'	;Mueve .256 a W
	MOVWF Count2		;Mueve .256 a Count2
	
	Loopcount3
	MOVLW B'01000001'	;Mueve .65 a W
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