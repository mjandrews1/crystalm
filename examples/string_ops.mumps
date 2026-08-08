; String Operations Example
; This program demonstrates string manipulation in MUMPS

REVERSE(STR) ; Reverse a string
 SET RESULT=""
 SET LEN=$LENGTH(STR)
 FOR I=LEN:-1:1 SET RESULT=RESULT_$EXTRACT(STR,I)
 QUIT RESULT

UPPER(STR) ; Convert string to uppercase
 SET RESULT=""
 SET LEN=$LENGTH(STR)
 FOR I=1:1:LEN DO
 . SET C=$EXTRACT(STR,I)
 . SET CODE=$ASCII(C)
 . IF CODE>=97,CODE<=122 SET C=$CHAR(CODE-32)
 . SET RESULT=RESULT_C
 QUIT RESULT

LOWER(STR) ; Convert string to lowercase
 SET RESULT=""
 SET LEN=$LENGTH(STR)
 FOR I=1:1:LEN DO
 . SET C=$EXTRACT(STR,I)
 . SET CODE=$ASCII(C)
 . IF CODE>=65,CODE<=90 SET C=$CHAR(CODE+32)
 . SET RESULT=RESULT_C
 QUIT RESULT

TRIM(STR) ; Remove leading and trailing spaces
 SET LEN=$LENGTH(STR)
 SET START=1
 FOR I=1:1:LEN QUIT:$EXTRACT(STR,I)'=" "  SET START=I+1
 SET END=LEN
 FOR I=LEN:-1:1 QUIT:$EXTRACT(STR,I)'=" "  SET END=I-1
 QUIT $EXTRACT(STR,START,END)

TESTSTRING ; Test string operations
 WRITE "String Operations Test:",!
 WRITE "========================",!
 
 SET STR="Hello, World!"
 WRITE "Original: ",STR,!
 WRITE "Reversed: ",$$REVERSE(STR),!
 WRITE "Uppercase: ",$$UPPER(STR),!
 WRITE "Lowercase: ",$$LOWER(STR),!
 
 SET STR="  Hello, World!  "
 WRITE "Trimmed: '",$$TRIM(STR),"'",!
 QUIT
