; Factorial example
; This program calculates the factorial of a number

FACTORIAL(N) ; Calculate factorial of N
 I N=0 QUIT 1 ; Base case: 0! = 1
 QUIT N*$$FACTORIAL(N-1) ; Recursive case: N! = N * (N-1)!

TEST ; Test the factorial function
 FOR I=0:1:10 DO
 . WRITE I,"! = ",$$FACTORIAL(I),!
 QUIT
