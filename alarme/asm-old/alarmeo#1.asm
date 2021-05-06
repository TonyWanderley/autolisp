;	Central de alarme simplificada - arquivo operário		data - 03-05-2021 10:44
	list		p=16f628
	#include	<p16f628.inc>
	#include	"alarme.inc"
	__CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_ON & _FOSC_INTOSCIO & _MCLRE_OFF & _LVP_OFF
prog	code
teclado:
	global	teclado
	clrf	bot				;	zere bot, carregue coluna 0 e verifique linha !!
	movlw	'1'
	movwf	carac1
	movlw	'4'
	movwf	carac2
	movlw	'7'
	movwf	carac3
	movlw	'*'
	movwf	carac4
	bsf		bot,c0
	call	teclai
	bcf		bot,c0			;	descarregue coluna 0 !!
	btfsc	estado,pressi	;	tecla pressionada na coluna 0?
	goto	pilha			;	sim ... guarde valor e retorne !!
	movlw	'2'				;	--	repete para todas as coluna, com parâmetros adequados	--
	movwf	carac1
	movlw	'5'
	movwf	carac2
	movlw	'8'
	movwf	carac3
	movlw	'0'
	movwf	carac4
	bsf		bot,c1
	call	teclai
	bcf		bot,c1
	btfsc	estado,pressi
	goto	pilha
	movlw	'3'
	movwf	carac1
	movlw	'6'
	movwf	carac2
	movlw	'9'
	movwf	carac3
	movlw	'#'
	movwf	carac4
	bsf		bot,c2
	call	teclai
	bcf		bot,c2
	btfsc	estado,pressi
	goto	pilha
	movlw	'A'				;	carregue coluna 3 e verifique linha !!
	movwf	carac1
	movlw	'B'
	movwf	carac2
	movlw	'C'
	movwf	carac3
	movlw	'D'
	movwf	carac4
	bsf		bot,c3
	call	teclai
	bcf		bot,c3			;	descarregue coluna 3 !!
	btfss	estado,pressi	;	tecla pressionada na coluna 3?
	return					;	não ... retorne !!
pilha:						;	sim ... guarde valor e retorne !!
	call	push
	return
teclai
	btfss	bot,ln0			;	pressionou na linha 0?
	goto	$ + 5			;	não ... tente 1 !!
	btfsc	bot,ln0			;	sim ... soltou linha 0?
	goto	$ - 1			;	não ... aguarde soltar !!
	movf	carac1,W		;	sim ... carregue o valor, sinalize êxito e retorne !!
	goto	saiteclai
	btfss	bot,ln1			;	---	repete com outros parâmetros	---
	goto	$ + 5
	btfsc	bot,ln1
	goto	$ - 1
	movf	carac2,W
	goto	saiteclai
	btfss	bot,ln2
	goto	$ + 5
	btfsc	bot,ln2
	goto	$ - 1
	movf	carac3,W
	goto	saiteclai
	btfss	bot,ln3			;	pressionou na linha 3?
	return					;	não ... retorne !!
	btfsc	bot,ln3			;	sim ... soltou linha 3?
	goto	$ - 1			;	não ... aguarde soltar !!
	movf	carac4,W		;	sim ... carregue o valor, sinalize êxito e retorne !!
saiteclai:
	bsf		estado,pressi
	return
comando:
	global	comando
	call	top				;	recupere o último dígito !!
	movlw	'*'
	subwf	topo,W
	btfss	STATUS,Z		;	topo = '*'?
	goto	$ + 5			;	não ... verifiqe '#' !!
	call	verisenha		;	sim ... verifique o acesso !!
	btfsc	acesso,permit	;	acesso permitido?
	bsf		acesso,editar	;	sim ... habilite edição de senha !!
	return					;	não ... retorne !!
	call	top				;	recupere o último dígito !!
	movlw	'#'
	subwf	topo,W
	btfss	STATUS,Z		;	topo = '#'?
	return					;	não ... retorne !!
	bsf		acesso,atuali	;	habilite a atualização do hardwere !!
	btfss	acesso,editar	;	edição de senha habilitada?
	goto	$ + d'11'		;	não ... opere arme e desarme do alarme !!
	movf	h'6B',W			;	sim ... altere senha e retorne !!
	movwf	senha0
	movf	h'6C',W
	movwf	senha1
	movf	h'6D',W
	movwf	senha2
	movf	h'6E',W
	movwf	senha3
	clrf	acesso
	return
	call	verisenha
	btfss	acesso,permit	;	acesso permitido?
	return					;	não ... retorne !!
	btfss	estado,operac	;	armado?
	goto	$ + 4			;	não ... arme o alarme, restrinja o acesso e retorne !!
	clrf	estado			;	sim ... desarme o alarme, restrinja o acesso e retorne !!
	bcf		acesso,permit
	return
	bsf		estado,operac
	return
verisenha:
	bcf		acesso,permit
	movf	h'6B',W
	subwf	senha0,W
	btfss	STATUS,Z
	return
	movf	h'6C',W
	subwf	senha1,W
	btfss	STATUS,Z
	return
	movf	h'6D',W
	subwf	senha2,W
	btfss	STATUS,Z
	return
	movf	h'6E',W
	subwf	senha3,W
	btfss	STATUS,Z
	return
	bsf		acesso,permit
	return
push:
	movwf	topo
	movf	h'69',W
	movwf	h'68'
	movf	h'6A',W
	movwf	h'69'
	movf	h'6B',W
	movwf	h'6A'
	movf	h'6C',W
	movwf	h'6B'
	movf	h'6D',W
	movwf	h'6C'
	movf	h'6E',W
	movwf	h'6D'
	movf	h'6F',W
	movwf	h'6E'
	movf	topo,W
	movwf	h'6F'
	return
pop:
	movf	h'6F',W
	movwf	topo
	movf	h'6E',W
	movwf	h'6F'
	movf	h'6D',W
	movwf	h'6E'
	movf	h'6C',W
	movwf	h'6D'
	movf	h'6B',W
	movwf	h'6C'
	movf	h'6A',W
	movwf	h'6B'
	movf	h'69',W
	movwf	h'6A'
	movf	h'68',W
	movwf	h'69'
	movf	topo,W
	return
top:
	movf	h'6F',W
	movwf	topo
	return
	end