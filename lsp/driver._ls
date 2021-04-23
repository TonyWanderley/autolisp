
;;;	Registro de classes do usuário:
(regapp "ponto")
(regapp "temp")
(regapp "cv-niv")

;;;	Variáveis globais:
(setq pastas (list "C:/2021/Projetos ativos/Programas/lsp-topografia/22-4-2021/" "Trabalho/" "Rotinas/")
      lisp (list "uso-geral.lsp" "levantamento.lsp")
      classes (list "ponto" "temp" "cv-niv")
      órdem (list "Nome" "Abcissa" "Ordenada" "Cota" "Detalhe")
      )

(alert "Este é o driver")

(while (nth (setq i (if i (1+ i) 0)) lisp) (load (strcat (car pastas) (last pastas) (nth i lisp))))
(setq i nil)