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
@parser::header {
}

@parser::members {
    /* Override to allow custom displayRecognitionError
    @Override
    public void reportError(RecognitionException re) {
        displayRecognitionError(this.getTokenNames(), re);
    }

    public void displayRecognitionError(this.getTokenNames(), re) {
    }
    */
}

// Lexer custom code 
@lexer::header {
}

@lexer::members {

    /*  Override this, or else it will ignore our 
     *  overrided displayRecognitionError
     */
    @Override
    public void reportError(RecognitionException re) {
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
    : ( '0'..'9' | '_' ) (UPPERCASE | LOWERCASE | '0'..'9' | '_')+;

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

tigerprogram    : typedecllist functdecllist mainfunction EOF;

// Function Declaration list
functdecllist   : (functdecl^ (functdecllist)*)?;
functdecl       : rettype FUNCTION ID LPAREN paramlist RPAREN BEGIN blocklist END;
mainfunction    : VOID MAIN LPAREN RPAREN BEGIN blocklist END;

// Return type
rettype         : VOID | typeid;

// Block list
blocklist       : block^ (blocktail)*;
blocktail       : block;
block           : BEGIN declsegment statseq END;

// Declaration statements
declsegment     : typedecllist vardecllist;
typedecllist    : (typedecl)*;
vardecllist     : (vardecl)*;
vardecl         : VAR idlist COLON typeid optionalinit SEMI;
typedecl        : TYPE ID EQ type SEMI;
// Type statements
type            : basetype | ARRAY LBRACK INTLIT RBRACK (LBRACK INTLIT RBRACK)? OF basetype;

// Param list
paramlist       : (param^ (paramlisttail)*)?;
paramlisttail   : param;
param           : ID COLON typeid;
typeid          : basetype | ID;
basetype        : INTLIT | FIXEDPTLIT;

// idlist and optionalinit and optprefix
idlist          : ID (COMMA idlist)*;
optionalinit    : (ASSIGN const)?;

// Statseq and Stat and optprefix
statseq         : stat (statseq)*;
stat            : value ASSIGN expr SEMI | IF expr THEN statseq ENDIF SEMI | IF expr THEN statseq ELSE statseq ENDIF SEMI | WHILE expr DO statseq ENDDO SEMI | FOR ID ASSIGN indexexpr TO indexexpr DO statseq ENDDO SEMI | optprefix ID LPAREN exprlist RPAREN SEMI | BREAK SEMI | RETURN expr SEMI | block;
optprefix       : (value ASSIGN)?;
// Expressions
expr            : logicexpr (logicop^ logicexpr)*;
logicexpr       : compareexpr (compareop^ compareexpr)*;
compareexpr     : addsubexpr (addsubop^ addsubexpr)*;
addsubexpr      : exprlit (multdivop^ exprlit)*;
exprlit         : const | value | LPAREN expr RPAREN;

// Constant/Value
const           : INTLIT | FIXEDPTLIT;
value           : ID valuetail;
valuetail       : (LBRACK indexexpr RBRACK (LBRACK indexexpr RBRACK)?)?;

// Expression list
exprlist        : (expr exprlisttail)*;
exprlisttail    : expr;

// Index expression
indexexpr       : indexmultexpr (addsubop^ indexmultexpr)*;
indexmultexpr   : indexlit (multdivop^ indexlit)*; 
indexlit        : INTLIT | ID | FIXEDPTLIT;

// Binary Operators
multdivop       : MULT | DIV;
addsubop        : PLUS | MINUS;
compareop       : EQ | NEQ | LESSER | LESSEREQ | GREATER | GREATEREQ;
logicop         : AND | OR;
