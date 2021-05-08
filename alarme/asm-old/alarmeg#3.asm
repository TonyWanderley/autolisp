;	Central de alarme simplificada - arquivo gestor		data	-	03-05-2021 10:42
;														versão	-	05-05-2021 17:19
;														versão	-	06-05-2021 15:20
;--Notas--
;	TIMER0:
;	[ps2 .. ps0] = 111 -> escala (E) 1 / 256
;	Ciclo de máquina (C) 1e-6 s
;	Estouro de TMR0, de 8 bits, (T0) = 256
;	Unidade tmplow (W) = (C / E) x T0 = (1e-6 / (1 / 256)) x 256 = 65.536e-6s = 6,5536e-2s ou 65ms
;	Unidade tmpmid (D) = 256 x W = 16.777.216e-6s, ou 17s
;	Unidade tmphig (G) = 256 x D = 4.294.967.296e-6s = 4.294,967296s ou 1h 11min 35s
;	Estouro de tmphig = 256 x G = 305h 25min 12s
;--fim de "Notas"--

;--Cabeçalho--
	list		p=16f628
	#include	<p16f628.inc>
	#include	"alarme.inc"
startup code
	extern entradig, processa, espelhar
	org		h'000'
	goto	inicio
	org		h'004'
	goto	isr

;--Interrupções--
isr:
;	--Salvamento de contexto--
	movwf wtmp
	swapf STATUS,W
	bank0
	movwf stmp

;	--Tratamento--
	btfss	INTCON,T0IF
	goto	isrsai
	bcf		INTCON,T0IF
	incfsz	tmplow,F
	goto	$ + 4
	incfsz	tmpmid,F
	goto	$ + 2
	incf	tmphig,F
	btfss	fluxo,contando
	goto	$ + 6
	btfss	tmpmid,2
	goto	$ + 5
	bsf		fluxo,expirado
	bcf		fluxo,pisca
	bcf		fluxo,contando
	bsf		espelho,esirene

;	--Recuperação de contexto e retorno--
isrsai:
	swapf stmp,W
	movwf STATUS
	swapf wtmp,F
	swapf wtmp,W 
	retfie

;--Rotina gerente--
inicio:
;	--Fuses--
	movlw	h'07'
	movwf	CMCON
	movlw	h'A0'
	movwf	INTCON
	bank1
	movlw	h'87'
	movwf	OPTION_REG
	movlw	h'F4'
	movwf	TRISA
	movlw	h'F0'
	movwf	TRISB
	bank0

;	--Valores iniciais--
	clrf	espelho
	bcf		PORTA,sirene
	btfsc	PORTA,sensor
	goto	$ + 4
	bsf		PORTA,verde
	bcf		PORTA,vermelho
	goto	$ + 3
	bcf		PORTA,verde
	bsf		PORTA,vermelho
	movlw	'1'
	movwf	senha0
	movlw	'2'
	movwf	senha1
	movlw	'3'
	movwf	senha2
	movlw	'4'
	movwf	senha3
	clrf	tmplow
	clrf	tmpmid
	clrf	tmphig

;	--Loop--
sentinela:
	call	espelhar
	bcf		fluxo,digitou
	call	entradig
	btfsc	fluxo,digitou
	call	processa
	goto	sentinela
	end