#lang ragg

;;; Program Structure:

class: "class" className "{" classVarDec* subroutineDec* "}"

classVarDec: ("static" | "field") type varName ("," varName)* ";"

type: "int" | "char" | "boolean" | className

subroutineDec: (("constructor" | "function" | "method")
                returnType
                subroutineName "(" parameterList ")"
                subroutineBody)

returnType: "void" | type

parameterList: [(type varName) ("," type varName)*]

subroutineBody: "{" varDec* statements "}"

varDec: "var" type varName ("," varName)* ";"

className: ID

subroutineName: ID

varName: ID

;;; Statements:

statements: statement*

statement: (letStatement
            | ifStatement
            | whileStatement
            | doStatement
            | returnStatement)

letStatement: "let" varName ["[" expression "]"] "=" expression ";"

ifStatement: ("if" "(" expression ")" "{" statements "}"
              ["else" "{" statements "}"])

whileStatement: "while" "(" expression ")" "{" statements "}"

doStatement: "do" subroutineCall ";"

returnStatement: "return" [expression] ";"

;;; Expressions:

expression: term (op term)*

term: (NUM
       | STR
       | keywordConstant
       | varName ["[" expression "]"]
       | subroutineCall
       | "(" expression ")"
       | unaryOp term)

subroutineCall: (subroutineName "(" expressionList ")"
                 | (className | varName) "." subroutineName "(" expressionList ")")

expressionList: [expression ("," expression)*]

op: "+" | "-" | "*" | "/" | "&" | "|" | "<" | ">" | "="

unaryOp: "-" | "~"

keywordConstant: "true" | "false" | "null" | "this"
