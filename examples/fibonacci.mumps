; Fibonacci example
; This program calculates Fibonacci numbers

FIBONACCI(N) ; Calculate Nth Fibonacci number
 I N<2 QUIT N ; Base case: F(0)=0, F(1)=1
 QUIT $$FIBONACCI(N-1)+$$FIBONACCI(N-2) ; Recursive case: F(N)=F(N-1)+F(N-2)

TEST ; Test the Fibonacci function
 FOR I=0:1:10 DO
 . WRITE "F(",I,") = ",$$FIBONACCI(I),!
 QUIT
