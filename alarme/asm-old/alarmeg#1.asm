;	Central de alarme simplificada - arquivo gestor		data - 03-05-2021 10:42

;--Cabe�alho--
	list		p=16f628
	#include	<p16f628.inc>
	#include	"alarme.inc"

;--Defini��es e links--
startup code
	extern	teclado, comando
	org		h'000'
	goto	inicio
	org		h'004'
	goto	isr

;--Interrup��es--
isr:
;	--Salvamento de contexto--
	movwf wtmp
	swapf STATUS,W
	bank0
	movwf stmp
;	--fim de "Salvamento de contexto"--

;	--Tratamento--
	btfss	INTCON,T0IF
	goto	isrsai
	bcf		INTCON,T0IF

;	--incremento da vari�vel de 24 bits--
	incfsz	tmplow
	goto	$ + 4
	incfsz	tmpmid
	goto	$ + 2
	incf	tmphig
;	--fim de "incremento da vari�vel de 24 bits"--

;	--gest�o da sirene--
	btfss	estado,contan
	goto	$ + 5
	btfss	tmphig,2
	goto	$ + 3
	bcf		estado,contan
	bsf		ssled,siren
;	--fim de "gest�o da sirene"--

;	--gest�o dos leds--

;		!!!		Analizar o prescaler e ajustar o temporizador	!!!
;bit 3 do OPTION - PSA - dever� ser 0
;bits [5 .. 7] do OPTION - [PS2 .. PS0]- s�o [111] -> prescaler = 256
;ciclo de m�quina .. e-6 s
;interrup��o a cada 2,56 e-4 s
;estoura tmplow a cada 6,5536 e-2 s (65 ms)
;estoura tmpmid a cada 16,77216 s
;estoura tmphig a cada 4294,967296 s ~= 1h 12'

;	*estabelecer aproximadamente um minuto de entrada e saida = 4 estouros de tpmid*

;	--fim de "Tratamento"--

isrsai:
;	--Recupera��o de contexto e retorno--
	swapf stmp,W
	movwf STATUS
	swapf wtmp,F
	swapf wtmp,W 
	retfie
;	--fim de "Recupera��o de contexto e retorno"--

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
	movlw	h'C0'
	movwf	estado			;	sistema desarmado, led verde pisca lento
	movlw	h'04'
	movwf	acesso			;	habilita a atualiza��o

;	--Loop--
sentinela:
	btfss	acesso,atuali	;	atualizar?
	goto	userin			;	n�o ... Verifique entrada do usu�rio !!

;	--Atualizar hardwere--
	clrf	tmplow			;	sim ... zere contadores...................................... ??????????????
	clrf	tmpmid
	clrf	tmphig

	bcf		acesso,atuali
;	--fim de "Atualizar hardwere"--

;	--Entrada do usu�rio--
userin:
	bcf		estado,pressi	;	atualize para a pr�xima entrada do usu�rio !!
	call	teclado			;	verifique teclado !!
	btfsc	estado,pressi	;	tecla pressionada?
	call	comando			;	sim ... gerencie entrada do usu�rio !!
;	--fim de "Entrada do usu�rio"--

;	--Verificar estado--
	btfss	estado,operac	;	Sistema armado?
	goto	sentinela		;	n�o ... verifique entrada do usu�rio !!
	btfss	estado,aberto	;	j� que armado, aberto ou violado?
	goto	sentinela		;	n�o ... verifique entrada do usu�rio
	btfsc	estado,ativo	;	sim ... j� que aberto ou violado, disparado ou na imin�ncia de disparar?
	goto	sentinela		;	sim ... verifique entrada do usu�rio
	bsf		estado,ativo
	bsf		estado,contan
	goto	sentinela		;	verifique entrada do usu�rio
;	--fim de "Verificar estado"--
	end