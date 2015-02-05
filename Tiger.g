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
functdecllist    : functdecl functdecllist
                 |/*epsilon*/;
functdecl        : rettype function ID LPAREN paramlist RPAREN BEGIN blocklist END;
mainfunc         : VOID MAIN LPAREN RPAREN BEGIN blocklist END;
rettype          : VOID|typeid;
paramlist        : param paramlisttail|/*epsilon*/;
paramlisttail    : param paramlisttail|/*epsilon*/;
param            : ID COLON typeid;
blocklist        : block blocktail;
blocktail        : block blocktail;|/*epsilon*/;
block            : BEGIN NUMBER /*placeholder */ END;
typeid           : TYPE /*placeholder*/;
var              : ID;
expr             : factor ( PLUS factor)*;
factor           : NUMBER;
typedecllist     : NUMBER /*placeholder*/;
function         : NUMBER /*placeholder*/;
