
;;;;;;	Registro de classes do usu�rio:
;;;(regapp "ponto")
;;;(regapp "temp")
;;;(regapp "cv-niv")

;;;;;;	Vari�veis globais:
;;;(setq pastas (list "C:/2021/projeto/" "Trabalho/" "lsp/")
;;;      lisp (list "uso-geral.lsp" "levantamento.lsp")
;;;      classes (list "ponto" "temp" "cv-niv")
;;;      �rdem (list "Nome" "Abcissa" "Ordenada" "Cota" "Detalhe")
;;;      )
;;;
;;;(while (nth (setq i (if i (1+ i) 0)) lisp) (load (strcat (car pastas) (last pastas) (nth i lisp))))
;;;(setq i nil)

(alert "Este � o driver")

;;;(if (setq na (getfiled "Obter configura��o" "" "cfg" 0))
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
    (alert "Arquivo de configura��o n�o encontrado!!\ntente manualmente")
    (if (setq na (getfiled "Obter configura��o" "c:/" "cfg" 0))
      (if (setq pa (open na "r"))
	(progn
	  (alert "cfg encontrado manualmente")
	  (setq pa (close pa))
	  )
	(alert "Problema desconhecido")
	)
      (alert "Cancelou, danadinho!!\nesquenta n�o. Vamos fazer um cfg...\n\tna pr�xima etapa...")
      )
    )
  )