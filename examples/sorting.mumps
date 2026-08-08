; Sorting Example
; This program demonstrates sorting algorithms in MUMPS

BUBBLE ; Bubble sort an array
 ; Input: ARRAY - array to sort
 ; Output: ARRAY - sorted array
 SET N=$ORDER(ARRAY(""),-1)
 FOR I=1:1:N-1 DO
 . FOR J=1:1:N-I DO
 . . IF ARRAY(J)>ARRAY(J+1) DO
 . . . SET TEMP=ARRAY(J)
 . . . SET ARRAY(J)=ARRAY(J+1)
 . . . SET ARRAY(J+1)=TEMP
 QUIT

TESTSORT ; Test sorting algorithms
 ; Initialize array
 FOR I=1:1:10 SET ARRAY(I)=$RANDOM(100)
 
 ; Display unsorted array
 WRITE "Unsorted array:",!
 FOR I=1:1:10 WRITE ARRAY(I)," "
 WRITE !,!
 
 ; Sort array
 DO BUBBLE
 
 ; Display sorted array
 WRITE "Sorted array:",!
 FOR I=1:1:10 WRITE ARRAY(I)," "
 WRITE !
 QUIT
