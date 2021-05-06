;	Central de alarme simplificada - arquivo gestor		data - 03-05-2021 10:42
	list		p=16f628
	#include	<p16f628.inc>
	#include	"alarme.inc"
;	extern	coluna, linha
;	__CONFIG _CP_OFF; & _WDT_OFF & _BODEN_OFF & _PWRTE_ON & _FOSC_INTOSCIO & _MCLRE_OFF & _LVP_OFF
startup code
	extern	coluna, linha, push, pop, top, comando, deftempo, disparar
	org		h'000'
	goto	inicio
	org		h'004'
	goto	isr
isr:
	movwf	h'70'
	movf	h'03',0
	movwf	h'71'
	goto	isrsai
	bcf		INTCON,2
isrsai:
	movf	h'71',0
	movwf	h'03'
	swapf	h'70',1
	swapf	h'70',0
	retfie
inicio:
;	--Fuses--
	movlw	h'07'
	movwf	CMCON
	movlw	h'00'
	movwf	INTCON			;	Desabilitada a interrupção .. habilitar quando precisar temporizar
	bank1
	movlw	h'87'
	movwf	OPTION_REG
	movlw	h'F4'
	movwf	TRISA
	movlw	h'F0'
	movwf	TRISB
	bank0
	bcf		flg,armado
sentinela:
	bcf		flg,exito
	movlw	h'01'
	movwf	p
	movlw	h'04'
	movwf	q
	btfsc	flg,exito
	goto	$ + 8
	movf	p,W
	call	coluna
	call	linha
	rlf		p,F
	bcf		p,0
	decfsz	q,F
	goto	$ - 8
	movlw	'#'
	movwf	p
	call	top
	subwf	p,W
	btfsc	STATUS,Z
	goto	$ + 7
	movlw	'*'
	movwf	p
	call	top
	subwf	p,W
	btfss	STATUS,Z
	goto	alarme
	call	comando
alarme:
	btfss	flg,armado		;	armado?
	goto	sentinela		;	desarmado								..	flg = ii00 0x0x
	btfss	flg,violado		;	já que está armado, está violado?
	goto	sentinela		;	armado e não violado					..	flg = ii00 001x
	btfsc	flg,disparo		;	armado e violado, já disparou?
	goto	sentinela		;	armado, violado e disparado				..	flg = ii00 111x
	btfsc	flg,tempo		;	definiu o intervalo?
	call	deftempo		;	definir tempo de entrada / saida		..	flg = ii00 011x
	btfss	flg,expirou		;	expirou o tempo de entrada / saida?
	goto	sentinela		;	dentro do intervalo						..	flg = ii01 011x
	call	disparar
	goto	sentinela
	end