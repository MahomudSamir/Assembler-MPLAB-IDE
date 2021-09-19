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
BSF Status,5		;Paso al banco 1
CLRF TrisA			;Limpio TrisA
CLRF TrisB			;Limpio TrisB
BCF Status,5		;Paso al banco 0
CLRF PortA			;Limpio PortA
CLRF PortB			;Limpio PortB

LCD_Start
MOVLW B'00111000'	;(FUNCTION SET) F = 5x7 puntos, N = 2 lineas, DL = 8 bit
CALL Control		;Llamo a Control
MOVLW B'00001100'	;(DISPLAY CONTROL) B = parpadeo off, C = cursor off, D = display on
CALL Control		;Llamo a Control
MOVLW B'00000001'	;(CLEAR DISPLAY)

Restart
CLRF Count			;Limpio Count

Show
MOVF Count,0		;Muevo Count a W
CALL Table			;Llamo a Table
CALL Character		;Llamo a Character
INCF Count			;Incremento Count
MOVLW .16			;Muevo .16 a W (Largo de la oracion, Max = .16
XORWF Count,0		;W (XOR) F, guardo en W
BTFSS Status,2		;¿Status,2 = 1?
GOTO Show			;No, entonces ve a Show
MOVLW B'00000001'	;Mueve B'00000001' a W
CALL Control		;Llama a Control
GOTO Restart		;Ve a Restart

Table
ADDWF PCL			;Añade W a PCL
DT "Hello World! ;)";Muestra

Character
BSF PortA,0			;Porta,0 = 1 (Rs = 1)
GOTO Load			;Ve a Load

Control
BCF PortA,0			;Rs = 0, Modo Comando Rs = 0 y R/W = 0, Modo Lectura Rs = 0 y R/W = 1

Load
MOVWF PortB			;Mueve W a F
BSF PortA,1			;PortA,1 = 1
CALL DelayLCD		;Llama a DelayLCD (78,74ms)
BCF PortA,1			;PortA,1 = 0
CALL DelayLCD		;Llama a DelayLCD (78,74ms)

DelayLCD
MOVLW .256			;Mueve .256 a W
MOVWF Count2		;Mueve W a Count2
Loopcount3
MOVLW .256			;Mueve .256 a W
MOVWF Count3		;Mueve .256 a Count3
Loopdec
DECFSZ Count3		;¿Count3 decrementó = 0?
GOTO Loopdec		;No, entonces ve a Loopdec
DECFSZ Count2		;Si, entonces ¿Count2 decrementó = 0?
GOTO Loopcount3		;No, entonces ve a Loopcount2

RETURN

END