;	Central de alarme simplificada - arquivo operário	data	-	03-05-2021 10:44
;														versão	-	05-05-2021 17:24
	list		p=16f628
	#include	<p16f628.inc>
	#include	"alarme.inc"
	__CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_ON & _FOSC_INTOSCIO & _MCLRE_OFF & _LVP_OFF
prog	code
entradig:
	global	entradig
	clrf	teclado				;	zere teclado, carregue coluna 0 e verifique linha !!
	movlw	'1'
	movwf	vlinha1
	movlw	'4'
	movwf	vlinha2
	movlw	'7'
	movwf	vlinha3
	movlw	'*'
	movwf	vlinha4
	bsf		teclado,coluna0
	call	teclai
	bcf		teclado,coluna0			;	descarregue coluna 0 !!
	btfsc	fluxo,digitou	;	tecla pressionada na coluna 0?
	goto	pilha			;	sim ... guarde valor e retorne !!
	movlw	'2'				;	--	repete para todas as coluna, com parâmetros adequados	--
	movwf	vlinha1
	movlw	'5'
	movwf	vlinha2
	movlw	'8'
	movwf	vlinha3
	movlw	'0'
	movwf	vlinha4
	bsf		teclado,coluna1
	call	teclai
	bcf		teclado,coluna1
	btfsc	fluxo,digitou
	goto	pilha
	movlw	'3'
	movwf	vlinha1
	movlw	'6'
	movwf	vlinha2
	movlw	'9'
	movwf	vlinha3
	movlw	'#'
	movwf	vlinha4
	bsf		teclado,coluna2
	call	teclai
	bcf		teclado,coluna2
	btfsc	fluxo,digitou
	goto	pilha
	movlw	'A'				;	carregue coluna 3 e verifique linha !!
	movwf	vlinha1
	movlw	'B'
	movwf	vlinha2
	movlw	'C'
	movwf	vlinha3
	movlw	'D'
	movwf	vlinha4
	bsf		teclado,coluna3
	call	teclai
	bcf		teclado,coluna3			;	descarregue coluna 3 !!
	btfss	fluxo,digitou	;	tecla pressionada na coluna 3?
	return					;	não ... retorne !!
pilha:						;	sim ... guarde valor e retorne !!
	call	push
	return
teclai
	btfss	teclado,linh0			;	pressionou na linha 0?
	goto	$ + 5			;	não ... tente 1 !!
	btfsc	teclado,linh0			;	sim ... soltou linha 0?
	goto	$ - 1			;	não ... aguarde soltar !!
	movf	vlinha1,W		;	sim ... carregue o valor, sinalize êxito e retorne !!
	goto	saiteclai
	btfss	teclado,linh1			;	---	repete com outros parâmetros	---
	goto	$ + 5
	btfsc	teclado,linh1
	goto	$ - 1
	movf	vlinha2,W
	goto	saiteclai
	btfss	teclado,linh2
	goto	$ + 5
	btfsc	teclado,linh2
	goto	$ - 1
	movf	vlinha3,W
	goto	saiteclai
	btfss	teclado,linh3			;	pressionou na linha 3?
	return					;	não ... retorne !!
	btfsc	teclado,linh3			;	sim ... soltou linha 3?
	goto	$ - 1			;	não ... aguarde soltar !!
	movf	vlinha4,W		;	sim ... carregue o valor, sinalize êxito e retorne !!
saiteclai:
	bsf		fluxo,digitou
	return
processa:
	global	processa
	call	top				;	recupere o último dígito !!
	movlw	'*'
	subwf	topo,W
	btfss	STATUS,Z		;	topo = '*'?
	goto	$ + 5			;	não ... verifiqe '#' !!
	call	verisenha		;	sim ... verifique o acesso !!
	btfsc	fluxo,acesso	;	acesso permitido?
	bsf		fluxo,mudasnh	;	sim ... habilite edição de senha !!
	return					;	não ... retorne !!
	call	top				;	recupere o último dígito !!
	movlw	'#'
	subwf	topo,W
	btfss	STATUS,Z		;	topo = '#'?
	return					;	não ... retorne !!
	btfss	fluxo,mudasnh	;	edição de senha habilitada?
	goto	$ + d'12'		;	não ... opere arme e desarme do alarme !!
	movf	h'6B',W			;	sim ... altere senha e retorne !!
	movwf	senha0
	movf	h'6C',W
	movwf	senha1
	movf	h'6D',W
	movwf	senha2
	movf	h'6E',W
	movwf	senha3
	bcf		fluxo,acesso
	bcf		fluxo,mudasnh
	return
	call	verisenha
	btfss	fluxo,acesso	;	acesso permitido?
	return					;	não ... retorne !!
	btfss	espelho,ealarme	;	armado?
	goto	$ + 5			;	não ... arme o alarme, restrinja o acesso e retorne !!
	bcf		espelho,ealarme			;	sim ... desarme o alarme, restrinja o acesso e retorne !!
	bcf		fluxo,acesso
	bsf		espelho,eatualiza
	return
	bsf		espelho,ealarme
	bsf		espelho,eatualiza
	return
verisenha:
	bcf		fluxo,acesso
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
	bsf		fluxo,acesso
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