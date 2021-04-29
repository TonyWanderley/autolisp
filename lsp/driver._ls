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
;;;	3 - Pasta de salvamento, onde se cria um arquivo de registro de atividades.	-	dt

(load "C:/2021/projeto/lsp/inicial.lsp")

(defun ler-lisps(/ na res)
  (while (setq i (if i (1+ i) 1) na (getfiled (strcat "Arquivo lsp #" (itoa i)) "c:/2021/" "lsp" 0))
    (setq res (cons na res))
    )
  res
  )

(inicializa)

;;;(print (setq lcfg(_cfg nil)))		;	Aqui, pode-se colocar o caminho completo do arquivo de configuração