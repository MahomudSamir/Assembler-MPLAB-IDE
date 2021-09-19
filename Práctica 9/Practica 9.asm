
    include<P16f877A.inc>

 __CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _BOREN_ON & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF
    ;Declaración de VARIABLES

    ;Guarda el número de tecla pulsada
#DEFINE BANDERA_CONTRA 0X40,0
#DEFINE BANDERA_MENU1 0X41,0
#DEFINE BANDERA_MENU2 0X42,0
#DEFINE BANDERA_USER_1 0X43,0
#DEFINE BANDERA_USER_2 0X44,0
#DEFINE BANDERA_TECLEA_1 0X45,0
#DEFINE BANDERA_TECLEA_2 0X46,0
#DEFINE BANDERA_CAMBIO_1 0X47,0
#DEFINE BANDERA_CAMBIO_2 0X48,0
#DEFINE BANDERA_ADMIN    0X49,0
#DEFINE BANDERA_TECLEA_ADMIN    0X49,1
#DEFINE BANDERA_OPCION_USER1_CAMBIO 0X49,2
#DEFINE BANDERA_OPCION_USER2_CAMBIO 0X49,3
numTecla equ h'30'

    ;Para el DELAY (Estabilización de la Señal ENABLE-LCD)
cont1 equ 0x31
cont2 equ 0x32
TEMP equ 0x33
TEMP2 equ 0x34
cont2M  EQU 0X35
cont1M  EQU 0X36
VAR1  EQU 0X50
VAR2  EQU 0X51
VAR3  EQU 0X52
VAR4  EQU 0X53
VAR1_1  EQU 0X54
VAR2_1  EQU 0X55
VAR3_1  EQU 0X56
VAR4_1  EQU 0X57
VAR1_2  EQU 0X58
VAR2_2  EQU 0X59
VAR3_2  EQU 0X5A
VAR4_2  EQU 0X5B
CONT_BLOQUEA_USER1  EQU  0X5C
CONT_BLOQUEA_USER2  EQU  0X5D
     ;Contador de caractéres
caracter equ h'33'

     org 0h                ;Vector de RESET
     goto INICIO           ;Etiqueta de inico
     org 05h               ;Inicio del programa



CONV_TECLA
     addwf PCL,1
     nop                  ;Linea 0 (no se utiliza)
     goto   UNO
     goto   DOS
     goto   TRES
     goto   AA
     goto   CUATRO
     goto   CINCO
     goto   SEIS
     goto   BB
     goto   SIETE
     goto   OCHO
     goto   NUEVE
     goto   CC
     goto   FF
     goto   CERO
     goto   EE
     goto   DD

INICIO
     clrf PORTB            ; Limpia PORTB
     clrf PORTC            ; Limpia PORTC
     clrf PORTD            ; Limpia PORTD
     bsf STATUS,RP0        ; Selecciona banco 1
     movlw  0x06
     movwf  ADCON1
     clrf   PORTA
     movlw 0xF0            ; PortB0-3 Salidas
     movwf TRISB           ; PortB4-7 Entradas
     clrf TRISC            ; PortC0-1 Salidas
     clrf TRISD            ; PortD0-7 Salidas
     bcf OPTION_REG,7      ; Habilita Resistencias de
                           ; polarización en entradas
     bcf STATUS,RP0        ; Selecciona  banco 0
     clrf   TEMP
     movlw  0x20
     movwf  FSR
     bcf    BANDERA_CONTRA
     bsf    BANDERA_MENU1
     bcf    BANDERA_MENU2
     bcf    BANDERA_TECLEA_1
     bcf    BANDERA_TECLEA_2
     BCF    BANDERA_CAMBIO_1
     BCF    BANDERA_CAMBIO_2

   movlw   .1
    movwf   VAR1

   movlw   .7
    movwf   VAR2

   movlw   .8
    movwf   VAR3

   movlw   .9
    movwf   VAR4
    clrf    CONT_BLOQUEA_USER1
    clrf    CONT_BLOQUEA_USER2

     ;Inicio
START
     clrf caracter
     call INICIA_LCD       ;Configura el LCD
     goto   ADMIN
     REGRESA_MENU
     goto NEW_SCAN         ;Comienza el SCAN del TECLADO

ADMIN
            bcf     PORTC,0
            movlw   b'00000001'
            movwf   PORTD
            bsf     PORTC,1
            NOP
            bcf     PORTC,1
            call     DELAY

   bcf    BANDERA_MENU2
    bcf    BANDERA_MENU1
    bcf     BANDERA_USER_1
    bcf     BANDERA_USER_2
    bcf    BANDERA_TECLEA_1
     bcf    BANDERA_TECLEA_2
     BCF    BANDERA_CAMBIO_1
      BCF    BANDERA_CAMBIO_2
      BSF   BANDERA_ADMIN

     clrf   TEMP
     movlw  0x20
     movwf  FSR
     bcf    BANDERA_CONTRA


     movlw  b'01000001' ;A
     movwf  PORTD
     call   ENVIAMENU

     movlw  b'01000100' ;D
     movwf  PORTD
     call   ENVIAMENU

     movlw  b'01001101' ;M
     movwf  PORTD
     call   ENVIAMENU

     movlw  b'01001001' ;I
     movwf  PORTD
     call   ENVIAMENU

     movlw  b'01001110' ;N
     movwf  PORTD
     call   ENVIAMENU

     movlw  b'00111010' ;:
     movwf  PORTD
     call   ENVIAMENU

     call   ASIGNA_VALORES_ADMIN


     goto   REGRESA_MENU
;**************************************************************************

MENU
            bcf     PORTC,0
            movlw   b'00000001'
            movwf   PORTD
            bsf     PORTC,1
            NOP
            bcf     PORTC,1
            call     DELAY

     clrf   TEMP
     movlw  0x20
     movwf  FSR
     bcf    BANDERA_CONTRA
    ;clrf    numTecla
    bsf    BANDERA_MENU2
    bcf    BANDERA_MENU1
    bcf     BANDERA_USER_1
    bcf     BANDERA_USER_2
    bcf    BANDERA_TECLEA_1
     bcf    BANDERA_TECLEA_2
     BCF    BANDERA_CAMBIO_1
      BCF    BANDERA_CAMBIO_2

     movlw  'A' ;A
     movwf  PORTD
     call   ENVIAMENU

     movlw  'D' ;D
     movwf  PORTD
     call   ENVIAMENU

     movlw  'M' ;M
     movwf  PORTD
     call   ENVIAMENU

     movlw  'I' ;I
     movwf  PORTD
     call   ENVIAMENU

     movlw  'N' ;N
     movwf  PORTD
     call   ENVIAMENU

     movlw  ':' ;
     movwf  PORTD
     call   ENVIAMENU

     movlw  '0' ;
     movwf  PORTD
     call   ENVIAMENU

     movlw  ' ' ;U
     movwf  PORTD
     call   ENVIAMENU

     movlw  'U' ;S
     movwf  PORTD
     call   ENVIAMENU

     movlw  'S' ;U
     movwf  PORTD
     call   ENVIAMENU

     movlw  'E' ;U
     movwf  PORTD
     call   ENVIAMENU

     movlw  'R' ;U
     movwf  PORTD
     call   ENVIAMENU

     movlw  ':' ;U
     movwf  PORTD
     call   ENVIAMENU

     movlw  '1' ;U
     movwf  PORTD
     call   ENVIAMENU

     movlw  '-' ;U
     movwf  PORTD
     call   ENVIAMENU

     movlw  '2' ;U
     movwf  PORTD
     call   ENVIAMENU

;******************CAMBIO DE LINEA

    bcf     PORTC,RC0
    movlw   b'11000000'
    movwf   PORTD
    call    ENVIABRINCO

     movlw  'S' ;S
     movwf  PORTD
     call   ENVIAMENU

     movlw  'E' ;E
     movwf  PORTD
     call   ENVIAMENU

     movlw  'L' ;L
     movwf  PORTD
     call   ENVIAMENU

     movlw  ':'
     movwf  PORTD
     call   ENVIAMENU

     goto   NEW_SCAN

;*******************************************************************************

ENVIABRINCO
     bcf    PORTC,0
     call   COMANDOMENUBRINCO
     return

COMANDOMENUBRINCO
    bsf     PORTC,1
    call    DELAYMENU
    bcf     PORTC,1
    return


ENVIAMENU
      bsf PORTC, 0          ; RS=1 MODO DATO
      call COMANDOMENU        ; Se da de alta el comando
      return

COMANDOMENU
     bsf PORTC, 1          ; Pone la señal ENABLE en 1
     call   DELAYMENU ; Espera estabilizar la señal           ; Espera estabilizar la señal
     bcf PORTC, 1          ; ENABLE=0          ; Espera estabilizar la señal
     return

DELAYMENU
     movlw .20
     movwf cont2M
loop1MENU
     movlw .20
     movwf cont1M

loop2MENU
     decfsz cont1M,1
     goto loop2MENU
     decfsz cont2M,1
     goto loop1MENU
     return

     ;Rutina para inicializar el lcd
INICIA_LCD
     bcf PORTC,0           ; RS=0 MODO INSTRUCCION
     movlw 0x01            ; 0x01 limpia la pantalla en el LCD
     movwf PORTD
     call COMANDO          ; Se da de alta el comando
     movlw 0x0C            ; Selecciona la primera línea
     movwf PORTD
     call COMANDO          ; Se da de alta el comando

     movlw 0x3C            ; Se configura el cursor
     movwf PORTD
     call COMANDO          ; Se da de alta el comando
     bsf PORTC, 0          ; Rs=1 MODO DATO
     return

     ;Rutina para enviar un dato
ENVIA
     bsf PORTC, 0          ; RS=1 MODO DATO
     call COMANDO          ; Se da de alta el comando
     return

     ;Subrutina para enviar INST. ó DATOS
COMANDO
     bsf PORTC, 1          ; Pone la señal ENABLE en 1
     call DELAY            ; Espera estabilizar la señal
     call DELAY            ; Espera estabilizar la señal
     bcf PORTC, 1          ; ENABLE=0
     call DELAY            ; Espera estabilizar la señal
     return

     ;Configuración Lineal 2 LCD
LINEA2
     bcf PORTC,0           ; RS=0 MODO INSTRUCCION
     movlw 0xC0            ; Selecciona línea 2 pantalla en el LCD
     movwf PORTD
     call COMANDO          ; Se da de alta el comando
     goto NEW_SCAN

     ; Rutina de retardo
     ; Para estabilizar la señal de ENABLE
DELAY
     movlw 0xFF
     movwf cont2
loop1
     movlw 0xFF
     movwf cont1

loop2
     decfsz cont1,1
     goto loop2
     decfsz cont2,1
     goto loop1
     return

     ;Escaneo del teclado
NEW_SCAN
     clrf numTecla         ; Borra el contenido de numTecla
     incf numTecla,1       ; Inicializa numTecla
     movlw b'00001110'     ; Pone a 0 la primera Fila ( PB0 )
     movwf PORTB
     Nop                   ; Espera estabilizar la señal

     ;Rutina que verifíca el estado de las columnas
CHK_COL
     ;Verifica si se ha presionado alguna tecla
     btfss PORTB,4         ; Columna 1=0?
     goto TECLA_ON         ; Sale si se ha pulsado una tecla
     incf numTecla,1       ; Incrementa número de tecla

     btfss PORTB,5         ; Columna 2=0?
     goto TECLA_ON         ; Sale si se ha pulsado una tecla
     incf numTecla,1       ; Incrementa número de tecla

     btfss PORTB,6         ; Columna 3=0?
     goto TECLA_ON         ; Sale si se ha pulsado una tecla
     incf numTecla,1       ; Incrementa número de tecla

     btfss PORTB,7         ; Columna 4=0?
     goto TECLA_ON         ; Sale si se ha pulsado una tecla
     incf numTecla,1       ; Incrementa número de tecla

     ;Verifica si se ha recorrido todo el teclado
     movlw d'17'           ; Número total de teclas + 1
     xorwf numTecla,w      ; Realiza d'17' XOR numTecla
     btfsc STATUS,Z        ; Verifica el estado de Z
     goto NEW_SCAN         ; Z=1?, Son iguales (full Scan)
                           ; Z=0?, Son diferentes,
NEXT_COL
     bsf STATUS,C    ; Enciende el carry para poner en "1" la FILA
                     ; recorrida
     rlf PORTB,1     ; Realiza corrimiento a la izquierda, pone a
                     ; cero la siguiente FILA
     goto CHK_COL    ; Escanea la sig. COLUMNA

     ;Rutina que procesa la tecla capturada
TECLA_ON

     ;Rutinas que esperan a que se deje de presionar la tecla
     ;Esto para evitar ECO
Espera1
     btfss   PORTB,4      ;Si no se suelta la tecla de la COL 1
     goto    Espera1      ;vuelve a esperar.
Espera2
     btfss   PORTB,5      ;Si no se suelta la tecla de la COL 2
     goto    Espera2      ;vuelve a esperar.
Espera3
     btfss   PORTB,6      ;Si no se suelta la tecla de la COL 3
     goto    Espera3      ;vuelve a esperar.
Espera4
     btfss   PORTB,7      ;Si no se suelta la tecla de la COL 4
     goto    Espera4      ;vuelve a esperar.

     ;Una vez que dejó de presionar la tecla

REGRESO_ASIGNACION
    movf numTecla,w      ; Pone en W el valor de numTecla
     goto CONV_TECLA      ; Llama a la rutina de conversión

REGRESO_CONV_TECLA

     btfsc  BANDERA_CONTRA
     goto   CONTRASEÑA_CORRECTA



     incf caracter,1      ; Incrementa contador de caracteres

     ;Verifica si se ha llenado la línea 1 de caracteres
     movlw d'16'           ; Nómero de caracteres
     xorwf caracter,w      ; Realiza d'16' XOR caracter
     btfsc STATUS,Z        ; Verifica el estado de Z
     goto LINEA2           ; z=1, Línea 1 llena
     ;Verifica si se ha llenado la línea 2 de caracteres
     movlw d'32'           ; NË?mero de teclas
     xorwf caracter,w      ; Realiza d'32' XOR caracter
     btfsc STATUS,Z        ; Verifica el estado de Z
     goto START            ; z=1, Línea 2 llena, reinicia
     goto NEW_SCAN         ; Realiza nuevo scan

     ;Rutina de conversión que retorna el valor en ASCII de
     ;numTecla en W
;***********************************************************************+
ASIGNA_VALORES_1
    movf    0X20,W   ;PRIMER DIGITO DE LA CLAVE
    movwf   VAR1_1

   movf    0X21,W  ;SEGUDNO DIGITO DE LA CLAVE
    movwf   VAR2_1

   movf    0X22,W
    movwf   VAR3_1

   movf    0X23,W
    movwf   VAR4_1

    goto    REGRESO_ASIGNACION

ASIGNA_VALORES_2
    movf    0X20,W     ;PRIMER DIGITO DE LA CLAVE
    movwf   VAR1_2

   movf    0X21,W    ;SEGUDNO DIGITO DE LA CLAVE
    movwf   VAR2_2

   movf    0X22,W    ;TERCERO DIGITO DE LA CLAVE
    movwf   VAR3_2

   movf    0X23,W
    movwf   VAR4_2

    goto    REGRESO_ASIGNACION

 ASIGNA_VALORES_ADMIN
 movlw   .1
    movwf   VAR1

   movlw   .7
    movwf   VAR2

   movlw   .8
    movwf   VAR3

   movlw   .9
    movwf   VAR4

  return



;**********************************************************************************
OPCION_USER_1

     bcf     PORTC,0
            movlw   b'00000001'
            movwf   PORTD
            bsf     PORTC,1
            NOP
            bcf     PORTC,1
            call     DELAY

     clrf   TEMP
     movlw  0x20
     movwf  FSR
    bcf    BANDERA_CONTRA
    clrf    numTecla
    bcf    BANDERA_MENU2
    bcf    BANDERA_MENU1
    bsf     BANDERA_USER_1
    bcf     BANDERA_USER_2
    bcf    BANDERA_TECLEA_1
    bcf    BANDERA_TECLEA_2
    BCF    BANDERA_CAMBIO_1
    BCF    BANDERA_CAMBIO_2
    bcf    BANDERA_ADMIN

     movlw  'U' ;A
     movwf  PORTD
     call   ENVIAMENU

     movlw  'S' ;D
     movwf  PORTD
     call   ENVIAMENU

     movlw  'E' ;M
     movwf  PORTD
     call   ENVIAMENU

     movlw  'R' ;I
     movwf  PORTD
     call   ENVIAMENU

     movlw  '1' ;N
     movwf  PORTD
     call   ENVIAMENU

     movlw  ' ' ;
     movwf  PORTD
     call   ENVIAMENU

     movlw  'O' ;
     movwf  PORTD
     call   ENVIAMENU

     movlw  'P' ;U
     movwf  PORTD
     call   ENVIAMENU

     movlw  '(' ;S
     movwf  PORTD
     call   ENVIAMENU

     movlw  '1' ;U
     movwf  PORTD
     call   ENVIAMENU

     movlw  '-' ;U
     movwf  PORTD
     call   ENVIAMENU

     movlw  '2' ;U
     movwf  PORTD
     call   ENVIAMENU

     movlw  ')' ;U
     movwf  PORTD
     call   ENVIAMENU

;******************CAMBIO DE LINEA

    bcf     PORTC,RC0
    movlw   b'11000000'
    movwf   PORTD
    call    ENVIABRINCO

     movlw  'S' ;S
     movwf  PORTD
     call   ENVIAMENU

     movlw  'E' ;E
     movwf  PORTD
     call   ENVIAMENU

     movlw  'L' ;L
     movwf  PORTD
     call   ENVIAMENU

     movlw  ':'
     movwf  PORTD
     call   ENVIAMENU

    goto    REGRESA_MENU

;*******************************************************************************
OPCION_USER_2

            bcf     PORTC,0
            movlw   b'00000001'
            movwf   PORTD
            bsf     PORTC,1
            NOP
            bcf     PORTC,1
            call     DELAY

     clrf   TEMP
     movlw  0x20
     movwf  FSR
     bcf    BANDERA_CONTRA
    clrf    numTecla
    bcf    BANDERA_MENU2
    bcf    BANDERA_MENU1
    bcf     BANDERA_USER_1
    bsf     BANDERA_USER_2
     bcf    BANDERA_TECLEA_1
     bcf    BANDERA_TECLEA_2
     BCF    BANDERA_CAMBIO_1
     BCF    BANDERA_CAMBIO_2
     bcf    BANDERA_ADMIN

     movlw  'U' ;A
     movwf  PORTD
     call   ENVIAMENU

     movlw  'S' ;D
     movwf  PORTD
     call   ENVIAMENU

     movlw  'E' ;M
     movwf  PORTD
     call   ENVIAMENU

     movlw  'R' ;I
     movwf  PORTD
     call   ENVIAMENU

     movlw  '2' ;N
     movwf  PORTD
     call   ENVIAMENU

     movlw  ' ' ;
     movwf  PORTD
     call   ENVIAMENU

     movlw  'O' ;
     movwf  PORTD
     call   ENVIAMENU

     movlw  'P' ;U
     movwf  PORTD
     call   ENVIAMENU

     movlw  '(' ;S
     movwf  PORTD
     call   ENVIAMENU

     movlw  '1' ;U
     movwf  PORTD
     call   ENVIAMENU

     movlw  '-' ;U
     movwf  PORTD
     call   ENVIAMENU

     movlw  '2' ;U
     movwf  PORTD
     call   ENVIAMENU

     movlw  ')' ;U
     movwf  PORTD
     call   ENVIAMENU

;******************CAMBIO DE LINEA

    bcf     PORTC,RC0
    movlw   b'11000000'
    movwf   PORTD
    call    ENVIABRINCO

     movlw  'S' ;S
     movwf  PORTD
     call   ENVIAMENU

     movlw  'E' ;E
     movwf  PORTD
     call   ENVIAMENU

     movlw  'L' ;L
     movwf  PORTD
     call   ENVIAMENU

     movlw  ':'
     movwf  PORTD
     call   ENVIAMENU




    goto    REGRESA_MENU



;*********************************************************************
OPCION_USER1_CAMBIO

            bsf     BANDERA_OPCION_USER1_CAMBIO
            btfsc   BANDERA_OPCION_USER1_CAMBIO
            goto    ADMIN

OPCION_USER1_CAMBIO2
            bcf     BANDERA_OPCION_USER1_CAMBIO

            bcf     PORTC,0
            movlw   b'00000001'
            movwf   PORTD
            bsf     PORTC,1
            NOP
            bcf     PORTC,1
            call     DELAY

        clrf   TEMP
        movlw  0x20
        movwf  FSR
        bcf    BANDERA_CONTRA
        clrf    numTecla
        bcf    BANDERA_MENU2
        bcf    BANDERA_MENU1
        bcf     BANDERA_USER_1
        bcf     BANDERA_USER_2
        bcf    BANDERA_TECLEA_1
        bcf    BANDERA_TECLEA_2
        BSF    BANDERA_CAMBIO_1
        BCF    BANDERA_CAMBIO_2
        bcf    BANDERA_ADMIN

     movlw  'N' ;A
     movwf  PORTD
     call   ENVIAMENU

     movlw  'U' ;D
     movwf  PORTD
     call   ENVIAMENU

     movlw  'E' ;M
     movwf  PORTD
     call   ENVIAMENU

     movlw  'V' ;I
     movwf  PORTD
     call   ENVIAMENU

     movlw  'A' ;N
     movwf  PORTD
     call   ENVIAMENU

     movlw  ':' ;
     movwf  PORTD
     call   ENVIAMENU

     goto    REGRESA_MENU

;******************************************************************************
OPCION_USER2_CAMBIO

            bsf     BANDERA_OPCION_USER2_CAMBIO
            btfsc   BANDERA_OPCION_USER2_CAMBIO
            goto    ADMIN

OPCION_USER2_CAMBIO2
            bcf     BANDERA_OPCION_USER2_CAMBIO

            bcf     PORTC,0
            movlw   b'00000001'
            movwf   PORTD
            bsf     PORTC,1
            NOP
            bcf     PORTC,1
            call     DELAY

            clrf   TEMP
            movlw  0x20
            movwf  FSR
            bcf    BANDERA_CONTRA
            clrf    numTecla
            bcf    BANDERA_MENU2
            bcf    BANDERA_MENU1
            bcf     BANDERA_USER_1
            bcf     BANDERA_USER_2
            bcf    BANDERA_TECLEA_1
            bcf    BANDERA_TECLEA_2
            BCF    BANDERA_CAMBIO_1
            BSF    BANDERA_CAMBIO_2
            bcf    BANDERA_ADMIN

     movlw  'N' ;A
     movwf  PORTD
     call   ENVIAMENU

     movlw  'U' ;D
     movwf  PORTD
     call   ENVIAMENU

     movlw  'E' ;M
     movwf  PORTD
     call   ENVIAMENU

     movlw  'V' ;I
     movwf  PORTD
     call   ENVIAMENU

     movlw  'A' ;N
     movwf  PORTD
     call   ENVIAMENU

     movlw  ':' ;
     movwf  PORTD
     call   ENVIAMENU


        goto    REGRESA_MENU

;**************************************************************************
OPCION_USER1_TECLEA



            bcf     STATUS,Z
            movlw   .3
            subwf   CONT_BLOQUEA_USER1,W
            btfsc   STATUS,Z
            goto    BLOQUEAR

            bcf     PORTC,0
            movlw   b'00000001'
            movwf   PORTD
            bsf     PORTC,1
            NOP
            bcf     PORTC,1
            call     DELAY

     clrf   TEMP
     movlw  0x20
     movwf  FSR
     bcf    BANDERA_CONTRA
    clrf    numTecla
    bcf    BANDERA_MENU2
    bcf    BANDERA_MENU1
    bcf     BANDERA_USER_1
    bcf     BANDERA_USER_2
     bsf    BANDERA_TECLEA_1
     bcf    BANDERA_TECLEA_2
     BcF    BANDERA_CAMBIO_1
     BCF    BANDERA_CAMBIO_2
     bcf    BANDERA_ADMIN
     movlw  'T' ;A
     movwf  PORTD
     call   ENVIAMENU

     movlw  'E' ;D
     movwf  PORTD
     call   ENVIAMENU

     movlw  'C' ;M
     movwf  PORTD
     call   ENVIAMENU

     movlw  'L' ;I
     movwf  PORTD
     call   ENVIAMENU

     movlw  'E' ;N
     movwf  PORTD
     call   ENVIAMENU

     movlw  'A' ;
     movwf  PORTD
     call   ENVIAMENU

     movlw  ':' ;
     movwf  PORTD
     call   ENVIAMENU
        goto    REGRESA_MENU

;******************************************************************************

OPCION_USER2_TECLEA


            bcf     STATUS,Z
            movlw   .3
            subwf   CONT_BLOQUEA_USER2,W
            btfsc   STATUS,Z
            goto    BLOQUEAR


            bcf     PORTC,0
            movlw   b'00000001'
            movwf   PORTD
            bsf     PORTC,1
            NOP
            bcf     PORTC,1
            call     DELAY

     clrf   TEMP
     movlw  0x20
     movwf  FSR
     bcf    BANDERA_CONTRA
    clrf    numTecla
    bcf    BANDERA_MENU2
    bcf    BANDERA_MENU1
    bcf     BANDERA_USER_1
    bcf     BANDERA_USER_2
     bcf    BANDERA_TECLEA_1
     bsf    BANDERA_TECLEA_2
    BcF    BANDERA_CAMBIO_1
     BCF    BANDERA_CAMBIO_2
      bcf    BANDERA_ADMIN

     movlw  'T' ;A
     movwf  PORTD
     call   ENVIAMENU

     movlw  'E' ;D
     movwf  PORTD
     call   ENVIAMENU

     movlw  'C' ;M
     movwf  PORTD
     call   ENVIAMENU

     movlw  'L' ;I
     movwf  PORTD
     call   ENVIAMENU

     movlw  'E' ;N
     movwf  PORTD
     call   ENVIAMENU

     movlw  'A' ;
     movwf  PORTD
     call   ENVIAMENU

     movlw  ':' ;
     movwf  PORTD
     call   ENVIAMENU

      goto    REGRESA_MENU

;***************************************************************************

CONTRASEÑA_INCORRECTA
     movlw   'i'
     movwf PORTD          ; Manda la conversión al puerto D
     call ENVIA           ; Manda Datos al LCD

     call   DELAY

     bcf    BANDERA_MENU2
     bsf    BANDERA_MENU1

     btfsc  BANDERA_CAMBIO_1
     goto   OPCION_USER_1

     btfsc  BANDERA_CAMBIO_2
     goto   OPCION_USER_2

     call   INCORRECTA

     goto   ADMIN


CONTRASEÑA_CORRECTA
     movlw   'C'
     movwf PORTD          ; Manda la conversión al puerto D
     call ENVIA           ; Manda Datos al LCD

     call   DELAY

     bsf    BANDERA_MENU2
     bcf    BANDERA_MENU1

     call   ADELANTE

     btfsc  BANDERA_OPCION_USER1_CAMBIO
     goto   OPCION_USER1_CAMBIO2

     btfsc  BANDERA_OPCION_USER2_CAMBIO
     goto   OPCION_USER2_CAMBIO2

     goto   MENU

;*******************************************************************************
ADELANTE

;            btfsc   BANDERA_CAMBIO_1
;            return
;
;            btfsc   BANDERA_CAMBIO_2
;            return

            btfsc   BANDERA_OPCION_USER1_CAMBIO
            return

            btfsc   BANDERA_OPCION_USER2_CAMBIO
            return

            btfsc   BANDERA_CAMBIO_1
            return

            btfsc   BANDERA_CAMBIO_2
            return

            bcf     PORTC,0
            movlw   b'00000001'
            movwf   PORTD
            bsf     PORTC,1
            NOP
            bcf     PORTC,1
            call     DELAY


             movlw  ' ' ;A
             movwf  PORTD
             call   ENVIAMENU

             movlw  ' ' ;D
             movwf  PORTD
             call   ENVIAMENU

             movlw  ' ' ;A
             movwf  PORTD
             call   ENVIAMENU

             movlw  ' ' ;D
             movwf  PORTD
             call   ENVIAMENU

             movlw  'A' ;A
             movwf  PORTD
             call   ENVIAMENU

             movlw  'D' ;D
             movwf  PORTD
             call   ENVIAMENU

             movlw  'E' ;M
             movwf  PORTD
             call   ENVIAMENU

             movlw  'L' ;I
             movwf  PORTD
             call   ENVIAMENU

             movlw  'A' ;N
             movwf  PORTD
             call   ENVIAMENU

             movlw  'N' ;
             movwf  PORTD
             call   ENVIAMENU

             movlw  'T' ;M
             movwf  PORTD
             call   ENVIAMENU

             movlw  'E' ;M
             movwf  PORTD
             call   ENVIAMENU

             movlw  '!' ;M
             movwf  PORTD
             call   ENVIAMENU

             bsf    PORTC,2
             call   DELAY
             call   DELAY
             call   DELAY
             call   DELAY
             call   DELAY
             call   DELAY
             bcf    PORTC,2

             return



;*******************************************************************************
INCORRECTA
            bcf     PORTC,0
            movlw   b'00000001'
            movwf   PORTD
            bsf     PORTC,1
            NOP
            bcf     PORTC,1
            call     DELAY

             movlw  ' ' ;A
             movwf  PORTD
             call   ENVIAMENU

             movlw  ' ' ;A
             movwf  PORTD
             call   ENVIAMENU

             movlw  ' ' ;D
             movwf  PORTD
             call   ENVIAMENU


             movlw  'I' ;A
             movwf  PORTD
             call   ENVIAMENU

             movlw  'N' ;D
             movwf  PORTD
             call   ENVIAMENU

             movlw  'C' ;M
             movwf  PORTD
             call   ENVIAMENU

             movlw  'O' ;I
             movwf  PORTD
             call   ENVIAMENU

             movlw  'R' ;N
             movwf  PORTD
             call   ENVIAMENU

             movlw  'R' ;
             movwf  PORTD
             call   ENVIAMENU

             movlw  'E' ;M
             movwf  PORTD
             call   ENVIAMENU

             movlw  'C' ;I
             movwf  PORTD
             call   ENVIAMENU

             movlw  'T' ;N
             movwf  PORTD
             call   ENVIAMENU

             movlw  'A' ;
             movwf  PORTD
             call   ENVIAMENU

             movlw  '!' ;M
             movwf  PORTD
             call   ENVIAMENU



             call   DELAY
             call   DELAY
             call   DELAY
             call   DELAY
             call   DELAY
             call   DELAY


             btfsc  BANDERA_TECLEA_1
             incf   CONT_BLOQUEA_USER1,F

             btfsc  BANDERA_TECLEA_2
             incf   CONT_BLOQUEA_USER2,F




             btfsc  BANDERA_TECLEA_1
             goto   OPCION_USER1_TECLEA

             btfsc  BANDERA_TECLEA_2
             goto   OPCION_USER2_TECLEA

             btfsc  BANDERA_ADMIN
             goto   ADMIN
             goto   MENU



;*******************************************************************************
BLOQUEAR

            clrf    CONT_BLOQUEA_USER1
            clrf    CONT_BLOQUEA_USER2
            bcf     PORTC,0
            movlw   b'00000001'
            movwf   PORTD
            bsf     PORTC,1
            NOP
            bcf     PORTC,1
            call     DELAY


     movlw  ' ' ;A
     movwf  PORTD
     call   ENVIAMENU

     movlw  ' ' ;A
     movwf  PORTD
     call   ENVIAMENU

     movlw  ' ' ;A
     movwf  PORTD
     call   ENVIAMENU

     movlw  'B' ;A
     movwf  PORTD
     call   ENVIAMENU

     movlw  'L' ;D
     movwf  PORTD
     call   ENVIAMENU

     movlw  'O' ;M
     movwf  PORTD
     call   ENVIAMENU

     movlw  'Q' ;I
     movwf  PORTD
     call   ENVIAMENU

     movlw  'U' ;N
     movwf  PORTD
     call   ENVIAMENU

     movlw  'E' ;
     movwf  PORTD
     call   ENVIAMENU

     movlw  'A' ;
     movwf  PORTD
     call   ENVIAMENU

     movlw  'D' ;
     movwf  PORTD
     call   ENVIAMENU

     movlw  'O' ;
     movwf  PORTD
     call   ENVIAMENU

     movlw  '!' ;
     movwf  PORTD
     call   ENVIAMENU


     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
;HASTA AQUI TRES SEGUNDOS
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
;HASTA AQUI SEIS SEGUNDOS
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
     call   DELAY
;HASTA AQUI 10 SEGUNDOS



     goto   MENU
;*******************************************************************************
;contraseña 0 1 2 3
COMPARA_CONTRASEÑA


    btfsc  BANDERA_ADMIN
    goto   COMPARA_ADMIN

    btfsc  BANDERA_TECLEA_1
    goto    COMPARA_USER_1

    btfsc  BANDERA_TECLEA_2
    goto   COMPARA_USER_2

    btfsc  BANDERA_ADMIN
    call    ASIGNA_VALORES_ADMIN

    btfsc  BANDERA_CAMBIO_1
    goto    CAMBIO_VALORES_1

    btfsc  BANDERA_CAMBIO_2
    goto   CAMBIO_VALORES_2




COMPARA_ADMIN
        bcf     STATUS,Z
        movf    VAR1,W
        subwf   0X20,W
        btfss   STATUS,Z
        goto    CONTRASEÑA_INCORRECTA

        bcf     STATUS,Z
        movf    VAR2,W
        subwf   0x21,W
        btfss   STATUS,Z
        goto    CONTRASEÑA_INCORRECTA

        bcf     STATUS,Z
        movf    VAR3,W
        subwf   0X22,W
        btfss   STATUS,Z
        goto    CONTRASEÑA_INCORRECTA

        bcf     STATUS,Z
        movf    VAR4,W
        subwf   0X23,W
        btfss   STATUS,Z
        goto    CONTRASEÑA_INCORRECTA
        goto    TERMINO_COMPARA

COMPARA_USER_1
        bcf     STATUS,Z
        movf    VAR1_1,W
        subwf   0X20,W
        btfss   STATUS,Z
        goto    CONTRASEÑA_INCORRECTA

        bcf     STATUS,Z
        movf    VAR2_1,W
        subwf   0x21,W
        btfss   STATUS,Z
        goto    CONTRASEÑA_INCORRECTA

        bcf     STATUS,Z
        movf    VAR3_1,W
        subwf   0X22,W
        btfss   STATUS,Z
        goto    CONTRASEÑA_INCORRECTA

        bcf     STATUS,Z
        movf    VAR4_1,W
        subwf   0X23,W
        btfss   STATUS,Z
        goto    CONTRASEÑA_INCORRECTA
        goto    TERMINO_COMPARA

COMPARA_USER_2
        bcf     STATUS,Z
        movf    VAR1_2,W
        subwf   0X20,W
        btfss   STATUS,Z
        goto    CONTRASEÑA_INCORRECTA

        bcf     STATUS,Z
        movf    VAR2_2,W
        subwf   0x21,W
        btfss   STATUS,Z
        goto    CONTRASEÑA_INCORRECTA

        bcf     STATUS,Z
        movf    VAR3_2,W
        subwf   0X22,W
        btfss   STATUS,Z
        goto    CONTRASEÑA_INCORRECTA

        bcf     STATUS,Z
        movf    VAR4_2,W
        subwf   0X23,W
        btfss   STATUS,Z
        goto    CONTRASEÑA_INCORRECTA

TERMINO_COMPARA


       ;btfsc   BANDERA_CAMBIO_1
       ; call    CAMBIO_VALORES_1

      ;  btfsc   BANDERA_CAMBIO_2
       ; call    CAMBIO_VALORES_2

TERMINO_ASIGNA

        bsf BANDERA_CONTRA


        return


CAMBIO_VALORES_ADMIN
    movf    0x20,W
    movwf   VAR1

    movf    0x21,W
    movwf   VAR2

    movf    0x22,W
    movwf   VAR3

    movf    0x23,W
    movwf   VAR4

;    bcf    BANDERA_MENU2
;    bsf    BANDERA_MENU1
;    bcf     BANDERA_USER_1
;    bcf     BANDERA_USER_2
;     bcf    BANDERA_TECLEA_1
;     bcf    BANDERA_TECLEA_2
;     BcF    BANDERA_CAMBIO_1
;     BCF    BANDERA_CAMBIO_2
;      bcf    BANDERA_ADMIN


    return

CAMBIO_VALORES_1
    movf    0x20,W
    movwf   VAR1_1

    movf    0x21,W
    movwf   VAR2_1

    movf    0x22,W
    movwf   VAR3_1

    movf    0x23,W
    movwf   VAR4_1

;    bcf    BANDERA_MENU2
;    bsf    BANDERA_MENU1
;    bcf     BANDERA_USER_1
;    bcf     BANDERA_USER_2
;     bcf    BANDERA_TECLEA_1
;     bcf    BANDERA_TECLEA_2
;     BcF    BANDERA_CAMBIO_1
;     BCF    BANDERA_CAMBIO_2
;      bcf    BANDERA_ADMIN
;

    goto    TERMINO_ASIGNA

CAMBIO_VALORES_2
    movf    0x20,W
    movwf   VAR1_2

    movf    0x21,W
    movwf   VAR2_2

    movf    0x22,W
    movwf   VAR3_2

    movf    0x23,W
    movwf   VAR4_2

;    bCf    BANDERA_MENU2
;    bSf    BANDERA_MENU1
;    bcf     BANDERA_USER_1
;    bcf     BANDERA_USER_2
;     bcf    BANDERA_TECLEA_1
;     bcf    BANDERA_TECLEA_2
;     BcF    BANDERA_CAMBIO_1
;     BCF    BANDERA_CAMBIO_2
;      bcf    BANDERA_ADMIN


    goto    TERMINO_ASIGNA


DIRECCIONAMIENTO_0
        movlw   .0
        movwf   INDF
        incf    FSR,F
        return

DIRECCIONAMIENTO_1
        movlw   .1
        movwf   INDF
        incf    FSR,F
        return

DIRECCIONAMIENTO_2
        movlw   .2
        movwf   INDF
        incf    FSR,F
        return


DIRECCIONAMIENTO_3
        movlw   .3
        movwf   INDF
        incf    FSR,F
        return

DIRECCIONAMIENTO_4
        movlw   .4
        movwf   INDF
        incf    FSR,F
        return

DIRECCIONAMIENTO_5
        movlw   .5
        movwf   INDF
        incf    FSR,F
        return

DIRECCIONAMIENTO_6
        movlw   .6
        movwf   INDF
        incf    FSR,F
        return

DIRECCIONAMIENTO_7
        movlw   .7
        movwf   INDF
        incf    FSR,F
        return

DIRECCIONAMIENTO_8
        movlw   .8
        movwf   INDF
        incf    FSR,F
        return

DIRECCIONAMIENTO_9
        movlw   .9
        movwf   INDF
        incf    FSR,F
        return

CERO

      movlw   '*'
     movwf PORTD          ; Manda la conversión al puerto D
     call ENVIA           ; Manda Datos al LCD

     btfsc  BANDERA_MENU2
     goto   INICIO

     call DIRECCIONAMIENTO_0
    bcf     STATUS,Z
    incf    TEMP,F
    movlw   .7
    subwf   TEMP,W
    btfsc   STATUS,Z
    call    COMPARA_CONTRASEÑA
    goto    REGRESO_CONV_TECLA



UNO
     movlw   '*'
     movwf PORTD          ; Manda la conversión al puerto D
     call ENVIA           ; Manda Datos al LCD

     btfsc  BANDERA_MENU2
     goto   OPCION_USER_1

     btfsc  BANDERA_USER_1
     goto   OPCION_USER1_TECLEA

     btfsc  BANDERA_USER_2
     goto   OPCION_USER2_TECLEA

     call    DIRECCIONAMIENTO_1
    bcf     STATUS,Z
    incf    TEMP,F
    movlw   .7
    subwf   TEMP,W
    btfsc   STATUS,Z
    call    COMPARA_CONTRASEÑA
    goto    REGRESO_CONV_TECLA


DOS
     movlw   '*'
     movwf PORTD          ; Manda la conversión al puerto D
     call ENVIA           ; Manda Datos al LCD

     btfsc  BANDERA_MENU2
     goto   OPCION_USER_2

     btfsc  BANDERA_USER_1
     goto   OPCION_USER1_CAMBIO

     btfsc  BANDERA_USER_2
     goto   OPCION_USER2_CAMBIO

     call    DIRECCIONAMIENTO_2
    bcf     STATUS,Z
    incf    TEMP,F
    movlw   .7
    subwf   TEMP,W
    btfsc   STATUS,Z
    call    COMPARA_CONTRASEÑA
    goto    REGRESO_CONV_TECLA



TRES
      movlw   '*'
     movwf PORTD          ; Manda la conversión al puerto D
     call ENVIA           ; Manda Datos al LCD

     call    DIRECCIONAMIENTO_3

     bcf     STATUS,Z
    incf    TEMP,F
    movlw   .7
    subwf   TEMP,W
    btfsc   STATUS,Z
    call    COMPARA_CONTRASEÑA
    goto    REGRESO_CONV_TECLA


CUATRO
   movlw   '*'
     movwf PORTD          ; Manda la conversión al puerto D
     call ENVIA           ; Manda Datos al LCD

     call    DIRECCIONAMIENTO_4

     bcf     STATUS,Z
    incf    TEMP,F
    movlw   .7
    subwf   TEMP,W
    btfsc   STATUS,Z
    call    COMPARA_CONTRASEÑA
    goto    REGRESO_CONV_TECLA

CINCO
    movlw   '*'
     movwf PORTD          ; Manda la conversión al puerto D
     call ENVIA           ; Manda Datos al LCD

     call    DIRECCIONAMIENTO_5

     bcf     STATUS,Z
    incf    TEMP,F
    movlw   .7
    subwf   TEMP,W
    btfsc   STATUS,Z
    call    COMPARA_CONTRASEÑA
    goto    REGRESO_CONV_TECLA

SEIS
    movlw   '*'
     movwf PORTD          ; Manda la conversión al puerto D
     call ENVIA           ; Manda Datos al LCD

     call    DIRECCIONAMIENTO_6

     bcf     STATUS,Z
    incf    TEMP,F
    movlw   .7
    subwf   TEMP,W
    btfsc   STATUS,Z
    call    COMPARA_CONTRASEÑA
    goto    REGRESO_CONV_TECLA

SIETE
    movlw   '*'
     movwf PORTD          ; Manda la conversión al puerto D
     call ENVIA           ; Manda Datos al LCD

     call    DIRECCIONAMIENTO_7

     bcf     STATUS,Z
    incf    TEMP,F
    movlw   .7
    subwf   TEMP,W
    btfsc   STATUS,Z
    call    COMPARA_CONTRASEÑA
    goto    REGRESO_CONV_TECLA

OCHO
    movlw   '*'
     movwf PORTD          ; Manda la conversión al puerto D
     call ENVIA           ; Manda Datos al LCD

     call    DIRECCIONAMIENTO_8

     bcf     STATUS,Z
    incf    TEMP,F
    movlw   .7
    subwf   TEMP,W
    btfsc   STATUS,Z
    call    COMPARA_CONTRASEÑA
    goto    REGRESO_CONV_TECLA

NUEVE
    movlw   '*'
     movwf PORTD          ; Manda la conversión al puerto D
     call ENVIA           ; Manda Datos al LCD

     call    DIRECCIONAMIENTO_9

     bcf     STATUS,Z
    incf    TEMP,F
    movlw   .7
    subwf   TEMP,W
    btfsc   STATUS,Z
    call    COMPARA_CONTRASEÑA
    goto    REGRESO_CONV_TECLA

AA
    movlw   .10
    movwf   PORTA
    movlw   'A'

     movwf PORTD          ; Manda la conversión al puerto D
     call ENVIA           ; Manda Datos al LCD
     return

BB
    movlw   .11
    movwf   PORTA
    movlw   'B'

     movwf PORTD          ; Manda la conversión al puerto D
     call ENVIA           ; Manda Datos al LCD
     return

CC
    movlw   .12
    movwf   PORTA
    movlw   'C'

     movwf PORTD          ; Manda la conversión al puerto D
     call ENVIA           ; Manda Datos al LCD
     return

DD
    movlw   .13
    movwf   PORTA
    movlw   'D'

     movwf PORTD          ; Manda la conversión al puerto D
     call ENVIA           ; Manda Datos al LCD
     return

EE
    movlw   .14
    movwf   PORTA
    movlw   'E'

     movwf PORTD          ; Manda la conversión al puerto D
     call ENVIA           ; Manda Datos al LCD
     return

FF
    movlw   .15
    movwf   PORTA
    movlw   'F'

     movwf PORTD          ; Manda la conversión al puerto D
     call ENVIA           ; Manda Datos al LCD
     return



 end
