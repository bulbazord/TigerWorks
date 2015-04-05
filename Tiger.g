// Rudimentary Grammar file
grammar Tiger;

options {
    k = 1;
    output = AST;
    backtrack = no;
}

tokens {
    PROG;
    TYPEDECLLIST;
    TYPEDECL;
    BASETYPE;
    TYPEID;
    FUNCTDECLLIST;
    PARAMLIST;
    PARAM;
    DECLSEGMENT;
    VARDECLLIST;
    VARDECL;
    IDLIST;
    BLOCKLIST;
    BLOCK;
    STATS;
    TWODEE;
    VALUE;
    VALUETAIL;
    FUNCCALL;
    F_EXPRLIST;
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
    import java.util.ArrayList;
    import java.util.List;
}

@parser::members {

    private Scope global_scope = new Scope(null, "global");
    private Scope current_scope = global_scope;
    private SymbolTable symbolTable = new SymbolTable(global_scope);
    private boolean errorExists = false;

    public void displayRecognitionError(String[] tokens, RecognitionException re) {
        // First, split the program into lines and identify the offending line
        String program = re.input.toString();
        int lineNo = re.line - 1;
        int charNo = re.charPositionInLine;
        String[] lines = program.split("\\n");
        if (lineNo > lines.length - 1) {
            System.out.println("Reached end of line while parsing.");
            System.out.println("Did you forget to put an end somewhere?");
        } else {
            String badLine = lines[lineNo];

            // Craft a potentially helpful message
            String helpMessage = "";
            if (re.token.getType() == INVALID_INTLIT) {
                helpMessage = "Integers cannot have leading zeros";
            } else if (re.token.getType() == INVALID_FIXEDPTLIT) {
            helpMessage = "Invalid fixed point literal";
            } else if (re.token.getType() == INVALID_ID) {
                helpMessage = "Invalid identifier";
            }

            // Craft the error message
            String errorMessage = getErrorMessage(re, tokens);
            // Which bad token did they provide?
            String badToken = (re.token.getType() >= 0) ? tokenNames[re.token.getType()] : "EOF";

            // If multiple things can be matched
            if (re instanceof MismatchedSetException) {
                MismatchedSetException mse = (MismatchedSetException) re;
                errorMessage = "You provided a " + 
                                badToken + 
                                ", but something else was expected";

            // If only one thing could have been matched
            } else if (re instanceof MismatchedTokenException) {
                MismatchedTokenException mte = (MismatchedTokenException) re;
                String expected = (mte.expecting >= 0) ? tokenNames[mte.expecting] : "EOF";
                errorMessage = "You provided a " +
                                badToken +
                                ", but this was expected instead: " +
                                expected;
            } else if (re instanceof NoViableAltException) {
                errorMessage = "It does not make sense for this token " +
                                "to be in this spot.";

            }

            // Wrap quotes around the incorrect token
            int begin = re.token.getCharPositionInLine();
            int end = begin + re.token.getText().length();
            String errorLine = badLine.substring(0, begin) +
                                "\"" +
                                re.token.getText() + 
                                "\"" + 
                                badLine.substring(end, badLine.length());

            // Print out the error message
            System.out.print("Line " + lineNo + ":" + charNo + ": ");
            System.out.print(errorMessage);
            if (helpMessage.length() > 0) {
                System.out.print(" (" + helpMessage + ")");
            }
            System.out.println();
            System.out.println("\t" + errorLine);
            System.out.print("\t");
            for (int i = 0; i < re.charPositionInLine + 1; i++) {
                System.out.print(" ");
            }
            System.out.println("^");
            System.out.println();
        }
    }

    public Object[] create1DArray(String type, int length, String value) {
        if (length > 0) {
            if (type.equals("int")) {
                Integer[] arr = new Integer[length];
                if (value != null) {
                    Integer val = Integer.parseInt(value);
                    for (int i = 0; i < length; i++) {
                        arr[i] = val;
                    }
                }
                return arr;
            } else if (type.equals("fixedpt")) {
                Double[] arr = new Double[length];
                if (value != null) {
                    Double val = Double.parseDouble(value);
                    for (int i = 0; i < length; i++) {
                        arr[i] = val;
                    }
                }
                return arr;
            } 
        }
        return null;
    }

    public Object[][] create2DArray(String type, int length, int height, String value) {
        if (length > 0 && height > 0) {
            if (type.equals("int")) {
                Integer[][] arr = new Integer[length][height];
                if (value != null) {
                    Integer val = Integer.parseInt(value);
                    for (int i = 0; i < height; i++) {
                        for (int j = 0; j < length; j++) {
                            arr[j][i] = val;
                        }
                    }
                }
                return arr;
            } else if (type.equals("fixedpt")) {
                Double[][] arr = new Double[length][height];
                if (value != null) {
                    Double val = Double.parseDouble(value);
                    for (int i = 0; i < height; i++) {
                        for (int j = 0; j < length; j++) {
                            arr[j][i] = val;
                        }
                    }
                }
                return arr;
            }
        }
        return null;
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
                /* Create a custom token specifically tailored for the 
                    given input. Do NOT use Token.INVALID_TOKEN, as it
                    does not contain the information we want. To add
                    the information to it that we want, it would be
                    equivalent to doing the below anyway.
                 */
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
     * Lexer's reportError does not count the number of errors.
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

        // Insert quotes around the malformed token
        String errorLine = badLine.substring(0, charNo) + 
                            "\"" +
                            badLine.charAt(charNo) +
                            "\"" +
                            badLine.substring(charNo + 1, badLine.length());

        // Report the syntactic mistake
        System.out.println("Line " + lineNo + ":" + charNo + ": " + "invalid start of token");
        System.out.println("\t" + errorLine);
        System.out.print("\t");
        for (int i = 0; i < re.charPositionInLine + 1; i++) {
            System.out.print(" ");
        }
        System.out.println("^");
        System.out.println();
    }
}

// Keywords and other lexer rules
FUNCTION
    : 'function';

BEGIN
    : 'begin';

END 
    : 'end';

VOID
    : 'void';

VOID_FUNCTION
    : 'void function';

MAIN
    : 'main';

VOID_MAIN
    : 'void main';

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

tigerprogram returns [SymbolTable symbolTable, boolean errorExists]
    : typedecllist functdecllist mainfunction EOF {
        $symbolTable = symbolTable;
        $errorExists = errorExists;
    }
    -> ^(PROG typedecllist functdecllist mainfunction);

// typedecllist stuff
typedecllist    : (typedecl)*
                -> ^(TYPEDECLLIST typedecl*);
typedecl        : TYPE ID EQ type[$ID.text] SEMI
                -> ^(TYPEDECL TYPE ID EQ type);

type[String name]
                : basetype {
                    try {
                        if ($basetype.text.equals("int")) {
                            SymbolTableEntry temp = new TypeTableEntry(current_scope, name, PrimitiveType.TIGER_INT, 0, 0);
                            symbolTable.put(temp);
                        } else if ($basetype.text.equals("fixedpt")) {
                            SymbolTableEntry temp = new TypeTableEntry(current_scope, name, PrimitiveType.TIGER_FIXEDPT, 0, 0);
                            symbolTable.put(temp);
                        }
                    } catch (NameSpaceException nse) {
                        System.out.print("Line " + $basetype.lineNumber + ": ");
                        System.out.println(nse.getMessage());
                        errorExists = true;
                    }
                }
                | (ARRAY LBRACK INTLIT RBRACK LBRACK INTLIT RBRACK)
                  =>  ARRAY LBRACK b1=INTLIT RBRACK LBRACK b2=INTLIT RBRACK OF basetype {
                    try{
                        if ($basetype.text.equals("int")) {
                            SymbolTableEntry temp = new TypeTableEntry(current_scope, name, PrimitiveType.TIGER_INT_2D_ARR, Integer.parseInt($b1.text), Integer.parseInt($b2.text));
                            symbolTable.put(temp);
                        } else if ($basetype.text.equals("fixedpt")) {
                            SymbolTableEntry temp = new TypeTableEntry(current_scope, name, PrimitiveType.TIGER_FIXEDPT_2D_ARR, Integer.parseInt($b1.text), Integer.parseInt($b2.text));
                            symbolTable.put(temp);
                        }
                    } catch (NameSpaceException nse) {
                        System.out.print("Line " + $ARRAY.getLine() + ": ");
                        System.out.println(nse.getMessage());
                        errorExists = true;
                    }
                } -> ^(TYPE ARRAY INTLIT INTLIT basetype)
                | ARRAY LBRACK a1=INTLIT RBRACK OF basetype {
                    try {
                        if ($basetype.text.equals("int")) {
                            SymbolTableEntry temp = new TypeTableEntry(current_scope, name, PrimitiveType.TIGER_INT_ARR, Integer.parseInt($a1.text), 0);
                            symbolTable.put(temp);
                        } else if ($basetype.text.equals("fixedpt")) {
                            SymbolTableEntry temp = new TypeTableEntry(current_scope, name, PrimitiveType.TIGER_FIXEDPT_ARR, Integer.parseInt($a1.text), 0);
                            symbolTable.put(temp);
                        }
                    } catch (NameSpaceException nse) {
                        System.out.print("Line " + $ARRAY.getLine() + ": ");
                        System.out.println(nse.getMessage());
                        errorExists = true;
                    }
                } -> ^(TYPE ARRAY INTLIT basetype);

basetype returns [int lineNumber]
                : INT {
                    $lineNumber = $INT.getLine();
                } -> ^(BASETYPE INT)
                | FIXEDPT {
                    $lineNumber = $FIXEDPT.getLine();
                } -> ^(BASETYPE FIXEDPT);

//Function declaration list stuff
functdecllist   : (functdecl)*
                -> ^(FUNCTDECLLIST functdecl*);
functdecl       : VOID_FUNCTION ID {
                    current_scope = new Scope(current_scope, $ID.text);
                } LPAREN paramlist[new ArrayList<TypeTableEntry>()] RPAREN BEGIN {
                    current_scope = new Scope(current_scope);
                    try {
                        SymbolTableEntry temp = new FunctionTableEntry(global_scope, $ID.text, null, $paramlist.outParams);
                        symbolTable.put(temp);
                    } catch (NameSpaceException nse) {
                        System.out.print("Line " + $VOID_FUNCTION.getLine() + ": ");
                        System.out.println(nse.getMessage());
                    }
                }
                blocklist END {
                    current_scope = current_scope.getParent();
                    current_scope = current_scope.getParent();
                } SEMI
                -> ^(FUNCTION VOID ID paramlist blocklist)
                //////////////
                | typeid FUNCTION ID {
                    current_scope = new Scope(current_scope, $ID.text);
                } LPAREN paramlist[new ArrayList<TypeTableEntry>()] RPAREN BEGIN {
                    current_scope = new Scope(current_scope);
                    SymbolTableEntry type = symbolTable.get(current_scope, $typeid.text, false);
                    if (type == null || type instanceof VarTableEntry) {
                        errorExists = true;
                        System.out.print("Line " + $FUNCTION.getLine() + ": ");
                        System.out.println("Type " + $typeid.text + " does not exist in this scope");
                    } else {
                        try {
                            SymbolTableEntry temp = new FunctionTableEntry(global_scope, $ID.text, type, $paramlist.outParams);
                            symbolTable.put(temp);
                        } catch (NameSpaceException nse) {
                            System.out.print("Line " + $FUNCTION.getLine() + ": ");
                            System.out.println(nse.getMessage());
                        }
                    }
                } blocklist END {
                    current_scope = current_scope.getParent();
                    current_scope = current_scope.getParent();
                } SEMI
                -> ^(FUNCTION typeid ID paramlist blocklist);
typeid          : basetype 
                -> ^(TYPEID basetype)
                | ID
                -> ^(TYPEID ID);

// Paramater list stuff
paramlist[List<TypeTableEntry> inParams] returns [List<TypeTableEntry> outParams]
                : (a1=param[inParams] { 
                    $outParams = $a1.outParams;
                } (COMMA a2=param[inParams])*)? -> ^(PARAMLIST param*);

param[List<TypeTableEntry> inParams] returns [List<TypeTableEntry> outParams]
                : ID COLON typeid {
                    try {
                        if ($typeid.text.equals("int")) {
                            inParams.add((TypeTableEntry)symbolTable.getTigerInt());
                            $outParams = inParams;
                            SymbolTableEntry temp = new VarTableEntry(current_scope, $ID.text.replaceAll("\\s",""), symbolTable.getTigerInt(), ((TypeTableEntry)symbolTable.getTigerInt()).getTrueType());
                            symbolTable.put(temp);
                        } else if ($typeid.text.equals("fixedpt")) {
                            inParams.add(((TypeTableEntry)symbolTable.getTigerFixedpt()));
                            $outParams = inParams;
                            SymbolTableEntry temp = new VarTableEntry(current_scope, $ID.text.replaceAll("\\s",""), symbolTable.getTigerFixedpt(), ((TypeTableEntry)symbolTable.getTigerFixedpt()).getTrueType());
                            symbolTable.put(temp);
                        } else {
                            SymbolTableEntry type = symbolTable.get(current_scope, $typeid.text, false);
                            if (type == null || type instanceof VarTableEntry) {
                                errorExists = true;
                                System.out.println($typeid.text + " is not a declared variable in the current scope.");
                            } else {
                                inParams.add((TypeTableEntry)type);
                                $outParams = inParams;
                                SymbolTableEntry temp = new VarTableEntry(current_scope, $ID.text.replaceAll("\\s", ""), type, ((TypeTableEntry)type).getTrueType());
                                symbolTable.put(temp);
                            }
                        }
                    } catch (NameSpaceException nse) {
                        System.out.print("Line " + $ID.getLine() + ": ");
                        System.out.println(nse.getMessage());
                    }
                    
                }
                -> ^(PARAM ID typeid);

// Block list stuff

// Function Declaration list and main
mainfunction    : VOID_MAIN {
                    try {
                        SymbolTableEntry mainFunc = new FunctionTableEntry(current_scope, "main", null, new ArrayList<TypeTableEntry>());
                        symbolTable.put(mainFunc);
                    } catch (NameSpaceException nse) {
                        System.out.print("Line" + $VOID_MAIN.getLine() + ": ");
                        System.out.println(nse.getMessage());
                    }
                } LPAREN RPAREN BEGIN {
                    current_scope = new Scope(current_scope, "main");
                } blocklist END {
                    current_scope = current_scope.getParent();
                } SEMI
                -> ^(MAIN blocklist);

// Block list
blocklist       : (block)+ -> ^(BLOCKLIST block+);
block           : BEGIN {
                    current_scope = new Scope(current_scope);
                } declsegment statseq END {
                    current_scope = current_scope.getParent();
                } SEMI
                -> ^(BLOCK declsegment statseq);

// Declaration statements
declsegment     : typedecllist vardecllist
                -> ^(DECLSEGMENT typedecllist vardecllist);
vardecllist     : (vardecl)*
                -> ^(VARDECLLIST vardecl*);




/* DECLARE VARIABLE*/
vardecl         : (VAR idlist COLON typeid ASSIGN)
                => VAR idlist COLON typeid ASSIGN tiger_const SEMI
                {
                    SymbolTableEntry type = symbolTable.get(current_scope, $typeid.text, false);
                    if (type == null || type instanceof VarTableEntry) {
                        System.out.print("Line " + $VAR.getLine() + ": ");
                        System.out.println("Type " + $typeid.text + " was never defined.");
                        errorExists = true;
                    } else {
                        if (((TypeTableEntry)type).getTrueType() == PrimitiveType.TIGER_INT
                            && !(((TypeTableEntry)type).getTrueType() == PrimitiveType.TIGER_INT ||
                                 ((TypeTableEntry)type).getTrueType() == PrimitiveType.TIGER_INT_ARR ||
                                 ((TypeTableEntry)type).getTrueType() == PrimitiveType.TIGER_INT_2D_ARR)) {

                            System.out.print("Line " + $VAR.getLine() + ": ");
                            System.out.println("The assigned value and the type do not agree");
                            errorExists = true;
                        } else if ($tiger_const.type == PrimitiveType.TIGER_FIXEDPT
                            && !(((TypeTableEntry)type).getTrueType() == PrimitiveType.TIGER_FIXEDPT ||
                                 ((TypeTableEntry)type).getTrueType() == PrimitiveType.TIGER_FIXEDPT_ARR ||
                                 ((TypeTableEntry)type).getTrueType() == PrimitiveType.TIGER_FIXEDPT_2D_ARR)) {

                            System.out.print("Line " + $VAR.getLine() + ": ");
                            System.out.println("The assigned value and the type do not agree");
                            errorExists = true;
                        } else {
                            String idListRaw = $idlist.text.replaceAll("\\s", "");;
                            String[] idList = idListRaw.split(",");
                            try {
                                switch(((TypeTableEntry)type).getTrueType()) {
                                    case TIGER_INT:
                                    for (String var : idList) {
                                        SymbolTableEntry temp = new VarTableEntry(current_scope, var, type, ((TypeTableEntry)type).getTrueType(), new Integer(Integer.parseInt($tiger_const.text)));
                                        symbolTable.put(temp);
                                    }
                                    break;

                                    case TIGER_FIXEDPT:
                                    for (String var : idList) {
                                        SymbolTableEntry temp = new VarTableEntry(current_scope, var, type, ((TypeTableEntry)type).getTrueType(), new Double(Double.parseDouble($tiger_const.text)));
                                        symbolTable.put(temp);
                                    }
                                    break;

                                    case TIGER_INT_ARR:
                                    for (String var : idList) {
                                        Integer[] temp = (Integer[]) create1DArray("int", 
                                                                    ((TypeTableEntry)type).getLength(),
                                                                    $tiger_const.text);

                                        symbolTable.put(new VarTableEntry(current_scope,
                                                                    var,
                                                                    type,
                                                                    ((TypeTableEntry)type).getTrueType(),
                                                                    temp));

                                    }
                                    break;

                                    case TIGER_FIXEDPT_ARR:
                                    for (String var : idList) {
                                        Double[] temp = (Double[]) create1DArray("fixedpt", 
                                                                    ((TypeTableEntry)type).getLength(),
                                                                    $tiger_const.text);

                                        symbolTable.put(new VarTableEntry(current_scope,
                                                                    var,
                                                                    type,
                                                                    ((TypeTableEntry)type).getTrueType(),
                                                                    temp));
                                    }
                                    break;

                                    case TIGER_INT_2D_ARR:
                                    for (String var : idList) {
                                        Integer[][] temp = (Integer[][]) create2DArray("int",
                                                                    ((TypeTableEntry)type).getLength(),
                                                                    ((TypeTableEntry)type).getHeight(),
                                                                    $tiger_const.text);
                                        symbolTable.put(new VarTableEntry(current_scope,
                                                                    var,
                                                                    type,
                                                                    ((TypeTableEntry)type).getTrueType(),
                                                                    temp));

                                    }
                                    break;

                                    case TIGER_FIXEDPT_2D_ARR:
                                    for (String var : idList) {
                                        Double[][] temp = (Double[][]) create2DArray("fixedpt",
                                                                    ((TypeTableEntry)type).getLength(),
                                                                    ((TypeTableEntry)type).getHeight(),
                                                                    $tiger_const.text);
                                        symbolTable.put(new VarTableEntry(current_scope,
                                                                    var,
                                                                    type,
                                                                    ((TypeTableEntry)type).getTrueType(),
                                                                    temp));
                                    }
                                    break;


                                    default:
                                    break;
                                }
                            } catch (NameSpaceException nse) {
                                System.out.print("Line " + $VAR.getLine() + ": ");
                                System.out.println(nse.getMessage());
                                errorExists = true;
                            }
                        }
                    }
                } -> ^(VARDECL idlist typeid ASSIGN tiger_const)
                | VAR idlist COLON typeid SEMI {
                    SymbolTableEntry type = symbolTable.get(current_scope, $typeid.text, false);
                    if (type == null || type instanceof VarTableEntry) {
                        System.out.print("Line " + $VAR.getLine() + ": ");
                        System.out.println("Type " + $typeid.text + " was never defined.");
                        errorExists = true;
                    } else {
                        String idListRaw = $idlist.text.replaceAll("\\s", "");;
                        String[] idList = idListRaw.split(",");
                        try {
                            switch(((TypeTableEntry)type).getTrueType()) {
                                case TIGER_INT:
                                for (String var : idList) {
                                SymbolTableEntry temp = new VarTableEntry(current_scope, var, type, ((TypeTableEntry)type).getTrueType(), null);
                                symbolTable.put(temp);
                                }
                                break;

                                case TIGER_FIXEDPT:
                                for (String var : idList) {
                                SymbolTableEntry temp = new VarTableEntry(current_scope, var, type, ((TypeTableEntry)type).getTrueType(), null);
                                symbolTable.put(temp);
                                }
                                break;

                                case TIGER_INT_ARR:
                                for (String var : idList) {
                                Integer[] temp = (Integer[]) create1DArray("int", 
                                                                ((TypeTableEntry)type).getLength(),
                                                                "0");

                                        symbolTable.put(new VarTableEntry(current_scope,
                                                                    var,
                                                                    type,
                                                                    ((TypeTableEntry)type).getTrueType(),
                                                                    temp));

                                    }
                                    break;

                                    case TIGER_FIXEDPT_ARR:
                                    for (String var : idList) {
                                        Double[] temp = (Double[]) create1DArray("fixedpt", 
                                                                    ((TypeTableEntry)type).getLength(),
                                                                    "0");

                                        symbolTable.put(new VarTableEntry(current_scope,
                                                                    var,
                                                                    type,
                                                                    ((TypeTableEntry)type).getTrueType(),
                                                                    temp));
                                    }
                                    break;

                                    case TIGER_INT_2D_ARR:
                                    for (String var : idList) {
                                        Integer[][] temp = (Integer[][]) create2DArray("int",
                                                                    ((TypeTableEntry)type).getLength(),
                                                                    ((TypeTableEntry)type).getHeight(),
                                                                    "0");
                                        symbolTable.put(new VarTableEntry(current_scope,
                                                                    var,
                                                                    type,
                                                                    ((TypeTableEntry)type).getTrueType(),
                                                                    temp));

                                    }
                                    break;

                                    case TIGER_FIXEDPT_2D_ARR:
                                    for (String var : idList) {
                                        Double[][] temp = (Double[][]) create2DArray("fixedpt",
                                                                    ((TypeTableEntry)type).getLength(),
                                                                    ((TypeTableEntry)type).getHeight(),
                                                                    "0");
                                        symbolTable.put(new VarTableEntry(current_scope,
                                                                    var,
                                                                    type,
                                                                    ((TypeTableEntry)type).getTrueType(),
                                                                    temp));
                                    }
                                    break;


                                    default:
                                    break;
                                }
                            } catch (NameSpaceException nse) {
                                System.out.print("Line " + $VAR.getLine() + ": ");
                                System.out.println(nse.getMessage());
                                errorExists = true;
                            }
                        }
                } -> ^(VARDECL idlist typeid);

// idlist and and optprefix
idlist          : ID (COMMA ID)*
                -> ^(IDLIST ID+);

// Statseq and Stat and optprefix

/*  ID initial situations:
    It either is an assign expression, or it's a function call.

    (*) When it's an assign expression, it must be followed by
        a valuetail, an ASSIGN, and an expression 
        (which could be a function call).

    (*) When it's a function call, it is just followed by
        a function tail.

 */
idstatrule      : (value ASSIGN)
                => value ASSIGN expr SEMI
                -> ^(ASSIGN value expr)
                | (ID funccalltail) 
                => ID funccalltail SEMI
                -> ^(FUNCCALL ID funccalltail);

funccalltail    : LPAREN! f_exprlist RPAREN!;

statseq         : (stat)+
                -> ^(STATS stat+);
ifthen          : IF expr THEN statseq (ELSE statseq)? ENDIF SEMI
                -> ^(IF expr ^(THEN statseq) ^(ELSE statseq)?);
whileloop       : WHILE expr DO statseq ENDDO SEMI
                -> ^(WHILE expr statseq);
forloop         : FOR ID ASSIGN indexexpr TO indexexpr DO statseq ENDDO SEMI
                -> ^(FOR ID ASSIGN indexexpr indexexpr statseq);
returnstatrule  : RETURN^ expr SEMI!;
breakstatrule   : BREAK^ SEMI!;
stat            : idstatrule | ifthen | whileloop | forloop | returnstatrule | breakstatrule | block;

// Expressions

expr            : logicexpr (logicop^ logicexpr)*;
logicexpr       : compareexpr (compareop^ compareexpr)*;
compareexpr     : addsubexpr (addsubop^ addsubexpr)*;
addsubexpr      : exprlit (multdivop^ exprlit)*;
exprlit         : tiger_const 
                | ID^ (valuetail | funccalltail)
                | LPAREN! expr RPAREN!;

// Expressions for the purpose of not allowing nested function calls

f_expr            : f_logicexpr (logicop^ f_logicexpr)*;
f_logicexpr       : f_compareexpr (compareop^ f_compareexpr)*;
f_compareexpr     : f_addsubexpr (addsubop^ f_addsubexpr)*;
f_addsubexpr      : f_exprlit (multdivop^ f_exprlit)*;
f_exprlit         : tiger_const | value | LPAREN! f_expr RPAREN!;

// Constant/Value
tiger_const returns [PrimitiveType type]
        : INTLIT {
            $type = PrimitiveType.TIGER_INT;
        }
        | FIXEDPTLIT {
            $type = PrimitiveType.TIGER_FIXEDPT;
        };
value           : ID valuetail
                -> ^(VALUE ID valuetail);
valuetail       : (LBRACK indexexpr RBRACK (LBRACK indexexpr RBRACK)?)?
                -> ^(VALUETAIL (indexexpr (indexexpr)?)?);

// Expression list
exprlist        : (expr (COMMA! expr)*)?;
f_exprlist      : (f_expr (COMMA f_expr)*)?
                -> ^(F_EXPRLIST (f_expr+)?);

// Index expression
indexexpr       : indexmultexpr (addsubop^ indexmultexpr)*;
indexmultexpr   : indexlit (multdivop^ indexlit)*; 
indexlit        : INTLIT | ID | FIXEDPTLIT | LPAREN! indexexpr RPAREN!;

// Binary Operators
multdivop       : MULT | DIV;
addsubop        : PLUS | MINUS;
compareop       : EQ | NEQ | LESSER | LESSEREQ | GREATER | GREATEREQ;
logicop         : AND | OR;
