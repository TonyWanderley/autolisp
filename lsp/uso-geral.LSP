

(defun <op��o-da-lista(arg / i msg res)
  (while (nth (setq i (if i (1+ i) 0)) arg)
    (setq msg (if (= i 0) (nth i arg) (strcat msg " " (nth i arg))))
    )
  (initget 1 msg)
  (setq res (getkword (strcat "Op��es v�lidas: " msg "\n")) i nil msg (list))
  (while (nth (setq i (if i (1+ i) 0)) arg)
    (if (/= (nth i arg) res) (setq msg (cons (nth i arg) msg)))
    )
  (list res (reverse msg))
  )

;;;	Converte texto consistente com n�mero real separado por v�rgula ou ponto em n�mero "float".
;;;	!!!	n�o verifica representa��es num�ricas inconsistentes com n�mero decimal, gerando resultado inconsistente
;;;	arg <- Texto consistente com n�mero real separado por v�rgula ou ponto.
(defun texto->real(arg)
  (if (wcmatch arg "*`,*")
    (setq arg (linha->dados (list "," arg))
	  arg (strcat (cadr arg) "." (car arg))
	  )
    )
  (atof arg)
  );	Retorna o float representado em arg.
