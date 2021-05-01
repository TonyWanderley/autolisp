
(defun define-órdem(/ campos i aux res)
  (setq campos (list "Nome" "Abcissa" "Ordenada" "Cota" "Detalhe")
	i 0
	)
  (while (> (length campos) 1)
    (progn
      (setq res (cons (menu (cons (strcat "Elemento #" (itoa (setq i (1+ i))) ": ") campos)) res)
	    aux campos
	    campos (list)
	    )
      (while (car aux)
	(if (/= (car aux) (car res))
	  (setq campos (cons (car aux) campos)
		aux (cdr aux)
		)
	  (setq aux (cdr aux))
	  )
	)
      (setq campos (reverse campos))
      )
    )
  (reverse (cons (car campos) res))
  );	retorna a órdem dos campos do arquivo-fonte dos pontos