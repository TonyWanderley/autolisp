
;;;;;;	Registro de classes do usuário:
;;;(regapp "ponto")
;;;(regapp "temp")
;;;(regapp "cv-niv")

;;;;;;	Variáveis globais:
;;;(setq pastas (list "C:/2021/projeto/" "Trabalho/" "lsp/")
;;;      lisp (list "uso-geral.lsp" "levantamento.lsp")
;;;      classes (list "ponto" "temp" "cv-niv")
;;;      órdem (list "Nome" "Abcissa" "Ordenada" "Cota" "Detalhe")
;;;      )
;;;
;;;(while (nth (setq i (if i (1+ i) 0)) lisp) (load (strcat (car pastas) (last pastas) (nth i lisp))))
;;;(setq i nil)

(alert "Este é o driver")

;;;(if (setq na (getfiled "Obter configuração" "" "cfg" 0))
;;;  (if (setq pa (open na "r"))
;;;    (progn
;;;      (alert "Abriu o cfg")
;;;      (setq pa (close pa))
;;;      )
;;;    (alert "Problema com o cfg")
;;;    )
;;;  (alert "Problema com o cfg")
;;;  )

(if (setq pa (open "c:/2021/projeto/lsp/#1.cfg" "r"))
  (progn
    (alert "ok!!")
    (setq pa (close pa))
    )
  (progn
    (alert "Arquivo de configuração não encontrado!!\ntente manualmente")
    (if (setq na (getfiled "Obter configuração" "c:/" "cfg" 0))
      (if (setq pa (open na "r"))
	(progn
	  (alert "cfg encontrado manualmente")
	  (setq pa (close pa))
	  )
	(alert "Problema desconhecido")
	)
      (alert "Cancelou, danadinho!!\nesquenta não. Vamos fazer um cfg...\n\tna próxima etapa...")
      )
    )
  )