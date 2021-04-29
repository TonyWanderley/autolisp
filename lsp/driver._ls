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
;;;	3 - Pasta de salvamento, onde se cria um arquivo de registro de atividades.	-	dt

(load "C:/2021/projeto/lsp/inicial.lsp")

(defun ler-lisps(/ na res)
  (while (setq i (if i (1+ i) 1) na (getfiled (strcat "Arquivo lsp #" (itoa i)) "c:/2021/" "lsp" 0))
    (setq res (cons na res))
    )
  res
  )

(inicializa)

;;;(print (setq lcfg(_cfg nil)))		;	Aqui, pode-se colocar o caminho completo do arquivo de configura��o