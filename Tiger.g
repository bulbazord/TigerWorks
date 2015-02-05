// Rudimentary Grammar file
grammar Tiger;

tokens {
    COMMA       = ',';
    COLON       = ':';
    SEMI        = ';';
    LPAREN      = '(';
    RPAREN      = ')';
    LBRACK      = '[';
    RBRACK      = ']';
    PLUS        = '+';
    MINUS       = '-';
    MULT        = '*';
    DIV         = '/';
    EQ          = '=';
    NEQ         = '<>';
    LESSER      = '<';
    LESSEREQ    = '<=';
    GREATER     = '>';
    GREATEREQ   = '>=';
    AND         = '&';
    OR          = '|';
    ASSIGN      = ':=';
    UNDERSCORE  = '_';
   
}
// Lexer Rules

// Finish filling in other keywords and other lexer rules

FUNCTION
    : 'function';

BEGIN
    : 'begin';

END 
    : 'end';

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

 
// Parser rules

// These are for a test only. Everything will change later

tigerprogram     : typedecllist functdecllist mainfunc;
functdecllist    : PLUS functdecllist
                 |/*epsilon*/;
//functdecl        : rettype function ID LPAREN paramlist RPAREN BEGIN blocklist END;
mainfunc         : VOID MAIN LPAREN RPAREN BEGIN NUMBER END;
//rettype          : VOID|typeid;
//paramlist        : param paramlisttail|/*epsilon*/;
//paramlisttail    : param paramlisttail|/*epsilon*/;
//param            : ID COLON typeid;
//blocklist        : block blocktail;
//blocktail        : block blocktail;|/*epsilon*/;
//block            : BEGIN NUMBER /*placeholder */ END;
//typeid           : TYPE /*placeholder*/;
var              : ID;
expr             : factor ( PLUS factor)*;
factor           : NUMBER;
typedecllist     : NUMBER (UNDERSCORE)* /*placeholder*/;
//function         : NUMBER /*placeholder*/;
