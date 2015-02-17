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
        // Wrap quotations around the malformed token

        // Report the syntactic mistake
        System.out.println("Line " + lineNo + ":" + charNo + ": " + badLine);
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

ID  
    : ( UPPERCASE | LOWERCASE) ( UPPERCASE | LOWERCASE | DIGIT | '_')*;

COMMENT
    : '/*' ( options {greedy=false;} : . )* '*/' {$channel = HIDDEN;};

INTLIT
    : ((DIGIT)('0' | DIGIT)*) | '0';

FIXEDPTLIT
    : (INTLIT)'.'('0' | DIGIT)(('0' | DIGIT) ('0' | DIGIT)?)?;

fragment DIGIT
    : '1'..'9';

fragment LOWERCASE
    : 'a'..'z';

fragment UPPERCASE
    : 'A'..'Z';

 
// Parser rules
// These are for a test only. Everything will change later

factor      : VOID MAIN LPAREN RPAREN BEGIN assigns END SEMI;
assigns     : ID ASSIGN ID SEMI assigns | ;
