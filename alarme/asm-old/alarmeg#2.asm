;	Central de alarme simplificada - arquivo gestor		data	-	03-05-2021 10:42
;														versão	-	05-05-2021 17:19
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
;--fim de "Cabeçalho"--

;--Definições e links--
startup code
	extern entradig, processa
	org		h'000'
	goto	inicio
	org		h'004'
	goto	isr
;--fim de "Definições e links"--

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

;		--incremento da variável de 24 bits--
	incfsz	tmplow,F
	goto	$ + 4
	incfsz	tmpmid,F
	goto	$ + 2
	incf	tmphig,F
;		--fim de "incremento da variável de 24 bits"--

;		--Gestar tempos--
	btfss	fluxo,contando
	goto	$ + 6
	btfss	tmpmid,2
	goto	$ + 4
	bsf		fluxo,expirado
	bcf		fluxo,pisca
	bcf		fluxo,contando
;		--fim de "Gestar tempos"--

;	--fim de "Tratamento"--

;	--Recuperação de contexto e retorno--
isrsai:
	swapf stmp,W
	movwf STATUS
	swapf wtmp,F
	swapf wtmp,W 
	retfie
;	--fim de "Recuperação de contexto e retorno"--
;--fim de "Interrupções"--

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
;	--fim de "Fuses"--

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
;	--fim de "Valores iniciais"--

;	--Loop--
sentinela:
	btfsc	PORTA,sensor		;	sensor aberto?
	goto	$ + 4				;	sensor fechado !!
	btfsc	espelho,esensor		;	sensor aberto	..	esensor aberto?
	bsf		espelho,eatualiza	;	esensor fechado, sensor aberto -> muda !!
	goto	$ + 3				;	esensor aberto, sensor aberto -> ok !!
	btfss	espelho,esensor		;	sensor fechado .. esensor fechado?
	bsf		espelho,eatualiza	;	esensor aberto, sensor fechado -> muda !!
	btfss	espelho,eatualiza	;	mudar?
	goto	entrada
	bcf		espelho,esensor
	btfss	PORTA,sensor
	goto	$ + d'11'
	bsf		espelho,esensor
	btfss	fluxo,pisca
	goto	$ + 5
	movlw	h'01'
	btfsc	tmplow,1
	xorwf	PORTA,F
	goto	$ + 2
	bcf		PORTA,verde
	bsf		PORTA,vermelho
	goto	$ + 9
	bsf		PORTA,verde
	btfss	fluxo,pisca
	goto	$ + 5
	movlw	h'02'
	btfsc	tmplow,1
	xorwf	PORTA,F
	goto	$ + 2
	bcf		PORTA,vermelho		;	--leds e sensor atualizados--
	btfss	espelho,esirene
	goto	$ + 3
	bsf		PORTA,sirene
	goto	$ + 2
	bcf		PORTA,sirene		;	--leds, sensor e sirene atualizados--
	btfss	espelho,ealarme
	goto	$ + d'11'
	btfsc	fluxo,contando
	goto	$ + 7
	bsf		fluxo,contando
	bcf		fluxo,expirado
	bsf		fluxo,pisca
	clrf	tmplow
	clrf	tmpmid
	clrf	tmphig
	btfsc	fluxo,expirado
	bsf		espelho,esirene
	bcf		espelho,eatualiza
entrada:
	bcf		fluxo,digitou
	call	entradig
	btfsc	fluxo,digitou
	call	processa
	goto	sentinela
;	--fim de "Loop"--
;--fim de "Rotina gerente"--
	end