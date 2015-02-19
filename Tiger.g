// Rudimentary Grammar file
grammar Tiger;

options {
    k = 1;
    output = AST;
}

tokens {
    COMMA       = ',';
    COLON       = ':';
    SEMI        = ';';
    LPAREN      = '(';
    RPAREN      = ')';
    MULT        = '*';
    DIV         = '/';
    PLUS        = '+';
    MINUS       = '-';
    EQ          = '=';
    NEQ         = '<>';
    GREATER     = '>';
    LESSER      = '<';
    GREATEREQ   = '>=';
    LESSEREQ    = '<=';
    AND         = '&';
    OR          = '|';
    LBRACK      = '[';
    RBRACK      = ']';
    ASSIGN      = ':=';
   
}

// Parser custom code
@parser::members {
    public void displayRecognitionError(String[] tokens, RecognitionException re) {
        // First, split the program into lines and identify the offending line
        String program = re.input.toString();
        int lineNo = re.line - 1;
        int charNo = re.charPositionInLine;
        String[] lines = program.split("\\n");
        String badLine = lines[lineNo];

        // Display error
        System.out.println("Line " + lineNo + ":" + charNo + ": " + badLine);
        System.out.println(getErrorMessage(re, tokens));
        System.out.println();
    }
}

// Lexer custom code 
@lexer::members {

    /* Override to be able to count the number of syntax errors. 
     * Lexer does not count the number of errors.
     */
    @Override
    public void reportError(RecognitionException re) {
        state.syntaxErrors++;
        displayRecognitionError(this.getTokenNames(), re);
    }

    /*  This method is overrided so that we can print out helpful
     *  error messages for during scanning.
     */
    public void displayRecognitionError(String[] tokens, RecognitionException re) {

        // First, split the program into lines and identify the offending line
        String program = re.input.toString();
        int lineNo = re.line - 1;
        int charNo = re.charPositionInLine;
        String[] lines = program.split("\\n");
        String badLine = lines[lineNo];

        // Next process the line to make it easier to manipulate
        badLine.replace('\t', ' ');

        // Identify the malformed token
        // Wrap quotations around the bad part
        String errorLine = badLine.substring(0, charNo)
                        + "'" 
                        + badLine.charAt(charNo)
                        + "'"
                        + badLine.substring(charNo + 1, badLine.length());

        // Report the syntactic mistake
        System.out.println("Line " + lineNo + ":" + charNo + ": " + errorLine);
        System.out.println(getErrorMessage(re, tokens));
        System.out.println();
    }
}

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

WHITESPACE
    : ( '\t' | ' ' | '\r' | '\n' | '\u000C' )+ {$channel = HIDDEN;};

INVALID_INTLIT
    : '0'('0'..'9')+;

INTLIT
    : ((DIGIT)('0' | DIGIT)*) | '0';


// First, match the case where there are more than 3 decimals
// Second, match the case where the decimals are fine but has leading zeros
// Third, match the case where there are no decimals
INVALID_FIXEDPTLIT
    : (INTLIT | INVALID_INTLIT)?'.'('0' | DIGIT)('0' | DIGIT)('0' | DIGIT)('0' | DIGIT)+
    | (INVALID_INTLIT)?'.'('0'|DIGIT)(('0'|DIGIT)('0' | DIGIT)?)?
    | (INTLIT | INVALID_INTLIT)?'.'
    ;

FIXEDPTLIT
    : (INTLIT)'.'('0' | DIGIT)(('0' | DIGIT) ('0' | DIGIT)?)?;

// Invalid IDs start with either a digit or an underscore
INVALID_ID
    : ( '0'..'9' | '_' ) (UPPERCASE | LOWERCASE | '0'..'9' | '_')*;

ID  
    : ( UPPERCASE | LOWERCASE) ( UPPERCASE | LOWERCASE | '0'..'9' | '_')*;

COMMENT
    : '/*' ( options {greedy=false;} : . )* '*/' {$channel = HIDDEN;};


fragment DIGIT
    : '1'..'9';

fragment LOWERCASE
    : 'a'..'z';

fragment UPPERCASE
    : 'A'..'Z';

 
// Parser rules
// These are for a test only. Everything will change later

tigerprogram    : indexexpr^ EOF;

// Function Declaration list
functdecllist   : functdecl^ (functdecllist)*;
functdecl       : rettype FUNCTION ID LPAREN paramlist RPAREN BEGIN blocklist END;
mainfunction    : VOID MAIN LPAREN RPAREN BEGIN blocklist END;


// Block list
blocklist       : block^ (blocktail)*;
blocktail       : block;
block           : BEGIN declsegment statseq END;

// Declaration statements
declsegment     : typedecllist vardecllist;
typedecllist    : (typedecl)*;
vardecllist     : (vardecl)*;

// Param list
paramlist       : param^ (paramlisttail)* | /*epsilon*/;
paramlisttail   : param;
param           : ID COLON typeid;
typeid          : basetype | ID;
basetype        : INTLIT | FIXEDPTLIT;

// Expressions
expr            : logicexpr (logicop^ logicexpr)*;
logicexpr       : compareexpr (compareop^ compareexpr)*;
compareexpr     : addsubexpr (addsubop^ addsubexpr)*;
addsubexpr      : exprlit (multdivop^ exprlit)*;
exprlit         : const | value | LPAREN expr RPAREN | expr;

// Constant/Value
const           : INTLIT | FIXEDPTLIT;
value           : ID (valuetail)*;
valuetail       : LBRACK indexexpr RBRACK (LBRACK indexexpr RBRACK)?;

// Index expression
indexexpr       : indexmultexpr (addsubop^ indexmultexpr)*;
indexmultexpr   : indexlit (multdivop^ indexlit)*; 
indexlit        : INTLIT | ID | FIXEDPTLIT;

// Binary Operators
multdivop       : MULT | DIV;
addsubop        : PLUS | MINUS;
compareop       : EQ | NEQ | LESSER | LESSEREQ | GREATER | GREATEREQ;
logicop         : AND | OR;
