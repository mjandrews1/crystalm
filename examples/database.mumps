; Database example
; This program demonstrates database operations

SETUP ; Setup test data
 SET ^PERSONS(1,"NAME")="John Doe"
 SET ^PERSONS(1,"AGE")=30
 SET ^PERSONS(1,"CITY")="New York"
 SET ^PERSONS(2,"NAME")="Jane Smith"
 SET ^PERSONS(2,"AGE")=25
 SET ^PERSONS(2,"CITY")="Los Angeles"
 SET ^PERSONS(3,"NAME")="Bob Johnson"
 SET ^PERSONS(3,"AGE")=35
 SET ^PERSONS(3,"CITY")="Chicago"
 WRITE "Data setup complete.",!
 QUIT

LIST ; List all persons
 WRITE "Person List:",!
 WRITE "============",!
 SET ID=""
 FOR  SET ID=$ORDER(^PERSONS(ID)) QUIT:ID=""  DO
 . WRITE "ID: ",ID,!
 . WRITE "  Name: ",^PERSONS(ID,"NAME"),!
 . WRITE "  Age: ",^PERSONS(ID,"AGE"),!
 . WRITE "  City: ",^PERSONS(ID,"CITY"),!
 . WRITE !
 QUIT

FIND(NAME) ; Find a person by name
 SET ID=""
 FOR  SET ID=$ORDER(^PERSONS(ID)) QUIT:ID=""  DO
 . IF ^PERSONS(ID,"NAME")=NAME DO
 . . WRITE "Found: ",NAME,!
 . . WRITE "  ID: ",ID,!
 . . WRITE "  Age: ",^PERSONS(ID,"AGE"),!
 . . WRITE "  City: ",^PERSONS(ID,"CITY"),!
 QUIT

DELETE(ID) ; Delete a person
 IF $DATA(^PERSONS(ID)) DO
 . KILL ^PERSONS(ID)
 . WRITE "Deleted person ID: ",ID,!
 ELSE  DO
 . WRITE "Person ID not found: ",ID,!
 QUIT

COUNT() ; Count persons
 SET COUNT=0
 SET ID=""
 FOR  SET ID=$ORDER(^PERSONS(ID)) QUIT:ID=""  SET COUNT=COUNT+1
 QUIT COUNT
