
;;;	Registro de classes do usu�rio:
(regapp "ponto")
(regapp "temp")
(regapp "cv-niv")

;;;	Vari�veis globais:
(setq pastas (list "C:/2021/projeto/" "Trabalho/" "lsp/")
      lisp (list "uso-geral.lsp" "levantamento.lsp")
      classes (list "ponto" "temp" "cv-niv")
      �rdem (list "Nome" "Abcissa" "Ordenada" "Cota" "Detalhe")
      )

(while (nth (setq i (if i (1+ i) 0)) lisp) (load (strcat (car pastas) (last pastas) (nth i lisp))))
(setq i nil)

(alert "Este � o driver")