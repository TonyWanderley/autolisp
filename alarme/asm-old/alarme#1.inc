;	Central de alarme simplificada - arquivo gestor		data - 03-05-2021 10:46

;		--Macros:
#define		bank0		bcf 	STATUS,RP0
#define		bank1		bsf		STATUS,RP0

;		--Pinos:
;	Colunas e linhas do teclado:
bot			EQU			PORTB
c3			EQU			0
c0			EQU			1
c1			EQU			2
c2			EQU			3
ln1			EQU			4
ln2			EQU			5
ln3			EQU			6
ln0			EQU			7

;	Sensor, sirene e led's:
ssled		EQU			PORTA
verde		EQU			0
verme		EQU			1
senso		EQU			2
siren		EQU			3

;		--Variáveis:
;	Salvamento de contexto na interrupção:
wtmp		EQU			h'20'
stmp		EQU			h'21'

;	Conteudo da coluna:
cln1		EQU			h'22'
cln2		EQU			h'23'
cln3		EQU			h'24'
cln4		EQU			h'25'

;	Indicadores de estado de: alarme, tempos do alarme, teclado, leds:
estado		EQU			h'26'
operac		EQU			0	;	Alarme:		armado
aberto		EQU			1	;	Alarme:		violado ou aberto
ativo		EQU			2	;	Alarme:		disparado ou na iminência de disparar
;	--
contan		EQU			3	;	Tempo:		contando
;	--
pressi		EQU			4	;	Teclado:	pressionado
;	--
ledsel		EQU			5	;	Leds:		0 = verde, 1 = vermelho
pisca		EQU			6	;	Leds:		liga o pisca
selpis		EQU			7	;	Leds:		tipo de pisca:	~pisca	-> ~selpis = aceso; selpis = apagado
							;								pisca	-> ~selpis = rápido; selpis = lento

;	caracteres:
carac1		EQU			h'27'
carac2		EQU			h'28'
carac3		EQU			h'29'
carac4		EQU			h'2A'

;	temporizador:
tmplow		EQU			h'2B'
tmpmid		EQU			h'2C'
tmphig		EQU			h'2D'

;	senha:
senha3		EQU			h'2E'
senha2		EQU			h'2F'
senha1		EQU			h'30'
senha0		EQU			h'31'

;	Indicadores de senha, atualidade do hardwere:
acesso		EQU			h'32'
permit		EQU			0
editar		EQU			1
atuali		EQU			2	;	hardwere a atualizar? 0 = não, 1 = sim
uedita		EQU			3

;	Variável da pilha:
topo		EQU			h'67'