// Rudimentary Grammar file
grammar Tiger;

tokens {
    UNDERSCORE  = '_';
    PLUS        = '+';
    MINUS       = '-';
    MULT        = '*';
    DIV         = '/';
    COMMA       = ',';
    COLON       = ':';
    SEMI        = ';';
    LPAREN      = '(';
    RPAREN      = ')';
    LBRACK      = '[';
    RBRACK      = ']';
    EQ          = '=';
    NEQ         = '<>';
    LESSER      = '<';
    LESSEREQ    = '<=';
    GREATER     = '>';
    GREATEREQ   = '>=';
    AND         = '&';
    OR          = '|';
    ASSIGN      = ':=';
   
}

// Parser rules

// These are for a test only. Everything will change later

var     : ID;
expr    : factor ( PLUS factor)*;
factor  : NUMBER;

// Lexer Rules

// Finish filling in other keywords and other lexer rules

BEGIN
    : 'begin';

END 
    : 'end';

FUNCTION
    : 'function';

VOID
    : 'void';

MAIN
    : 'main';

TYPE
    : 'type';

ARRAY
    : 'array';

OF
    : 'of';

INT
    : 'int';

FIXEDPT
    : 'fixedpt';

VAR
    : 'var';

IF
    : 'if';

THEN
    : 'then';

ENDIF
    : 'endif';

ELSE
    : 'else';

WHILE
    : 'while';

DO
    : 'do';

ENDDO
    : 'enddo';

FOR
    : 'for';

TO
    : 'to';

DO
    : 'do';

BREAK
    : 'break';

RETURN
    : 'return';

ID  
    : ( UPPERCASE | LOWERCASE) ( UPPERCASE | LOWERCASE | DIGIT | UNDERSCORE)+;


NUMBER
    : (DIGIT)+;

WHITESPACE
    : ( '\t' | ' ' | '\r' | '\n' | '\u000C' )+ {$channel = HIDDEN;};

fragment DIGIT
    : '0'..'9';

fragment LOWERCASE
    : 'a'..'z';

fragment UPPERCASE
    : 'A'..'Z';
