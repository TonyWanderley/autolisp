;	Central de alarme simplificada - arquivo gestor		data - 03-05-2021 10:42

;--Cabeçalho--
	list		p=16f628
	#include	<p16f628.inc>
	#include	"alarme.inc"

;--Definições e links--
startup code
	extern	teclado, comando
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
;	--fim de "Salvamento de contexto"--

;	--Tratamento--
	btfss	INTCON,T0IF
	goto	isrsai
	bcf		INTCON,T0IF

;	--incremento da variável de 24 bits--
	incfsz	tmplow
	goto	$ + 4
	incfsz	tmpmid
	goto	$ + 2
	incf	tmphig
;	--fim de "incremento da variável de 24 bits"--

;	--gestão da sirene--
	btfss	estado,contan
	goto	$ + 5
	btfss	tmphig,2
	goto	$ + 3
	bcf		estado,contan
	bsf		ssled,siren
;	--fim de "gestão da sirene"--

;	--gestão dos leds--

;		!!!		Analizar o prescaler e ajustar o temporizador	!!!
;bit 3 do OPTION - PSA - deverá ser 0
;bits [5 .. 7] do OPTION - [PS2 .. PS0]- são [111] -> prescaler = 256
;ciclo de máquina .. e-6 s
;interrupção a cada 2,56 e-4 s
;estoura tmplow a cada 6,5536 e-2 s (65 ms)
;estoura tmpmid a cada 16,77216 s
;estoura tmphig a cada 4294,967296 s ~= 1h 12'

;	*estabelecer aproximadamente um minuto de entrada e saida = 4 estouros de tpmid*

;	--fim de "Tratamento"--

isrsai:
;	--Recuperação de contexto e retorno--
	swapf stmp,W
	movwf STATUS
	swapf wtmp,F
	swapf wtmp,W 
	retfie
;	--fim de "Recuperação de contexto e retorno"--

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
	movwf	acesso			;	habilita a atualização

;	--Loop--
sentinela:
	btfss	acesso,atuali	;	atualizar?
	goto	userin			;	não ... Verifique entrada do usuário !!

;	--Atualizar hardwere--
	clrf	tmplow			;	sim ... zere contadores...................................... ??????????????
	clrf	tmpmid
	clrf	tmphig

	bcf		acesso,atuali
;	--fim de "Atualizar hardwere"--

;	--Entrada do usuário--
userin:
	bcf		estado,pressi	;	atualize para a próxima entrada do usuário !!
	call	teclado			;	verifique teclado !!
	btfsc	estado,pressi	;	tecla pressionada?
	call	comando			;	sim ... gerencie entrada do usuário !!
;	--fim de "Entrada do usuário"--

;	--Verificar estado--
	btfss	estado,operac	;	Sistema armado?
	goto	sentinela		;	não ... verifique entrada do usuário !!
	btfss	estado,aberto	;	já que armado, aberto ou violado?
	goto	sentinela		;	não ... verifique entrada do usuário
	btfsc	estado,ativo	;	sim ... já que aberto ou violado, disparado ou na iminência de disparar?
	goto	sentinela		;	sim ... verifique entrada do usuário
	bsf		estado,ativo
	bsf		estado,contan
	goto	sentinela		;	verifique entrada do usuário
;	--fim de "Verificar estado"--
	end