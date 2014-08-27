;;;============================================================================

;;; File: "nonneg-integer.sld"

;;; Copyright (c) 2006-2014 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Provides operations on nonnegative integers.

(define-library (http://github.com/feeley/nonneg-integer)

  (export nonneg-integer->digits
          digits->nonneg-integer
          nonneg-integer->u8vector
          u8vector->nonneg-integer
          nonneg-integer->base64-string
          base64-string->nonneg-integer
          nonneg-integer-expt-mod)

  (import (gambit)
          (http://github.com/feeley/base64))

  (include "nonneg-integer.scm")
)

;;;============================================================================
