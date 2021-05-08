;	Central de alarme simplificada - arquivo gestor		data	-	03-05-2021 10:46
;														Versão	-	05-05-2021 17:09

;--Macros--
#define		bank0		bcf 	STATUS,RP0
#define		bank1		bsf		STATUS,RP0
;--fim de "Macros"--

;--Hardwere--
;	--Teclado--
teclado		EQU		PORTB
coluna3		EQU		0
coluna0		EQU		1
coluna1		EQU		2
coluna2		EQU		3
linh1		EQU		4
linh2		EQU		5
linh3		EQU		6
linh0		EQU		7

;	--Sensor, sirene e led's--
verde		EQU		0
vermelho	EQU		1
sensor		EQU		2
sirene		EQU		3

;--Variáveis--
;	--Espelho de hardwere--
espelho		EQU		h'21'
ealarme		EQU		0		;	virtual						..	prg		->	máquina
esensor		EQU		1		;	físico, entrada				..	máquina	->	prg
esirene		EQU		2		;	físico, saida				..	prg		->	máquina
eatualiza	EQU		3
eled		EQU		4

;	--Controlador de fluxo--
fluxo		EQU		h'22'
digitou		EQU		0
acesso		EQU		1
mudasnh		EQU		2
contando	EQU		3
expirado	EQU		4
pisca		EQU		5

;	--Salvamento de contexto--
wtmp		EQU		h'23'
stmp		EQU		h'24'

;	--Valores da coluna--
vlinha1		EQU		h'25'
vlinha2		EQU		h'26'
vlinha3		EQU		h'27'
vlinha4		EQU		h'28'

;	--Temporizador--
tmplow		EQU		h'29'
tmpmid		EQU		h'2A'
tmphig		EQU		h'2B'

;	--Senha--
senha0		EQU		h'2C'
senha1		EQU		h'2D'
senha2		EQU		h'2E'
senha3		EQU		h'2F'

;	--Pilha--
topo		EQU		h'67'