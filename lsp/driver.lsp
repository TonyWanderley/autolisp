
;;;	Registro de classes do usuário:
(regapp "ponto")
(regapp "temp")
(regapp "cv-niv")

;;;	Variáveis globais:
(setq pastas (list "C:/2021/projeto/" "Trabalho/" "lsp/")
      lisp (list "uso-geral.lsp" "levantamento.lsp")
      classes (list "ponto" "temp" "cv-niv")
      órdem (list "Nome" "Abcissa" "Ordenada" "Cota" "Detalhe")
      )

(while (nth (setq i (if i (1+ i) 0)) lisp) (load (strcat (car pastas) (last pastas) (nth i lisp))))
(setq i nil)

(alert "Este é o driver")