;	Central de alarme simplificada - arquivo oper�rio		data - 03-05-2021 10:44
	list		p=16f628
	#include	<p16f628.inc>
	#include	"alarme.inc"
	__CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_ON & _FOSC_INTOSCIO & _MCLRE_OFF & _LVP_OFF
prog	code
coluna:
	global	coluna
	movwf	bot
	bcf		flg,exito
	btfss	bot,c0
	goto	$ + d'11'
	movlw	'1'
	movwf	x
	movlw	'4'
	movwf	y
	movlw	'7'
	movwf	z
	movlw	'*'
	movwf	t
	bsf		flg,exito
	return
	btfss	bot,c1
	goto	$ + d'11'
	movlw	'2'
	movwf	x
	movlw	'5'
	movwf	y
	movlw	'8'
	movwf	z
	movlw	'0'
	movwf	t
	bsf		flg,exito
	return
	btfss	bot,c2
	goto	$ + d'11'
	movlw	'3'
	movwf	x
	movlw	'6'
	movwf	y
	movlw	'9'
	movwf	z
	movlw	'#'
	movwf	t
	bsf		flg,exito
	return
	btfss	bot,c3
	goto	$ + d'10'
	movlw	'A'
	movwf	x
	movlw	'B'
	movwf	y
	movlw	'C'
	movwf	z
	movlw	'D'
	movwf	t
	bsf		flg,exito
	return
linha:
	global	linha
	bcf		flg,exito
	btfss	bot,ln0
	goto	$ + 5
	btfsc	bot,ln0
	goto	$ - 1
	movf	x,W
	goto	sailinha
	btfss	bot,ln1
	goto	$ + 5
	btfsc	bot,ln1
	goto	$ - 1
	movf	y,W
	goto	sailinha
	btfss	bot,ln2
	goto	$ + 5
	btfsc	bot,ln2
	goto	$ - 1
	movf	z,W
	goto	sailinha
	btfss	bot,ln3
	return
	btfsc	bot,ln3
	goto	$ - 1
	movf	t,W
sailinha:
	bsf		flg,exito
	call	push
	return
	end