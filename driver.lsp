
;;;	Registro de classes do usu�rio:
(regapp "ponto")
(regapp "temp")
(regapp "cv-niv")

;;;	Vari�veis globais:
(setq pastas (list "C:/2021/Projetos ativos/Programas/lsp-topografia/22-4-2021/" "Trabalho/" "Rotinas/")
      lisp (list "uso-geral.lsp" "levantamento.lsp")
      classes (list "ponto" "temp" "cv-niv")
      �rdem (list "Nome" "Abcissa" "Ordenada" "Cota" "Detalhe")
      )

(alert "Este � o driver")

(while (nth (setq i (if i (1+ i) 0)) lisp) (load (strcat (car pastas) (last pastas) (nth i lisp))))
(setq i nil)