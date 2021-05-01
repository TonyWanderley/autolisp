;;;---------------------------------------------------------------------------------------------------------------------;
;;;	Este driver � um projeto piloto para a otimiza��o da interface, e deve usar como inst�ncia os procedimentos	;
;;;	pertinentes ao lan�amento de pontos a partir de um arquivo de coordenadas t�pico de levantamentos topogr�ficos	;
;;;---------------------------------------------------------------------------------------------------------------------;

;;;;			Inicializa��o - descri��o:
;;;		Ao carrergar, oferece-se duas op��es:
;;;	1 - Carregar configura��o existente;
;;;	2 - Criar novo arquivo de configura��o.
;;;
;;;		O arquivo de configura��o deve ter, no m�nimo:
;;;	1 - Arquivos de rotinas lisp utilizadas;					-	rotinas
;;;	2 - Apids;									-	classes
;;;		* Os apids s�o pertinentes a cada grupo de rotinas, portanto devem
;;;		ser acrescentados
;;;		� variavel global classes no ato de carregamento destes.
;;;	3 - Pasta de salvamento, onde se cria um arquivo de registro de atividades.	-	dir-trabalho
;;;		** No caso particular da inst�ncia piloto, lan�amento de pontos,
;;;		temos a �rdem de entrada dos cinco campos de registro de cada
;;;		ponto.

;;;	Vari�veis globais:
;;;	classes
;;;	fun��es
;;;	ler-cfg?
;;;	�rdem-arq-pontos
;;;	rotinas

(load "C:/2021/projeto/lsp/inicial.lsp")

(inicializa)

;;;(print (setq lcfg(_cfg nil)))		;	Aqui, pode-se colocar o caminho completo do arquivo de configura��o