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

tigerprogram    : typedecllist functdecllist mainfunc EOF;
functdecllist   : functdecl (functdecllist)* | /*epsilon*/;
functdecl       : rettype FUNCTION ID LPAREN paramlist RPAREN BEGIN blocklist END SEMI;
mainfunc        : VOID MAIN LPAREN RPAREN BEGIN blocklist END SEMI;
rettype         : VOID | typeid;
paramlist       : param paramlisttail | /*epsilon*/;
paramlisttail   : COMMA param (paramlisttail)* | /*epsilon*/;
param           : ID COLON typeid;
blocklist       : block blocktail;
blocktail       : block blocktail | /*epsilon*/;
block           : BEGIN declseg statseq END SEMI;
declseg         : typedecllist vardecllist; 
typedecllist    : typedecl (typedecllist)* | /*epsilon*/;
vardecllist     : vardecl (vardecllist)* | /*epsilon*/;
typedecl        : TYPE ID EQ type;
type            : basetype | ARRAY LBRACK NUMBER RBRACK OF basetype | ARRAY LBRACK NUMBER RBRACK LBRACK NUMBER RBRACK OF basetype;
typeid          : basetype | ID;
basetype        : INT | FIXEDPT;
vardecl         : VAR idlist COLON typeid optionalinit SEMI;
idlist          : ID | ID COMMA idlist;
optionalinit    : ASSIGN const | /*epsilon*/;
statseq         : stat | stat statseq;
stat            : value ASSIGN expr SEMI | IF expr THEN statseq ENDIF SEMI |WHILE expr DO statseq ENDDO SEMI | FOR ID ASSIGN indexexpr TO indexexpr DO statseq ENDDO SEMI | optprefix ID LPAREN exprlist RPAREN SEMI | BREAK SEMI | RETURN expr SEMI | block;
optprefix       : value ASSIGN | /*epsilon*/;
expr            : const | value | expr binaryoperator expr | LPAREN expr RPAREN;
const           : NUMBER | FIXEDPT /* check this part to make sure it is correct */;
binaryoperator  : PLUS | MINUS | MULT | DIV | EQ | NEQ | LESSER | LESSEREQ | GREATER | GREATEREQ | AND | OR;
exprlist        : expr exprlisttail | /*epsilon*/;
exprlisttail    : expr (exprlisttail)* | /*epsilon*/;
value           : ID valuetail;
valuetail       : LBRACK indexexpr RBRACK | LBRACK indexexpr RBRACK LBRACK indexexpr RBRACK | /*epsilon*/;
indexexpr       : NUMBER | ID | indexexpr indexoper indexexpr;
indexoper       : PLUS | MINUS/* check to make sure it is correct*/ | MULT;
