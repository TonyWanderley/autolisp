;	Central de alarme simplificada - arquivo gestor		data - 03-05-2021 10:46

;	Macros:
#define		bank0		bcf 	STATUS,RP0
#define		bank1		bsf		STATUS,RP0

;	Pinos:
bot			EQU			PORTB
c3			EQU			h'0'
c0			EQU			h'1'
c1			EQU			h'2'
c2			EQU			h'3'
ln1			EQU			h'4'
ln2			EQU			h'5'
ln3			EQU			h'6'
ln0			EQU			h'7'


ledg		EQU			h'0'
ledr		EQU			h'1'
sens		EQU			h'2'
sire		EQU			h'3'

;	Variáveis
x			EQU			h'20'
y			EQU			h'21'
z			EQU			h'22'
t			EQU			h'23'
p			EQU			h'24'
q			EQU			h'25'
r			EQU			h'26'
s			EQU			h'27'

flg			EQU			h'28'
exito		EQU			h'0'
armado		EQU			h'1'
violado		EQU			h'2'
disparo		EQU			h'3'
expirou		EQU			h'4'