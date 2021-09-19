LIST P=PIC16F84
#INCLUDE <p16f84.inc>
__CONFIG _CP_OFF &_WDT_OFF &_PWRTE_ON &_XT_OSC

Status EQU 0x03
PortA EQU 0x05
TrisA EQU 0x85
PortB EQU 0x06
TrisB EQU 0x86
Key	EQU 0x0F
Count EQU 0x0C
Count2 EQU 0x0D
Count3 EQU 0x0E
	ORG 0x00
	GOTO Main
	ORG 0x05

Main
BSF Status,5		;Paso al banco 1
MOVLW B'00001111'
MOVWF TrisA
MOVLW B'00000000'
MOVWF TrisB
BCF Status,5		;Paso al banco 0
CLRF PortA			;Limpio PortA
CLRF PortB			;Limpio PortB
GOTO Keypad

Keypad
CLRF Key
MOVF PortA,0
MOVWF Key
MOVLW B'00010000'
XORWF Key,0
CALL Table
SUBLW .63
BTFSC Status,2
GOTO LCD_Inicia
SUBLW .6
BTFSC Status,2
GOTO LCD_Start
GOTO Keypad

Table
ADDWF PCL
RETLW B'10000000'	;Retorna .0
RETLW B'10000000'	;Retorna .1
RETLW B'10000000'	;Retorna .2
RETLW B'10000000'	;Retorna .3
RETLW B'10000000'	;Retorna .4
RETLW B'00111111'	;Retorna .5  <- <-
RETLW B'01011011'	;Retorna .6  <-
RETLW B'10000000'	;Retorna .7
RETLW B'10000000'	;Retorna .8
RETLW B'00000110'	;Retorna .9  <- <-
RETLW B'11001111'	;Retorna .10 <-
RETLW B'10000000'	;Retorna .11
RETLW B'10000000'	;Retorna .12
RETLW B'10000000'	;Retorna .13
RETLW B'10000000'	;Retorna .14
RETLW B'10000000'	;Retorna .15
RETLW B'10000000'	;Retorna .16

;----------------------------------------------------------------

LCD_Inicia
MOVLW B'00111000'	;(FUNCTION SET) F = 5x7 puntos, N = 2 lineas, DL = 8 bit
CALL Control_Inicia		;Llamo a Control
MOVLW B'00001100'	;(DISPLAY CONTROL) B = parpadeo off, C = cursor off, D = display on
CALL Control_Inicia		;Llamo a Control
MOVLW B'00000001'	;(CLEAR DISPLAY)

Restart_Inicia
CLRF Count			;Limpio Count

Show_Inicia
MOVF Count,0		;Muevo Count a W
CALL Table_Inicia	;Llamo a Table
CALL Character_Inicia		;Llamo a Character
INCF Count			;Incremento Count
MOVLW .15			;Muevo .15 a W
XORWF Count,0		;W (XOR) F, guardo en W
BTFSS Status,2		;¿Status,2 = 1?
GOTO Show_Inicia			;No, entonces ve a Show
;CALL Delay			;Si, entonces llama a Delay
MOVLW B'00000001'	;Mueve B'00000001' a W
CALL Control_Inicia		;Llama a Control
;CALL Delay			;Llama a Delay
GOTO Restart_Inicia		;Ve a Restart

Table_Inicia
ADDWF PCL			;Añade W a PCL
DT "Hola Mundo! ;)";Muestra

Character_Inicia
BSF PortA,0			;Porta,0 = 1 (Rs = 1)
GOTO Load_Inicia			;Ve a Load

Control_Inicia
BCF PortA,4			;Rs = 0, Modo Comando Rs = 0 y R/W = 0, Modo Lectura Rs = 0 y R/W = 1 *************************

Load_Inicia
MOVWF PortB			;Mueve W a F
BSF PortA,1			;PortA,1 = 1
CALL DelayLCD		;Llama a DelayLCD (78,74ms)
BCF PortA,1			;PortA,1 = 0
CALL DelayLCD		;Llama a DelayLCD (78,74ms)

;Delay
;MOVLW .10			;Mueve .10 a W
;GOTO Loopcount		;Ve a Loopcount
DelayLCD
MOVLW .256			;Mueve .256 a W
;Loopcount
MOVWF Count2		;Mueve W a Count2
Loopcount2
MOVLW .256			;Mueve .256 a W
MOVWF Count3		;Mueve .256 a Count3
Loopdec
DECFSZ Count3		;¿Count3 decrementó = 0?
GOTO Loopdec		;No, entonces ve a Loopdec
DECFSZ Count2		;Si, entonces ¿Count2 decrementó = 0?
GOTO Loopcount2		;No, entonces ve a Loopcount2


;----------------------------------------------------------------

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
CALL Table_Start	;Llamo a Table
CALL Character		;Llamo a Character
INCF Count			;Incremento Count
MOVLW .15			;Muevo .15 a W
XORWF Count,0		;W (XOR) F, guardo en W
BTFSS Status,2		;¿Status,2 = 1?
GOTO Show			;No, entonces ve a Show
;CALL Delay			;Si, entonces llama a Delay
MOVLW B'00000001'	;Mueve B'00000001' a W
CALL Control		;Llama a Control
;CALL Delay			;Llama a Delay
GOTO Restart		;Ve a Restart

Table_Start
ADDWF PCL			;Añade W a PCL
DT "Hello World! ;)";Muestra

Character
BSF PortA,0			;Porta,0 = 1 (Rs = 1)
GOTO Load			;Ve a Load

Control
BCF PortA,4			;Rs = 0, Modo Comando Rs = 0 y R/W = 0, Modo Lectura Rs = 0 y R/W = 1 *************************

Load
MOVWF PortB			;Mueve W a F
BSF PortA,1			;PortA,1 = 1
CALL DelayLCD_Start		;Llama a DelayLCD (78,74ms)
BCF PortA,1			;PortA,1 = 0
CALL DelayLCD_Start		;Llama a DelayLCD (78,74ms)

;Delay
;MOVLW .10			;Mueve .10 a W
;GOTO Loopcount		;Ve a Loopcount
DelayLCD_Start
MOVLW .256			;Mueve .256 a W
;Loopcount
MOVWF Count2		;Mueve W a Count2
Loopcount2_Start
MOVLW .256			;Mueve .256 a W
MOVWF Count3		;Mueve .256 a Count3
Loopdec_Start
DECFSZ Count3		;¿Count3 decrementó = 0?
GOTO Loopdec_Start		;No, entonces ve a Loopdec
DECFSZ Count2		;Si, entonces ¿Count2 decrementó = 0?
GOTO Loopcount2_Start	;No, entonces ve a Loopcount2

RETURN

END