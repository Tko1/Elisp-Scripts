;;elex
(define-parser "test-parser"
  alpha [a-zA-Z_]
  digit [0-9]
  integer {digit}+
  alphanum {alpha}|{digit}
  
  %%

  {alpha}{alphanum}* { '(:identifier el-text) }
  )
