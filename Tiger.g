// Rudimentary Grammar file
grammar Tiger;

tokens {
    UNDERSCORE  = '_';
    PLUS        = '+';
    MINUS       = '-';
    MULT        = '*';
    DIV         = '/';
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
