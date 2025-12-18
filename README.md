<p align="center"><b>МОНУ НТУУ КПІ ім. Ігоря Сікорського ФПМ СПіСКС</b></p>
<p align="center">
<b>Звіт з лабораторної роботи 2</b><br/>
"Рекурсія"<br/>
дисципліни "Вступ до функціонального програмування"
</p>
<p align="right"><b>Студент(-ка)</b>: Корольов Юрій Ігорович КВ-23</p>
<p align="right"><b>Рік</b>: 2025</p>

## Загальне завдання
Реалізуйте дві рекурсивні функції, що виконують деякі дії з вхідним(и) списком(-ами), за можливості/необхідності використовуючи різні види рекурсії. Вимоги до функцій:
1. Зміна списку має відбуватись за рахунок конструювання нового списку, а не зміни наявного (вхідного).
2. Не допускається використання функцій вищого порядку чи стандартних функцій для роботи зі списками, що не наведені в четвертому розділі навчального посібника.
3. Реалізована функція не має бути функцією вищого порядку.
4. Не допускається використання псевдофункцій (деструктивного підходу).
5. Не допускається використання циклів.

## Варіант 11
1. Написати функцію `remove-thirds`, яка видаляє зі списку кожен третій елемент.
2. Написати функцію `list-set-union-3`, яка визначає об'єднання трьох множин, заданих списками атомів.

## Лістинг функції remove-thirds
```lisp
(defun remove-thirds (lst)
  "Видаляє зі списку кожен третій елемент (індекси 2, 5, 8... якщо рахувати з 0)"
  (cond
    ((null lst) nil)                   ; Базовий випадок: список порожній
    ((null (cdr lst)) lst)             ; 1 елемент: повертаємо його
    ((null (cddr lst)) lst)            ; 2 елементи: повертаємо їх
    (t (cons (car lst)                 ; Конструюємо список: беремо 1-й
             (cons (cadr lst)          ; беремо 2-й
                   (remove-thirds (cdddr lst))))))) ; пропускаємо 3-й і рекурсивно йдемо далі
```

### Тестові набори
```lisp
(defun check-remove-thirds (name input expected)
  "Виконує `remove-thirds` на `input`, порівнює результат з `expected` 
   і друкує статус порівняння"
  (format t "~:[FAILED~;passed~] ~a~%"
      (equal (remove-thirds input) expected)
      name))

(defun test-remove-thirds ()
  (check-remove-thirds "test variant" '(a b c d e f g) '(a b d e g))
  (check-remove-thirds "test numbers" '(1 2 3 4 5 6 7 8 9) '(1 2 4 5 7 8))
  (check-remove-thirds "test short" '(1 2) '(1 2))
  (check-remove-thirds "test exact 3" '(1 2 3) '(1 2))
  (check-remove-thirds "test empty" nil nil))
```

### Тестування
```lisp
CL-USER> (test-remove-thirds)
passed test variant
passed test numbers
passed test short
passed test exact 3
passed test empty
NIL
```

## Лістинг функції list-set-union-3
```lisp
;; Допоміжна функція: перевірка наявності елемента у списку
(defun contains (item lst)
  (cond
    ((null lst) nil)
    ((equal item (car lst)) t)
    (t (contains item (cdr lst)))))

;; Допоміжна функція: об'єднання двох множин
(defun list-union-two (lst1 lst2)
  (cond
    ((null lst1) lst2) ; Якщо перший список вичерпано, додаємо хвіст другого
    ((contains (car lst1) lst2) 
     ;; Якщо елемент вже є в lst2, пропускаємо його (уникаємо дублікатів)
     (list-union-two (cdr lst1) lst2))
    (t 
     ;; Якщо елемента немає, додаємо його до результату
     (cons (car lst1) (list-union-two (cdr lst1) lst2)))))

;; Основна функція: об'єднання трьох множин
(defun list-set-union-3 (lst1 lst2 lst3)
  "Визначає об'єднання трьох множин, заданих списками атомів"
  (list-union-two lst1 (list-union-two lst2 lst3)))
```

### Тестові набори
```lisp
(defun check-union-3 (name l1 l2 l3 expected)
  "Виконує `list-set-union-3` на вхідних списках, порівнює результат з `expected` 
   і друкує статус порівняння"
  (format t "~:[FAILED~;passed~] ~a~%"
      (equal (list-set-union-3 l1 l2 l3) expected)
      name))

(defun test-list-set-union-3 ()
  ;; Тест з варіанту: порядок елементів може відрізнятись, але множина та сама.
  ;; У даній реалізації порядок буде (1 2 3 4 NIL T)
  (check-union-3 "test variant" '(1 2 3) '(2 3 4) '(nil t) '(1 2 3 4 nil t))
  (check-union-3 "test disjoint" '(1 2) '(3 4) '(5 6) '(1 2 3 4 5 6))
  (check-union-3 "test identical" '(a b) '(a b) '(a b) '(a b))
  (check-union-3 "test mixed overlap" '(1 2) '(2 3) '(3 4) '(1 2 3 4))
  (check-union-3 "test empty" nil nil nil nil))
```

### Тестування
```lisp
CL-USER> (test-list-set-union-3)
passed test variant
passed test disjoint
passed test identical
passed test mixed overlap
passed test empty
NIL
```
