
;;;	arg <- [caractere separador, linha de dados].
(defun linha->dados(arg / sep dig tx res)
  (setq sep (car arg) arg (cadr arg) tx "")
  (while (/= (setq dig (substr arg 1 1) arg (substr arg 2) dig dig) "")
    (if (= dig sep) (setq res (cons tx res) tx "") (setq tx (strcat tx dig)))
    )
  (cons tx res)
  );	Retorna lista revertida dos dados representados. Elementos da lista são do tipo texto.

(defun arquivo->lista(arg / ln res)(while (setq ln (read-line (cadr arg))) (setq res (cons (linha->dados (list (car arg) ln)) res))) res)

(defun cfg(/ na pa ln res)
  (if (setq pa (open "c:/2021/projeto/lsp/#0.cfg" "r"))
    (setq res (arquivo->lista (list "\t" pa)))
    (progn
      (alert "Arquivo de configuração não encontrado!!\ntente manualmente")
      (if (setq na (getfiled "Obter configuração" "c:/" "cfg" 0))
	(if (setq pa (open na "r"))
	  (setq res (arquivo->lista (list "\t" pa)))
	  (alert "Problema desconhecido")
	  )
	(alert "Cancelou, danadinho!!\nesquenta não. Vamos fazer um cfg...\n\tna próxima etapa...")
	)
      )
    )
  (if pa (close pa))
  (gc)
  (mapcar 'reverse res)
  )