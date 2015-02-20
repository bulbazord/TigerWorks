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

        String helpMessage = "";
        if (re.token.getType() == INVALID_INTLIT) {
            helpMessage = "Integers cannot have leading zeros";
        } else if (re.token.getType() == INVALID_FIXEDPTLIT) {
            helpMessage = "Invalid fixed point literal";
        } else if (re.token.getType() == INVALID_ID) {
            helpMessage = "Invalid identifier";
        }

        String errorMessage = getErrorMessage(re, tokens);
        if (re instanceof MismatchedSetException) {
            MismatchedSetException mse = (MismatchedSetException) re;
            errorMessage = "You provided a " + 
                            tokenNames[re.token.getType()] +
                            ", but something else was expected";
        } else if (re instanceof MismatchedTokenException) {
            MismatchedTokenException mte = (MismatchedTokenException) re;
            errorMessage = "You provided a " +
                            tokenNames[re.token.getType()] +
                            ", but this was expected instead: " +
                            tokenNames[mte.expecting];
        }

        System.out.print("Line " + lineNo + ":" + charNo + ": ");
        System.out.print(errorMessage);
        if (helpMessage.length() > 0) {
            System.out.print(" (" + helpMessage + ")");
        }
        System.out.println();
        System.out.println("\t" + badLine);
        System.out.print("\t");
        for (int i = 0; i < re.charPositionInLine; i++) {
            System.out.print(" ");
        }
        System.out.println("^");
        System.out.println();
    }
}

// Lexer custom code 
@lexer::members {

    /* Override specifically to be able to provide INVALID_TYPE
     * tokens, makes parsing easier.
     */
    @Override
    public Token nextToken() {
        while (true) {
            state.token = null;
            state.channel = Token.DEFAULT_CHANNEL;
            state.tokenStartCharIndex = input.index();
            state.tokenStartCharPositionInLine = input.getCharPositionInLine();
            state.tokenStartLine = input.getLine();
            state.text = null;
            if ( input.LA(1) == CharStream.EOF) {
                return getEOFToken();
            }
            try {
                mTokens();
                if (state.token == null) {
                    emit();
                } else if (state.token == Token.SKIP_TOKEN) {
                    continue;
                }
                return state.token;
            } catch(RecognitionException re) {
                reportError(re);
                if (re instanceof NoViableAltException) {
                    recover(re);
                }
                Token t = new CommonToken(input, Token.INVALID_TOKEN_TYPE,
                                            Token.DEFAULT_CHANNEL,
                                            state.tokenStartCharIndex,
                                            getCharIndex() - 1);
                t.setLine(state.tokenStartLine);
                t.setCharPositionInLine(state.tokenStartCharPositionInLine);
                emit(t);
                return state.token;
            }
        }
    }

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
        // Report the syntactic mistake
        System.out.println("Line " + lineNo + ":" + charNo + ": " + "invalid start of token");
        System.out.println("\t" + badLine);
        System.out.print("\t");
        for (int i = 0; i < re.charPositionInLine; i++) {
            System.out.print(" ");
        }
        System.out.println("^");
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

// Index expression
indexexpr       : indexmultexpr (addsubop^ indexmultexpr)*;
indexmultexpr   : indexlit (multdivop^ indexlit)*; 
indexlit        : INTLIT | ID | FIXEDPTLIT;

// Binary Operators
multdivop       : MULT | DIV;
addsubop        : PLUS | MINUS;
compareop       : EQ | NEQ | LESSER | LESSEREQ | GREATER | GREATEREQ;
logicop         : AND | OR;
