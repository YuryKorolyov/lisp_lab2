;;; ---------------------------------------------------------------------------
;;; Завдання 1. Видалити кожен третій елемент зі списку.
;;; ---------------------------------------------------------------------------

(defun remove-thirds (lst)
  "Видаляє кожен третій елемент зі списку lst."
  (cond
    ((null lst) nil)                     ; Якщо список порожній -> nil
    ((null (cdr lst)) lst)               ; Якщо 1 елемент -> повертаємо його
    ((null (cddr lst)) lst)              ; Якщо 2 елементи -> повертаємо їх
    (t (cons (car lst)                   ; Беремо 1-й елемент
             (cons (cadr lst)            ; Беремо 2-й елемент
                   (remove-thirds (cdddr lst))))))) ; Пропускаємо 3-й, рекурсія з 4-го

;;; --- Тести для завдання 1 ---

(defun check-remove-thirds (name input expected)
  (format t "~:[FAILED~;passed~] ~a~%"
          (equal (remove-thirds input) expected)
          name))

(defun test-remove-thirds ()
  (format t "--- Testing remove-thirds ---~%")
  (check-remove-thirds "test 1 (a b c d e f g)" 
                       '(a b c d e f g) 
                       '(a b d e g))
  (check-remove-thirds "test 2 (1 2 3)" 
                       '(1 2 3) 
                       '(1 2))
  (check-remove-thirds "test 3 (1 2)" 
                       '(1 2) 
                       '(1 2))
  (check-remove-thirds "test 4 empty" 
                       nil 
                       nil)
  (check-remove-thirds "test 5 long list" 
                       '(1 2 3 4 5 6 7 8 9) 
                       '(1 2 4 5 7 8)))

;;; ---------------------------------------------------------------------------
;;; Завдання 2. Об'єднання трьох множин.
;;; ---------------------------------------------------------------------------

;; Допоміжна функція: перевірка наявності елемента в списку
(defun contains (item lst)
  (cond
    ((null lst) nil)
    ((equal item (car lst)) t)
    (t (contains item (cdr lst)))))

;; Допоміжна функція: об'єднання двох множин
(defun list-union-two (list1 list2)
  (cond
    ((null list1) list2) ; Якщо перший список порожній, результат - другий список
    ((contains (car list1) list2) 
     (list-union-two (cdr list1) list2)) ; Якщо елемент вже є в list2, пропускаємо його
    (t (cons (car list1) 
             (list-union-two (cdr list1) list2))))) ; Інакше додаємо до результату

;; Головна функція: об'єднання трьох множин
(defun list-set-union-3 (set1 set2 set3)
  "Визначає об'єднання трьох множин, заданих списками атомів."
  (list-union-two set1 (list-union-two set2 set3)))

;;; --- Тести для завдання 2 ---

;; Для перевірки множин порядок не важливий, але equal перевіряє і порядок.
;; У цій реалізації нові елементи додаються на початок, тому ми перевіряємо 
;; очікуваний результат з урахуванням логіки роботи функції.

(defun check-union-3 (name s1 s2 s3 expected)
  (let ((result (list-set-union-3 s1 s2 s3)))
    (format t "~:[FAILED~;passed~] ~a (Result: ~a)~%"
            (equal result expected) 
            name
            result)))

(defun test-union-3 ()
  (format t "~%--- Testing list-set-union-3 ---~%")
  (check-union-3 "test 1 (example)" 
                 '(1 2 3) '(2 3 4) '(nil t) 
                 '(1 2 3 4 nil t))
  
  (check-union-3 "test 2 (disjoint)" 
                 '(a b) '(c d) '(e f) 
                 '(a b c d e f))
  
  (check-union-3 "test 3 (identical)" 
                 '(1 2) '(1 2) '(1 2) 
                 '(1 2))
  
  (check-union-3 "test 4 (nested)" 
                 '(1) nil '(2) 
                 '(1 2)))

;;; Запуск тестів
(test-remove-thirds)
(test-union-3)