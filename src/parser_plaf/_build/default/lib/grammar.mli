
(* The type of tokens. *)

type token = 
  | UNPAIR
  | UNITTYPE
  | TREETYPE
  | TL
  | TIMES
  | THEN
  | SUPER
  | SUM
  | SND
  | SETREF
  | SET
  | SEND
  | SEMICOLON
  | SELF
  | RRANGLE
  | RPAREN
  | REFTYPE
  | RBRACE
  | RANGLE
  | PUSH
  | PROD
  | PROC
  | POP
  | PLUS
  | PEEK
  | PAIR
  | OF
  | NODE
  | NEWREF
  | NEW
  | MKLIST
  | MINUS
  | MIN
  | METHOD
  | MAXL
  | LPAREN
  | LLANGLE
  | LISTTYPE
  | LETREC
  | LET
  | LBRACE
  | LANGLE
  | ISZERO
  | ISNUMBER
  | INTTYPE
  | INTERFACE
  | INT of (int)
  | INSTANCEOF
  | IN
  | IMPLEMENTS
  | IF
  | ID of (string)
  | HD
  | FST
  | FIELD
  | EXTENDS
  | EQUALSMUTABLE
  | EQUALS
  | EOF
  | END
  | EMPTYTREE
  | EMPTYSTACK
  | EMPTYPRED
  | EMPTYLIST
  | ELSE
  | DOT
  | DIVIDED
  | DEREF
  | DEBUG
  | CONS
  | COMMA
  | COLON
  | CLASS
  | CAST
  | CASET
  | BOOLTYPE
  | BEGIN
  | AVG
  | ARROW
  | ABS

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val prog: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.prog)
