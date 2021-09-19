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
MOVLW B'00000111'	;Mueve B'00000111' a W
MOVWF TrisA			;Mueve W a TrisA
MOVLW B'00000000'	;Mueve B'00000000' a W
MOVWF TrisB			;Mueve W a TrisB
BCF Status,5		;Pasa al banco 0
BCF PortB,0 		;Coloca 0 en PortB,0 (RB0)
BCF PortB,1			;Coloca 0 en PortB,1 (RB1)

LoopRA0
BTFSS PortA,0		;¿PortA,0 = 1?
GOTO LoopoffRA0		;No, entonces ve a LoopoffRA0
GOTO LoopRA1		;Si, entonces ve a LoopRA1

	LoopoffRA0
	BCF PortB,0			;Coloca 0 en PortB,0 (RB0)
	BCF PortB,1			;Coloca 0 en PortB,1 (RB1)
	GOTO LoopRA0		;Ve a LoopRA0

LoopRA1
BTFSS PortA,1		;¿PortA,1 = 1?
GOTO LoopoffRA1		;No, entonces ve a LoopoffRA1
GOTO LoopRB0		;Si, entonces ve a LoopRB0

	LoopoffRA1
	BCF PortB,0			;Coloca 0 en PortB,0 (RB0)
	GOTO LoopRA2		;Ve a LoopRA2

	LoopRB0
	BSF PortB,0			;Coloca 1 en PortB,0 (RB0)
	GOTO LoopRA2		;Ve a LoopRA2

LoopRA2
BTFSS PortA,2		;¿PortA,2 = 1?
GOTO LoopoffRA2		;No, entonces ve a LoopoffRA2
GOTO LoopRB1		;Si, entonces ve a LoopRB1

	LoopoffRA2
	BCF PortB,1			;Coloca 0 en PortB,1 (RB1)
	GOTO LoopRA0		;Ve a LoopRA0

	LoopRB1
	BSF PortB,1			;Coloca 1 en PortB,1 (RB1)
	GOTO LoopRA0		;Ve a LoopRA0

END