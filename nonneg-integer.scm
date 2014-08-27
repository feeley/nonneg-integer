;;;============================================================================

;;; File: "nonneg-integer.scm"

;;; Copyright (c) 2006-2014 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(declare
  (standard-bindings)
  (extended-bindings)
  (fixnum)
  (not safe))

;;;----------------------------------------------------------------------------

;;; Provides operations on nonnegative integers.

(define (nonneg-integer->digits x radix)

  (declare (generic))

  (let* ((square-series
          (let loop ((square radix)
                     (square-list (list radix)))
            (let ((new-square
                   (* square square)))
              (if (< x new-square)
                  square-list
                  (loop new-square
                        (cons new-square square-list)))))))

    (define (convert n square-series tail)
      (if (pair? square-series)
          (let* ((q (quotient n (car square-series)))
                 (r (remainder n (car square-series)))
                 (new-square-series (cdr square-series)))
            (convert r
                     new-square-series
                     (convert q
                              new-square-series
                              tail)))
          (let ((d n))
            (if (and (null? tail) ;; avoid leading zeroes
                     (= d 0))
                tail
                (cons d tail)))))

    (convert x square-series '())))

(define (digits->nonneg-integer digit-list radix)

  ;; Note: a divide-and-conquer algorithm would be faster for large numbers.

  (declare (generic))

  (let loop ((n 0) (lst (reverse digit-list)))
    (if (pair? lst)
        (loop (+ (* n radix) (car lst))
              (cdr lst))
        n)))

;;;---------------------------------------------------------------------------

(define (nonneg-integer->u8vector n)
  (list->u8vector (reverse (nonneg-integer->digits n 256))))

(define (u8vector->nonneg-integer u8vect)
  (digits->nonneg-integer (reverse (u8vector->list u8vect)) 256))

(define (nonneg-integer->base64-string n)
  (u8vector->base64-string (nonneg-integer->u8vector n)))

(define (base64-string->nonneg-integer str)
  (u8vector->nonneg-integer (base64-string->u8vector str)))

;;;---------------------------------------------------------------------------

(define (nonneg-integer-expt-mod x y m)

  ;; computes x^y mod m

  ;; TODO: use Montgomery algorithm

  (declare (generic))

  (define (expt-mod n e m)
    (cond ((zero? e)
           1)
          ((even? e)
           (expt-mod (modulo (* n n) m) (quotient e 2) m))
          (else
           (modulo (* n (expt-mod n (- e 1) m)) m))))

  (expt-mod x y m))

;;;============================================================================
