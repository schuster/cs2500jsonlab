#lang racket
(require rackunit)

; ----- JSON Parsing -----
(require json)

; A JSON is one of:
; - String
; - Number
; - Boolean
; - 'null
; - JSONArray
; - JSONObject

;;A JSONArray is a [List-of JSON])

;;A JSONObject is a [List-of JSONPair]

;;A JSONPair is a (list Symbol JSON)

;;A PartialJson is one of:
; - String
; - Number
; - Boolean
; - 'null
; - [List-of PartialJson]
; - [HashMap Symbol PartialJson]

;;parse-hashmaps : PartialJson -> Json
;;Parse the hashmaps into association lists
(define (parse-hashmaps pj)
  (cond [(cons? pj) (map parse-hashmaps pj)]
        [(hash? pj) (hash-map pj (λ (x y) (list x (parse-hashmaps y))))]
        [else pj]))
(check-equal? (parse-hashmaps "hi") "hi")
(check-equal? (parse-hashmaps (list (make-immutable-hasheq (list (cons 'a 1)))
                                    (make-immutable-hasheq (list (cons 'b true)))
                                    (make-immutable-hasheq (list (cons 'c "hello")))))
              '(((a 1)) ((b #t)) ((c "hello"))))

;; string->json : RawJsonString -> JSon
;; Parse the string
(define (string->json rjs)
  (parse-hashmaps (string->jsexpr rjs)))

; ----- HTTP -----
(require net/url)

; String -> String
(define (get-url str)
  (string-trim (bytes->string/utf-8
    (port->bytes (get-pure-port (string->url str) #:redirections 5)))))

; ----- Provides -----

(provide string->json
         get-url)
