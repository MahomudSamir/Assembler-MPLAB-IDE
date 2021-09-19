LIST P=PICF1684
#INCLUDE <p16f84.inc>
__CONFIG _CP_OFF &_WDT_OFF &_PWRTE_ON &_XT_OSC

Status EQU 0x03
PortA EQU 0x05
TrisA EQU 0x85
PortB EQU 0x06
TrisB EQU 0x86
TMR0 EQU 0x01
OPTIONN EQU 0x81
INTCON EQU 0x0B
Count EQU 0x0C
Count2 EQU 0x0D
Count3 EQU 0x0E
;COUNT EQU 0x0D
	ORG 0x00
	GOTO Main
	ORG 0x05

Main
BSF Status,5		;Ve al banco 1
MOVLW B'00111000'	;Mover B'00111000' a W
MOVWF OPTIONN		;Mover W a OPTIONN
MOVLW B'00010000'	;Mover B'00010000' a W
MOVWF TrisA			;Mover W a TrisA
MOVLW B'00000001'	;Mover B'00000001' a W
MOVWF TrisB			;Mover W a TrisB
BCF Status,5		;Ve al banco 0
BCF PortB,1

Looprb0
BTFSS PortB,0		;¿PortB,0 = 1?
GOTO Looprb0		;No, entonces ve a Looprb0
MOVLW .251			;Si, entonces mueve .251 a W
MOVWF TMR0			;Mueve W a TMR0
BCF INTCON,2		;Limpia TOIF
GOTO Looprb1		;Ve a Looprb1

Looprb1
BTFSS INTCON,2		;¿TOIF = 1?
GOTO Looprb1		;No, entonces ve a Looprb1
BSF PortB,1			;Si, entonces pon 1 en PortB,1
CALL Delay			;Llama Delay
BCF PortB,1			;Pon 0 en PortB,1
GOTO Looprb0		;Ve a Looprb0

;Delay
;BSF Status,5		;Ve al banco 1
;MOVLW B'00000111'	;Mueve B'00000111' a W
;MOVWF OPTIONN		;Mueve W a OPTIONN
;BCF Status,5		;Ve al banco 0
;MOVLW .191			;Mueve .191 a W
;MOVWF COUNT			;Mueve W a COUNT
;Loopclrf
;CLRF TMR0			;Limpia TMR0
;BCF INTCON,2		;Limpia TOIF
;Loopdec
;BTFSS INTCON,2		;¿TOIF = 1?
;GOTO Loopdec		;No, entonces ve a Loopdec
;DECFSZ COUNT		;Si, entonces decrementa COUNT
;GOTO Loopclrf		;Ve a Loopclrf

Delay
MOVLW .256			;Mueve .256 a W
MOVWF Count			;Mueve W a Count
Loopcount2
MOVLW .256			;Mueve .256 a W
MOVWF Count2		;Mueve .256 a Count2
Loopcount3
MOVLW .64			;Mueve .14 a W
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