
;;;	arg <- [caractere separador, linha de dados].
(defun linha->dados(arg / sep dig tx res)
  (setq sep (car arg) arg (cadr arg) tx "")
  (while (/= (setq dig (substr arg 1 1) arg (substr arg 2) dig dig) "")
    (if (= dig sep) (setq res (cons tx res) tx "") (setq tx (strcat tx dig)))
    )
  (cons tx res)
  );	Retorna lista revertida dos dados representados. Elementos da lista s�o do tipo texto.

;;;	arg <- [<separador de dados> <ponteiro de arquivo>]
(defun arquivo->lista(arg / ln res)(while (setq ln (read-line (cadr arg))) (setq res (cons (linha->dados (list (car arg) ln)) res))) res)
;;;	retorna [<registro 1> ... <registro n>]					!!!	�rdem da saida a verificar	!!!
;;;	registros na forma ["campo 1" ... "campo m"]				!!!	�rdem da saida a verificar	!!!

;;;	arg <- lista de textos na forma [mensagem op��o-0 ... op��o-n]
(defun menu(arg / msg op opp i)
  (setq msg (car arg) arg (cdr arg))
  (while (nth (setq i (if i (1+ i) 0)) arg)
    (setq op (if (= i 0) (nth i arg) (strcat op " " (nth i arg)))
	  opp (if (= i 0) (strcat "[" (nth i arg)) (strcat opp ", " (nth i arg)))
	  )
    )
  (setq opp (strcat opp "]"))
  (initget op)
  (getkword (strcat msg " " opp))
  );	retorna a op��o escolhida

(defun inicializa()
  (if (= (menu (list "Escolha a forma de configurar trabalho atual" "Abrir" "Criar")) "Abrir")
    (alert "Escolheu abrir\num arquivo existente")
;;;    (alert "Escolheu criar\num arquivo de configura��o")
    (setq rotinas (ler-lisps))
    )
  (princ)
  )

;;;(defun _cfg(arg / pa ln res)
;;;  (if (null arg)
;;;    (if (null (setq arg (getfiled "Obter configura��o" "c:/" "cfg" 0)))
;;;      (alert "Arquivo de configura��o necess�rio!!\nVamos criar...");		Aqui se cria arquivo de configura��o
;;;      )
;;;    )
;;;  (if arg (setq res (arquivo->lista (list "\t" (open arg "r")))))
;;;  (gc)
;;;  (mapcar 'reverse res)
;;;  )