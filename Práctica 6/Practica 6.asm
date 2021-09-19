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
	  ORG 0x05

Main
BSF Status,5		;Ve al banco 1
MOVLW B'00000011'	;Mueve B'00000011' a W
MOVWF TrisA			;Mueve W a TrisA
MOVLW B'00000000'	;Mueve B'00000000' a W
MOVWF TrisB			;Mueve W a TrisB
BCF Status,5		;Ve al banco 0
CLRF PortB			;Limpia PortB

Loopra0
BTFSS PortA,0		;¿PortA,0 = 1?
GOTO Loopoffportb	;No, entonces ve a Loopoffporta
GOTO Loopportb		;Si, entonces ve a Loopporta

Loopoffportb
CALL Delay			;Llama a Delay
MOVLW B'00000000'	;Mueve B'00000000' a W
MOVWF PortB			;Mueve W a PortB
GOTO Loopra0		;Ve a Loopra0

Loopportb
CALL Delay			;Llama a Delay
RLF PortB			;Rota a la izquierda
BTFSC PortB,7		;¿PortB,7 = 0?
GOTO Loopresetportb	;No, entonces ve a Loopoffportb
BTFSS PortB,4		;Si, pero ¿PortB,4 = 1?
GOTO Loopportb		;No, entonces ve a Loopportb
BTFSS PortA,1		;Si, pero ¿PortA,1 = 1?
GOTO Loopresetportb	;No, entonces ve a Loopoffportb
GOTO Loopportb		;Si, entonces ve a Loopportb

Loopresetportb
CALL Delay			;Llama a Delay
MOVLW B'00000001'	;Mueve B'00000001' a W
MOVWF PortB			;Mueve W a PortB
GOTO Loopportb		;Ve a Loopportb

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