;	Central de alarme simplificada - arquivo oper?rio	data	-	03-05-2021 10:44
;														vers?o	-	05-05-2021 17:24
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
	movlw	'2'				;	--	repete para todas as coluna, com par?metros adequados	--
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
	return					;	n?o ... retorne !!
pilha:						;	sim ... guarde valor e retorne !!
	call	push
	return
teclai
	btfss	teclado,linh0			;	pressionou na linha 0?
	goto	$ + 5			;	n?o ... tente 1 !!
	btfsc	teclado,linh0			;	sim ... soltou linha 0?
	goto	$ - 1			;	n?o ... aguarde soltar !!
	movf	vlinha1,W		;	sim ... carregue o valor, sinalize ?xito e retorne !!
	goto	saiteclai
	btfss	teclado,linh1			;	---	repete com outros par?metros	---
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
	return					;	n?o ... retorne !!
	btfsc	teclado,linh3			;	sim ... soltou linha 3?
	goto	$ - 1			;	n?o ... aguarde soltar !!
	movf	vlinha4,W		;	sim ... carregue o valor, sinalize ?xito e retorne !!
saiteclai:
	bsf		fluxo,digitou
	return
processa:
	global	processa
	call	top				;	recupere o ?ltimo d?gito !!
	movlw	'*'
	subwf	topo,W
	btfss	STATUS,Z		;	topo = '*'?
	goto	$ + 5			;	n?o ... verifiqe '#' !!
	call	verisenha		;	sim ... verifique o acesso !!
	btfsc	fluxo,acesso	;	acesso permitido?
	bsf		fluxo,mudasnh	;	sim ... habilite edi??o de senha !!
	return					;	n?o ... retorne !!
	call	top				;	recupere o ?ltimo d?gito !!
	movlw	'#'
	subwf	topo,W
	btfss	STATUS,Z		;	topo = '#'?
	return					;	n?o ... retorne !!
	btfss	fluxo,mudasnh	;	edi??o de senha habilitada?
	goto	$ + d'12'		;	n?o ... opere arme e desarme do alarme !!
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
	return					;	n?o ... retorne !!
	movlw	h'02'
	xorwf	estado,F
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
atualiza:
	global	atualiza
;		estado:		sira,	alarme,		relogio,	tempo,	sir
;		PORTA:		verde,	vermelho,	sensor,		sirene
;--ligar relogio:	B * ~(ACD)
	btfsc	estado,relogio	;	relogio desligado?
	goto	reloff			;	n?o .. rel?gio ligado!!
	btfss	estado,alarme	;	sim .. alarme ligado?
	goto	siroff			;	n?o .. ~B
	btfsc	estado,sira		;	sim .. sira desativada?
	goto	siron			;	n?o .. ~A
	btfsc	PORTA,sensor	;	sim .. sensor aberto?
	goto	siron			;	n?o .. ~C
	btfsc	estado,tempo	;	tempo incompleto?
	goto	siron			;	n?o .. ~D
	bsf		estado,relogio	;	satisfeitas as condi??es, ligou o rel?gio
	clrf	tmplow
	clrf	tmpmid
	clrf	tmphig
	goto	siron
;--desligar rel?gio:	~B + A + C + D **nesta linha, o rel?gio est? ligado**
reloff
	btfss	estado,alarme	;	alarme ligado?
	bcf		estado,relogio	;	n?o .. ~B
	btfsc	estado,sira		;	sim .. sira desativada?
	bcf		estado,relogio	;	n?o .. ~~A = A
	btfsc	PORTA,sensor	;	sim .. sensor aberto?
	bcf		estado,relogio	;	n?o .. ~~C = C
	btfsc	estado,tempo	;	sim .. tempo correndo?
	bcf		estado,relogio	;	n?o .. ~~D = D
siron:
;--ligar sirene:	B * (A + D)
	btfsc	estado,sir		;	sirene desligada?
	goto	siroff			;	n?o
	btfss	estado,alarme	;	sim .. alarme ligado?
	goto	siroff			;	n?o .. ~B
	btfsc	estado,sira		;	sim .. j? que B, sira desativada?
	bsf		estado,sir		;	n?o .. ~~A*B = A*B
	btfsc	estado,tempo	;	sim .. tempo correndo?
	bsf		estado,sir		;	n?o .. B * ~~D = B*D
;--desligar sirene:	~B
siroff:
	btfss	estado,alarme
	bcf		estado,sir
;--depois de tratada a sirene atual, agora se trata a sirene anterior e a f?sica .. sirene = sira = sir
	btfss	estado,sir		;	sirene ligada?
	goto	$ + 5			;	n?o ..
	bsf		estado,sira		;	sim ..
	bsf		PORTA,sirene
	bcf		estado,tempo
	goto	$ + 3
	bcf		estado,sira
	bcf		PORTA,sirene
;--tratar o tempo:		T = B * ~C * D * M
	btfss	estado,alarme	;	alarme ligado?
	goto	$ + 7			;	n?o .. ~B
	btfsc	PORTA,sensor	;	sim .. sensor aberto?
	goto	$ + 5			;	n?o .. ~~C = C
	btfss	estado,relogio	;	sim .. relogio ligado?
	goto	$ + 3			;	n?o .. ~D
	btfsc	tmpmid,2		;	sim .. ~M?
	bsf		estado,tempo	;	n?o .. B * ~C * D * M
;--tratar os leds:
;--pisca: P = D * W
	btfss	estado,relogio	;	rel?gio ativo?
	goto	$ + d'11'		;	n?o .. ~D
	btfss	PORTA,sensor	;	sim .. D .. C?
	goto	$ + 6			;	n?o .. D * ~C
	btfss	tmplow,1		;	sim .. CD .. W?
	goto	$ + d'14'		;	n?o .. C*D*~W
	movlw	h'01'			;	sim .. C * D * W
	xorwf	PORTA,F
	goto	$ + d'11'
	movlw	h'02'			;	sim .. ~C * D * W
	xorwf	PORTA,F
	goto	$ + 8
	btfss	PORTA,sensor
	goto	$ + 4
	bcf		PORTA,0
	bsf		PORTA,1
	goto	$ + 3
	bsf		PORTA,0
	bcf		PORTA,1
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