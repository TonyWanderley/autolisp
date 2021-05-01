;;;---------------------------------------------------------------------------------------------------------------------;
;;;	Este driver é um projeto piloto para a otimização da interface, e deve usar como instância os procedimentos	;
;;;	pertinentes ao lançamento de pontos a partir de um arquivo de coordenadas típico de levantamentos topográficos	;
;;;---------------------------------------------------------------------------------------------------------------------;

;;;;			Inicialização - descrição:
;;;		Ao carrergar, oferece-se duas opções:
;;;	1 - Carregar configuração existente;
;;;	2 - Criar novo arquivo de configuração.
;;;
;;;		O arquivo de configuração deve ter, no mínimo:
;;;	1 - Arquivos de rotinas lisp utilizadas;					-	rotinas
;;;	2 - Apids;									-	classes
;;;		* Os apids são pertinentes a cada grupo de rotinas, portanto devem
;;;		ser acrescentados
;;;		à variavel global classes no ato de carregamento destes.
;;;	3 - Pasta de salvamento, onde se cria um arquivo de registro de atividades.	-	dir-trabalho
;;;		** No caso particular da instância piloto, lançamento de pontos,
;;;		temos a órdem de entrada dos cinco campos de registro de cada
;;;		ponto.

;;;	Variáveis globais:
;;;	classes
;;;	funções
;;;	ler-cfg?
;;;	órdem-arq-pontos
;;;	rotinas

(load "C:/2021/projeto/lsp/inicial.lsp")

(inicializa)

;;;(print (setq lcfg(_cfg nil)))		;	Aqui, pode-se colocar o caminho completo do arquivo de configuração