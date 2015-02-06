// Rudimentary Grammar file
grammar Tiger;

options {
    k = 1;
}

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

tigerprogram    : typedecllist functdecllist mainfunc;
functdecllist   : functdecl functdecllist | /*epsilon*/;
functdecl       : rettype FUNCTION ID LPAREN paramlist RPAREN BEGIN blocklist END SEMI;
mainfunc        : VOID MAIN LPAREN RPAREN BEGIN blocklist END SEMI;
rettype         : VOID | typeid;
paramlist       : param paramlisttail | /*epsilon*/;
paramlisttail   : COMMA param paramlisttail | /*epsilon*/;
param           : ID COLON typeid;
blocklist       : block blocktail;
blocktail       : block blocktail | /*epsilon*/;
block           : BEGIN declseg statseq END SEMI;
declseg         : typedecllist vardecllist; 
typedecllist    : typedecl typedecllist | /*epsilon*/;
vardecllist     : vardecl vardecllist | /*epsilon*/;
typedecl        : TYPE ID EQ type;
/* Continue writing at <type> rule */
