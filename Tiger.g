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
    ARGUMENTLIST;
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
    import java.util.Stack;
}

@parser::members {

    private Scope global_scope = new Scope(null, "global");
    private Scope current_scope = global_scope;
    private SymbolTable symbolTable = new SymbolTable(global_scope);
    private String current_function;
    private boolean errorExists = false;
    private static final String DEFAULT_FILENAME = "ir.tigir";
    private IRGenerator generator = new IRGenerator();
    private String startLabel;
    private String thenLabel;
    private String elseLabel;
    private String endLabel;
    private String doneLabel;
    private Stack<String> labelStack = new Stack<String>();
    private List<String> orLabelList = new ArrayList<String>();
    //private Stack<String> condLabelStack = new Stack<String>();
    //private Stack<String> endLabelStack = new Stack<String>();

    private boolean funcAssign;
    private boolean arrAssign;
    private String tempValue;

    public SemanticObject evaluateType(SemanticObject a1, SemanticObject a2, String binaryOp, int lineNumber) {
        if (a1 == null && a2 == null) {
            return null;
        } else {
            boolean isConst;
            String name = a1.getName() + " " + binaryOp + " " + a2.getName();
            SymbolTableEntry type;
            if (a1.getIsConstant() && a2.getIsConstant()) {
                isConst = true;
                if (!a1.getType().equals(a2.getType())) {
                    type = symbolTable.getTigerFixedpt();
                    return new SemanticObject(isConst, type, name);
                } else {
                    type = a1.getType();
                    return new SemanticObject(isConst, type, name);
                }
            } else {
                isConst = false;
                if (!a1.getType().equals(a2.getType())) {
                    if ((a1.getType().equals(symbolTable.getTigerInt()) && a2.getType().equals(symbolTable.getTigerFixedpt()))
                        || (a2.getType().equals(symbolTable.getTigerInt()) && a1.getType().equals(symbolTable.getTigerFixedpt()))) {
                        return new SemanticObject(isConst, symbolTable.getTigerFixedpt(), name);
                    } else {
                        errorExists = true;
                        System.out.print("Line " + lineNumber + ": ");
                        System.out.println("Type conflict between " + a1.getName() + " and " + a2.getName());
                        return null;
                    }
                } else {
                    type = a1.getType();
                    return new SemanticObject(isConst, type, name);
                }
            }
        }
    }

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
        if (!errorExists) {
            generator.writeToFile(DEFAULT_FILENAME);
        }
    }
    -> ^(PROG typedecllist functdecllist mainfunction);

// typedecllist stuff
typedecllist    : typedecl*
                -> ^(TYPEDECLLIST typedecl*);
typedecl        : TYPE ID EQ type[$ID.text] SEMI
                -> ^(EQ ID type);

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
                } -> ^(TYPE TWODEE INTLIT INTLIT basetype)
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
                }
                | FIXEDPT {
                    $lineNumber = $FIXEDPT.getLine();
                }
                ;

//Function declaration list stuff
functdecllist   : (functdecl)*
                -> ^(FUNCTDECLLIST functdecl*)
                ;
//TODO
functdecl       : VOID_FUNCTION ID {
                    current_scope = new Scope(current_scope, $ID.text);
                    current_function = $ID.text;
                    generator.addFunctionDeclaration($ID.text);
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
                    current_function = $ID.text;
                    generator.addFunctionDeclaration($ID.text);
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
                | ID
                ;

// Paramater list stuff
//TODO
paramlist[List<TypeTableEntry> inParams] returns [List<TypeTableEntry> outParams]
                : (a1=param[inParams] { 
                    $outParams = $a1.outParams;
                } (COMMA a2=param[inParams])*)? -> ^(PARAMLIST param*);

//TODO
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
//TODO
mainfunction    : VOID_MAIN {
                    try {
                        SymbolTableEntry mainFunc = new FunctionTableEntry(current_scope, "main", null, new ArrayList<TypeTableEntry>());
                        symbolTable.put(mainFunc);
                    } catch (NameSpaceException nse) {
                        System.out.print("Line" + $VOID_MAIN.getLine() + ": ");
                        System.out.println(nse.getMessage());
                    }
                    //IR Generation
                    generator.addFunctionDeclaration("main");
                } LPAREN RPAREN BEGIN {
                    current_scope = new Scope(current_scope, "main");
                    current_function = "main";
                } blocklist END {
                    current_scope = current_scope.getParent();
                } SEMI {
                }
                -> ^(MAIN blocklist);

// Block list
//TODO
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
//TODO
vardecl         : (VAR idlist COLON typeid ASSIGN)
                => VAR idlist COLON typeid ASSIGN tiger_const SEMI
                {
                    SymbolTableEntry type = symbolTable.get(current_scope, $typeid.text, false);
                    if (type == null || type instanceof VarTableEntry) {
                        System.out.print("Line " + $VAR.getLine() + ": ");
                        System.out.println("Type " + $typeid.text + " was never defined.");
                        errorExists = true;
                    } else {
                        if (((TypeTableEntry)$tiger_const.typeChecker.getType()).getTrueType() == PrimitiveType.TIGER_FIXEDPT
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
                    // IR Generation
                    if (!errorExists) {
                        if (((TypeTableEntry)type).getTrueType() == PrimitiveType.TIGER_FIXEDPT
                                || ((TypeTableEntry)type).getTrueType() == PrimitiveType.TIGER_INT)
                        {
                            String idListRaw = $idlist.text.replaceAll("\\s", "");;
                            String[] idList = idListRaw.split(",");
                            for (String var : idList) {
                                generator.addAssignment(var, $tiger_const.text);
                            }
                        } else {
                            String idListRaw = $idlist.text.replaceAll("\\s", "");;
                            String[] idList = idListRaw.split(",");
                            int arraySize = 0;
                            if (((TypeTableEntry)type).getTrueType() == PrimitiveType.TIGER_FIXEDPT_ARR
                                || ((TypeTableEntry)type).getTrueType() == PrimitiveType.TIGER_INT_ARR) {
                                arraySize = ((TypeTableEntry)type).getLength();
                            } else {
                                arraySize = ((TypeTableEntry)type).getLength() 
                                            * ((TypeTableEntry)type).getHeight();
                            }
                            for (String var : idList) {
                                generator.addAssignment(var, arraySize, $tiger_const.text);
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
 
//TODO
assignrule      : (value ASSIGN funccall) 

                => value ASSIGN {
                    funcAssign = true;
                    tempValue = $value.temp;
                } funccall SEMI {
                    SymbolTableEntry variable = symbolTable.get(current_scope, $value.text, false);
                    if (variable == null || variable instanceof TypeTableEntry) {
                        errorExists = true;
                        System.out.print("Line " + $ASSIGN.getLine() + ": ");
                        System.out.println($value.name + " is not a declared variable in this scope.");
                    } else {
                        SymbolTableEntry function = symbolTable.get(global_scope, $funccall.name, true);
                        if (function == null) {
                            errorExists = true;
                            System.out.print("Line " + $ASSIGN.getLine() + ": ");
                            System.out.println($value.name + " is not a defined function.");
                        } else {
                            if (!((VarTableEntry)variable).getType().equals(((FunctionTableEntry)function).getReturnType()) && !(((VarTableEntry)variable).getType().equals(symbolTable.getTigerFixedpt()) && ((FunctionTableEntry)function).getReturnType().equals(symbolTable.getTigerInt()))) {
                                errorExists = true;
                                System.out.print("Line " + $ASSIGN.getLine() + ": ");
                                System.out.println("Conflicting types between assignment and function call.");
                            }
                        }
                    }
                    // IR Generation

                }
                -> ^(ASSIGN value funccall)
                | (value ASSIGN expr)
                => value ASSIGN {
                    arrAssign = true;
                } expr SEMI {
                    arrAssign = false;
                    SymbolTableEntry variable = symbolTable.get(current_scope, $value.name, false);
                    if (variable == null || variable instanceof TypeTableEntry) {
                        errorExists = true;
                        System.out.print("Line " + $ASSIGN.getLine() + ": ");
                        System.out.println($value.name + " is not a declared variable in this scope.");
                    } else {
                        if ($expr.isBool) {
                            errorExists = true;
                            System.out.print("Line " + $ASSIGN.getLine() + ": ");
                            System.out.println("Cannot assign a boolean to a variable.");
                        } else {
                            SemanticObject assignExpr = $expr.typeChecker;
                            SemanticObject valueExpr = $value.typeChecker;
                            if (assignExpr == null || valueExpr == null || (!(assignExpr.getType().equals(valueExpr.getType())))
                                && !(assignExpr.getType().equals(symbolTable.getTigerInt()) && valueExpr.getType().equals(symbolTable.getTigerFixedpt()))) {
                                errorExists = true;
                                System.out.print("Line " + $ASSIGN.getLine() + ": ");
                                System.out.println("The variable " + $value.text + " cannot be assigned to the expression " + $expr.text + ".");
                            }
                        }
                    }
                    //IR Generation
                    if (!errorExists) {
                        if ($value.arr) {
                            generator.addArrayStore($value.name, $value.index, $expr.temp);
                        } else {
                            generator.addAssignment($value.temp, $expr.temp);
                        }
                    }
                }
                -> ^(ASSIGN value expr);

//TODO
funccall returns [String name]
                : ID LPAREN argumentlist[new ArrayList<SemanticObject>(), new ArrayList<String>()] RPAREN {
                    SymbolTableEntry function = symbolTable.get(global_scope, $ID.text, true);
                    if (function == null) {
                        errorExists = true;
                        System.out.print("Line " + $ID.getLine() + ": ");
                        System.out.println("Function does not exist.");
                    } else {
                        List<TypeTableEntry> originalParamList = ((FunctionTableEntry)function).getParameterList();
                        List<SemanticObject> givenParamList = $argumentlist.argTypes;
                        if (originalParamList != null && givenParamList != null) {
                            if (originalParamList.size() != givenParamList.size()) {
                                errorExists = true;
                                System.out.print("Line " + $ID.getLine() + ": ");
                                System.out.println("Not enough parameters given.");
                            } else {
                                for (int i = 0; i < originalParamList.size(); i++) {
                                    if (!originalParamList.get(i).equals((TypeTableEntry)(givenParamList.get(i).getType())) && !(originalParamList.get(i).equals(symbolTable.getTigerFixedpt()) && ((TypeTableEntry)(givenParamList.get(i).getType())).equals(symbolTable.getTigerInt()))) {
                                        errorExists = true;
                                        System.out.print("Line " + $ID.getLine() + ": ");
                                        System.out.println("Parameter " + (i+1) + " is the incorrect type.");
                                    }
                                }
                            }
                        }
                    }
                    $name = $ID.text;
                    // IR Generation
                    if (!errorExists) {
                        if (funcAssign) {
                            generator.addCallr(tempValue, $name, $argumentlist.paramList.toArray(new String[$argumentlist.paramList.size()]));
                        } else {
                            generator.addCall($name, $argumentlist.paramList.toArray(new String[$argumentlist.paramList.size()]));
                        }
                    }
                }
                -> ^(FUNCCALL ID argumentlist);

//TODO
argumentlist[List<SemanticObject> args, List<String> params] returns [List<SemanticObject> argTypes, List<String> paramList]
                : (a1=argument[args, params] {
                    $argTypes = $args;
                    $paramList = $params;
                } (COMMA argument[args, params])*)?
                -> ^(ARGUMENTLIST (argument+)?);

//TODO
argument[List<SemanticObject> args, List<String> params] returns [List<SemanticObject> argTypes, List<String> paramList]
                : expr {
                    if (!$expr.isBool) {
                        args.add($expr.typeChecker);
                        params.add($expr.temp);
                        $argTypes = args;
                        $paramList = params;
                    }
                };

statseq         : (stat)+
                -> ^(STATS stat+);

//TODO
ifthen          : (IF expr THEN statseq ELSE) 
                => IF {
                    if (!errorExists) {
                        labelStack.push(thenLabel);
                        labelStack.push(endLabel);
                        thenLabel = generator.generateLabel();
                        elseLabel = generator.generateLabel();
                        endLabel = generator.generateLabel();
                    }
                } expr {
                    if ($expr.isBool == false) {
                        errorExists = true;
                        System.out.print("Line " + $IF.getLine() + ": ");
                        System.out.println("Conditional is not a boolean.");
                    }
                    if (!errorExists) {
                        generator.addGoto(elseLabel);
                        for (String label : orLabelList) {
                            generator.addLabel(label);
                        }
                        orLabelList = new ArrayList<String>();
                        generator.addLabel(thenLabel);
                    }
                } THEN statseq ELSE {
                    if (!errorExists) {
                        generator.addGoto(endLabel);
                        generator.addLabel(elseLabel);
                    }
                } statseq {
                    if (!errorExists) {
                        generator.addLabel(endLabel);
                        endLabel = labelStack.pop();
                        thenLabel = labelStack.pop();
                    }
                } ENDIF SEMI
                -> ^(IF expr statseq ^(ELSE statseq)?)
                | IF {
                    if (!errorExists) {
                        labelStack.push(thenLabel);
                        labelStack.push(endLabel);
                        thenLabel = generator.generateLabel();
                        endLabel = generator.generateLabel();
                    }
                } expr {
                    if ($expr.isBool == false) {
                        errorExists = true;
                        System.out.print("Line " + $IF.getLine() + ": ");
                        System.out.println("Conditional is not a boolean.");
                    }
                    if (!errorExists) {
                        generator.addGoto(endLabel);
                        generator.addLabel(thenLabel);
                    }
                } THEN statseq ENDIF SEMI {
                    if (!errorExists) {
                        generator.addLabel(endLabel);
                        endLabel = labelStack.pop();
                        thenLabel = labelStack.pop();
                    }
                }
                -> ^(IF expr statseq);

//TODO
whileloop       : WHILE  {
                    if (!errorExists) {
                        labelStack.push(thenLabel);
                        labelStack.push(doneLabel);
                        labelStack.push(startLabel);
                        thenLabel = generator.generateLabel();
                        doneLabel = generator.generateLabel();
                        startLabel = generator.generateLabel();
                        generator.addLabel(startLabel);
                    }
                } expr {
                    if ($expr.isBool == false) {
                        errorExists = true;
                        System.out.print("Line " + $WHILE.getLine() + ": ");
                        System.out.println("Conditional is not a boolean.");
                    }
                    if (!errorExists) {
                        generator.addGoto(doneLabel);
                        generator.addLabel(thenLabel);
                    }
                } DO statseq {
                    if (!errorExists) {
                        generator.addGoto(startLabel);
                        generator.addLabel(doneLabel);
                        startLabel = labelStack.pop();
                        doneLabel = labelStack.pop();
                        thenLabel = labelStack.pop();
                    }
                } ENDDO SEMI
                -> ^(WHILE expr statseq);
//TODO
forloop         : FOR ID ASSIGN a1=indexexpr {
                    if (!errorExists) {
                        generator.addAssignment($ID.text, $a1.temp);
                        labelStack.push(thenLabel);
                        labelStack.push(doneLabel);
                        thenLabel = generator.generateLabel();
                        doneLabel = generator.generateLabel();
                    }
                } TO a2=indexexpr {
                    if (!errorExists) {
                        generator.addLabel(thenLabel);
                        generator.addBREQ($ID.text, $a2.temp, doneLabel);
                    }
                } DO statseq ENDDO SEMI {
                    if (!errorExists) {
                        generator.addAddition($ID.text, ""+1, $ID.text);
                        generator.addGoto(thenLabel);
                        generator.addLabel(doneLabel);
                        doneLabel = labelStack.pop();
                        thenLabel = labelStack.pop();
                    }
                }
                -> ^(FOR ID ASSIGN indexexpr indexexpr statseq);
//TODO
returnstatrule  : RETURN^ expr {
                    SymbolTableEntry function = symbolTable.get(global_scope, current_function, true);
                    if (!(((FunctionTableEntry)function).getReturnType().equals($expr.typeChecker.getType())) && !(((FunctionTableEntry)function).getReturnType().equals(symbolTable.getTigerFixedpt()) && ($expr.typeChecker.getType().equals(symbolTable.getTigerInt())))) {
                        errorExists = true;
                        System.out.print("Line " + $RETURN.getLine() + ": ");
                        System.out.println("Returned type and function return type are incompatible.");
                    }
                    // IR Generation
                    if (!errorExists) {
                        generator.addReturn($expr.temp);
                    }
                } SEMI!;
breakstatrule   : BREAK^ {
                    if (!errorExists) {
                        generator.addGoto(doneLabel);
                    }
                } SEMI!;
stat            : (value ASSIGN) => assignrule 
                | {funcAssign = false;} funccall SEMI!
                | ifthen 
                | whileloop 
                | forloop 
                | returnstatrule 
                | breakstatrule 
                | block;

// Expressions


// expressions can either be numerical or boolean
// Handle boolean before numerical
// Match tiger_consts, then values, then (expr) bin (expr)

//TODO
expr returns [SemanticObject typeChecker, boolean isBool, String temp]
        : (logicexpr) => logicexpr {
            $typeChecker = $logicexpr.typeChecker;
            $isBool = $logicexpr.isBool;
            if (!errorExists) {
                $temp = $logicexpr.temp;
            }
        }
        | (compareexpr) => compareexpr {
            $typeChecker = $compareexpr.typeChecker;
            $isBool = $compareexpr.isBool;
            if (!errorExists) {
                $temp = $compareexpr.temp;
            }
        }
        | (addsubexpr) => addsubexpr {
            $typeChecker = $addsubexpr.typeChecker;
            $isBool = $addsubexpr.isBool;
            if (!errorExists) {
                $temp = $addsubexpr.temp;
            }
        }
        | (multdivexpr) => multdivexpr {
            $typeChecker = $multdivexpr.typeChecker;
            $isBool = $multdivexpr.isBool;
            if (!errorExists) {
                $temp = $multdivexpr.temp;
            }
        }
        | LPAREN! a1=expr RPAREN! {
            $typeChecker = $a1.typeChecker;
            $isBool = $a1.isBool;
            if (!errorExists) {
                $temp = $a1.temp;
            }
        };

//TODO
logicexpr returns [SemanticObject typeChecker, boolean isBool, String temp]
        : (LPAREN expr RPAREN logicop) => LPAREN {
            if (!errorExists) {
                labelStack.push(thenLabel);
                thenLabel = generator.generateLabel();
            }
        } a1=expr RPAREN logicop {
            if (!errorExists) {
                if ($logicop.op == Operator.AND) {
                    generator.addGoto(elseLabel);
                    generator.addLabel(thenLabel);
                    thenLabel = labelStack.pop();
                } else {
                    orLabelList.add(thenLabel);
                    thenLabel = labelStack.pop();
                }
            }
        } a2=expr {
            if (!errorExists) {
                $typeChecker = evaluateType($a1.typeChecker, $a2.typeChecker, $logicop.text, $logicexpr.start.getLine());
                $isBool = true;
            }
        } -> ^(logicop expr expr);

//TODO
compareexpr returns [SemanticObject typeChecker, boolean isBool, String temp]
        : (tiger_const compareop) => tiger_const compareop expr {
            $typeChecker = evaluateType($tiger_const.typeChecker, $expr.typeChecker, $compareop.text, $compareexpr.start.getLine());
            $isBool = true;
            // IR Generation
            if (!errorExists) {
                switch ($compareop.op) {
                    case EQ:
                    generator.addBREQ($tiger_const.text, $expr.temp, thenLabel);
                    break;

                    case NEQ:
                    generator.addBRNEQ($tiger_const.text, $expr.temp, thenLabel);
                    break;

                    case LT:
                    generator.addBRLT($tiger_const.text, $expr.temp, thenLabel);
                    break;

                    case LTE:
                    generator.addBRLEQ($tiger_const.text, $expr.temp, thenLabel);
                    break;

                    case GT:
                    generator.addBRGT($tiger_const.text, $expr.temp, thenLabel);
                    break;

                    case GTE:
                    generator.addBRGEQ($tiger_const.text, $expr.temp, thenLabel);
                    break;

                    default:
                    break;

                }
            }
        } -> ^(compareop tiger_const expr)
        | (value compareop) => value compareop expr {
            $typeChecker = evaluateType($value.typeChecker, $expr.typeChecker, $compareop.text, $compareexpr.start.getLine());
            $isBool = true;
            // IR Generation 
            if (!errorExists) {
                switch ($compareop.op) {
                    case EQ:
                    generator.addBREQ($value.temp, $expr.temp, thenLabel);
                    break;

                    case NEQ:
                    generator.addBRNEQ($value.temp, $expr.temp, thenLabel);
                    break;

                    case LT:
                    generator.addBRLT($value.temp, $expr.temp, thenLabel);
                    break;

                    case LTE:
                    generator.addBRLEQ($value.temp, $expr.temp, thenLabel);
                    break;

                    case GT:
                    generator.addBRGT($value.temp, $expr.temp, thenLabel);
                    break;

                    case GTE:
                    generator.addBRGEQ($value.temp, $expr.temp, thenLabel);
                    break;

                    default:
                    break;

                }       
            }
        } -> ^(compareop value expr)
        | (LPAREN expr RPAREN logicop) => LPAREN a1=expr RPAREN compareop a2=expr {
            $typeChecker = evaluateType($a1.typeChecker, $a2.typeChecker, $compareop.text, $compareexpr.start.getLine());
            $isBool = true;
            // IR Generation
            if (!errorExists) {
                switch ($compareop.op) {
                    case EQ:
                    generator.addBREQ($a1.temp, $a2.temp, thenLabel);
                    break;

                    case NEQ:
                    generator.addBRNEQ($a1.temp, $a2.temp, thenLabel);
                    break;

                    case LT:
                    generator.addBRLT($a1.temp, $a2.temp, thenLabel);
                    break;

                    case LTE:
                    generator.addBRLEQ($a1.temp, $a2.temp, thenLabel);
                    break;

                    case GT:
                    generator.addBRGT($a1.temp, $a2.temp, thenLabel);
                    break;

                    case GTE:
                    generator.addBRGEQ($a1.temp, $a2.temp, thenLabel);
                    break;

                    default:
                    break;

                }       
            }
        } -> ^(compareop expr expr);

//TODO
addsubexpr returns [SemanticObject typeChecker, boolean isBool, String temp]
        : (tiger_const addsubop) => tiger_const addsubop expr {
            $typeChecker = evaluateType($tiger_const.typeChecker, $expr.typeChecker, $addsubexpr.text, $addsubexpr.start.getLine());
            $isBool = false;
            // IR Generation
            if (!errorExists) {
                $temp = generator.generateTemp();
                switch($addsubop.op) {
                    case PLUS:
                    generator.addAddition($tiger_const.text, $expr.temp, $temp);
                    break;

                    case MINUS:
                    generator.addSubtraction($tiger_const.text, $expr.temp, $temp);
                    break;

                    default:
                    break;
                }
            }
        } -> ^(addsubop tiger_const expr)
        | (value addsubop) => value addsubop expr {
            $typeChecker = evaluateType($value.typeChecker, $expr.typeChecker, $addsubexpr.text, $addsubexpr.start.getLine());
            $isBool = false;
            // IR Generation
            if (!errorExists) {
                $temp = generator.generateTemp();
                switch ($addsubop.op) {
                    case PLUS:
                    generator.addAddition($value.temp, $expr.temp, $temp);
                    break;

                    case MINUS:
                    generator.addSubtraction($value.temp, $expr.temp, $temp);
                    break;

                    default:
                    break;
                }
            }
        } -> ^(addsubop value expr)
        | (LPAREN expr RPAREN addsubop) => LPAREN a1=expr RPAREN addsubop a2=expr {
            $typeChecker = evaluateType($a1.typeChecker, $a2.typeChecker, $addsubexpr.text, $addsubexpr.start.getLine());
            $isBool = false;
            // IR Generation
            if (!errorExists) {
                $temp = generator.generateTemp();
                switch ($addsubop.op) {
                    case PLUS:
                    generator.addAddition($a1.temp, $a2.temp, $temp);
                    break;

                    case MINUS:
                    generator.addSubtraction($a1.temp, $a2.temp, $temp);
                    break;

                    default:
                    break;
                }
            }
        } -> ^(addsubop expr expr);

//TODO
multdivexpr returns [SemanticObject typeChecker, boolean isBool, String temp]
        : (tiger_const multdivop) => tiger_const multdivop expr {
            $typeChecker = evaluateType($tiger_const.typeChecker, $expr.typeChecker, $multdivop.text, $multdivop.start.getLine());
            $isBool = false;
            // IR Generation
            if (!errorExists) {
                $temp = generator.generateTemp();
                switch($multdivop.op) {
                    case MULT:
                    generator.addMultiplication($tiger_const.text, $expr.temp, $temp);
                    break;

                    case DIV:
                    generator.addDivision($tiger_const.text, $expr.temp, $temp);
                    break;

                    default:
                    break;
                }
            }
        } -> ^(multdivop tiger_const expr)
        | tiger_const {
            $typeChecker = $tiger_const.typeChecker;
            $isBool = false;
            // IR Generation
            if (!errorExists) {
                $temp = $tiger_const.text;
            }
        }
        | (value multdivop) => value multdivop expr {
            $typeChecker = evaluateType($value.typeChecker, $expr.typeChecker, $multdivop.text, $multdivop.start.getLine());
            $isBool = false;
            // IR Generation
            if (!errorExists) {
                $temp = generator.generateTemp();
                switch ($multdivop.op) {
                    case MULT:
                    generator.addMultiplication($value.temp, $expr.temp, $temp);
                    break;

                    case DIV:
                    generator.addDivision($value.temp, $expr.temp, $temp);
                    break;
                    
                    default:
                    break;
                }
            }
        } -> ^(multdivop value expr)
        | value {
            $typeChecker = $value.typeChecker;
            $isBool = false;
            // IR Generation
            if (!errorExists) {
                $temp = $value.temp;
            }
        }
        | (LPAREN expr RPAREN multdivop) => LPAREN a1=expr RPAREN multdivop a2=expr {
            $typeChecker = evaluateType($a1.typeChecker, $a2.typeChecker, $multdivop.text, $multdivop.start.getLine());
            $isBool = false;
            // IR Generation
            if (!errorExists) {
                $temp = generator.generateTemp();
                switch($multdivop.op) {
                    case MULT:
                    generator.addMultiplication($a1.temp, $a2.temp, $temp);
                    break;

                    case DIV:
                    generator.addDivision($a1.temp, $a2.temp, $temp);
                    break;

                    default:
                    break;
                }
            }
        } -> ^(multdivop expr expr);

// Constant/Value
//TODO
tiger_const returns [SemanticObject typeChecker, boolean isBool]
        : INTLIT {
            $typeChecker = new SemanticObject(true, symbolTable.getTigerInt(), $INTLIT.text);
            $isBool = false; 
        }
        | FIXEDPTLIT {
            $typeChecker = new SemanticObject(true, symbolTable.getTigerFixedpt(), $FIXEDPTLIT.text);
            $isBool = false;
        };


//TODO
value returns [String name, SemanticObject typeChecker, boolean isBool, String temp, boolean arr, String index]
                : (ID LBRACK indexexpr RBRACK LBRACK)
                => ID LBRACK a1=indexexpr RBRACK LBRACK a2=indexexpr RBRACK {
                    SymbolTableEntry variable = symbolTable.get(current_scope, $ID.text, false);
                    if (variable == null || variable instanceof TypeTableEntry) {
                        errorExists = true;
                        System.out.print("Line " + $ID.getLine() + ": ");
                        System.out.println($ID.text + " was either never declared or is declared as a type in the current scope.");
                        $typeChecker = null;
                    } else if (((VarTableEntry)variable).getTrueType() == PrimitiveType.TIGER_INT_2D_ARR) {
                        $typeChecker = new SemanticObject(false, symbolTable.getTigerInt(), $value.text);
                    } else if ((((VarTableEntry)variable).getTrueType() == PrimitiveType.TIGER_FIXEDPT_2D_ARR)) {
                        $typeChecker = new SemanticObject(false, symbolTable.getTigerFixedpt(), $value.text);
                    } else {
                        errorExists = true;
                        System.out.print("Line " + $ID.getLine() + ": ");
                        System.out.println($ID.text + " is not a two-dimensional array.");
                        $typeChecker = null;
                    }
                    $isBool = false;
                    $name = $ID.text;
                    //IR Generation
                    if (!errorExists) {
                        $temp = generator.generateTemp();
                        $arr = true;
                        String temp1 = generator.generateTemp();
                        String temp2 = generator.generateTemp();
                        generator.addMultiplication($a1.temp, "" + ((VarTableEntry)variable).getType().getLength(), temp1);
                        generator.addAddition(temp1, $a2.temp, temp2);
                        $index = temp2;
                        if (arrAssign) {
                            generator.addArrayLoad($temp, $ID.text, temp2);
                        }
                    }
                } -> ^(VALUE ID indexexpr indexexpr)
                | (ID LBRACK)
                => ID LBRACK indexexpr RBRACK {
                    SymbolTableEntry variable = symbolTable.get(current_scope, $ID.text, false);
                    if (variable == null || variable instanceof TypeTableEntry) {
                        errorExists = true;
                        System.out.print("Line " + $ID.getLine() + ": ");
                        System.out.println($ID.text + " was either never declared or is declared as a type in the current scope.");
                        $typeChecker = null;
                    } else if (((VarTableEntry)variable).getTrueType() == PrimitiveType.TIGER_INT_ARR) { 
                        $typeChecker = new SemanticObject(false, symbolTable.getTigerInt(), $value.text);
                    } else if (((VarTableEntry)variable).getTrueType() == PrimitiveType.TIGER_FIXEDPT_ARR) { 
                        $typeChecker = new SemanticObject(false, symbolTable.getTigerFixedpt(), $value.text);
                    } else {
                        errorExists = true;
                        System.out.print("Line " + $ID.getLine() + ": ");
                        System.out.println($ID.text + " is not a one-dimensional array.");
                        $typeChecker = null;
                    }
                    $isBool = false;
                    $name = $ID.text;
                    //IR Generator
                    if (!errorExists) {
                        $temp = generator.generateTemp();
                        $arr = true;
                        $index = $indexexpr.temp;
                        if (arrAssign) {
                            generator.addArrayLoad($temp, $ID.text, $index);
                        }
                    }
                } -> ^(VALUE ID indexexpr)
                | ID {
                    SymbolTableEntry variable = symbolTable.get(current_scope, $ID.text, false);
                    if (variable == null || variable instanceof TypeTableEntry) {
                        errorExists = true;
                        System.out.print("Line " + $ID.getLine() + ": ");
                        System.out.println($ID.text + " was either never declared or is declared as a type in the current scope.");
                        $typeChecker = null;
                    } else {
                        SymbolTableEntry type = ((VarTableEntry)variable).getType();
                        $typeChecker = new SemanticObject(false, type, $ID.text); 
                    }
                    $isBool = false;
                    $name = $ID.text;
                    // IR Generator
                    if (!errorExists) {
                        $temp = $ID.text;
                    }
                } -> ^(VALUE ID);

// Expression list
exprlist        : (expr (COMMA! expr)*)?;

// Index expression
indexexpr returns [String temp]
                : (indexaddexpr) => indexaddexpr {
                    if (!errorExists) {
                        $temp = $indexaddexpr.temp;
                    }
                }
                | (indexmultexpr) => indexmultexpr {
                    if (!errorExists) {
                        $temp = $indexmultexpr.temp;
                    }
                }
                | LPAREN! a1=indexexpr RPAREN! {
                    if (!errorExists) {
                        $temp = $a1.temp;
                    }
                };

indexaddexpr returns [String temp]
                : (tiger_const addsubop) => tiger_const addsubop indexexpr {
                    if (!errorExists) {
                        $temp = generator.generateTemp();
                        switch($addsubop.op) {
                            case PLUS:
                            generator.addAddition($tiger_const.text, $indexexpr.temp, $temp);
                            break;

                            case MINUS:
                            generator.addSubtraction($tiger_const.text, $indexexpr.temp, $temp);
                            break;

                            default:
                            break;
                        }
                    }
                } -> ^(addsubop tiger_const indexexpr)
                | (value addsubop) => value addsubop indexexpr {
                    if (!errorExists) {
                        $temp = generator.generateTemp();
                        switch($addsubop.op) {
                            case PLUS:
                            generator.addAddition($value.temp, $indexexpr.temp, $temp);
                            break;

                            case MINUS:
                            generator.addSubtraction($value.temp, $indexexpr.temp, $temp);
                            break;

                            default:
                            break;
                        }
                    }
                } -> ^(addsubop value indexexpr)
                | (LPAREN indexexpr RPAREN addsubop) => LPAREN a1=indexexpr RPAREN addsubop a2=indexexpr {
                    if (!errorExists) {
                        $temp = generator.generateTemp();
                        switch($addsubop.op) {
                            case PLUS:
                            generator.addAddition($a1.temp, $a2.temp, $temp);
                            break;

                            case MINUS:
                            generator.addSubtraction($a1.temp, $a2.temp, $temp);
                            break;

                            default:
                            break;
                        }
                    }
                } -> ^(addsubop indexexpr indexexpr);
                

indexmultexpr returns [String temp]
                : (tiger_const multdivop) => tiger_const multdivop indexexpr {
                    if (!errorExists) {
                        $temp = generator.generateTemp();
                        switch($multdivop.op) {
                            case MULT:
                            generator.addMultiplication($tiger_const.text, $indexexpr.temp, $temp);
                            break;

                            case DIV:
                            generator.addDivision($tiger_const.text, $indexexpr.temp, $temp);
                            break;

                            default:
                            break;
                        }
                    }
                } -> ^(multdivop tiger_const indexexpr)
                | tiger_const {
                    if (!errorExists) {
                        $temp = $tiger_const.text;
                    }
                }
                | (value multdivop) => value multdivop indexexpr {
                    if (!errorExists) {
                        $temp = generator.generateTemp();
                        switch($multdivop.op) {
                            case MULT:
                            generator.addMultiplication($value.temp, $indexexpr.temp, $temp);
                            break;

                            case DIV:
                            generator.addDivision($value.temp, $indexexpr.temp, $temp);
                            break;

                            default:
                            break;
                        }
                    }
                } -> ^(multdivop value indexexpr)
                | value {
                    if (!errorExists) {
                        $temp = $value.temp;
                    }
                }
                | (LPAREN indexexpr RPAREN multdivop) => LPAREN a1=indexexpr RPAREN multdivop a2=indexexpr {
                    if (!errorExists) {
                        $temp = generator.generateTemp();
                        switch($multdivop.op) {
                            case MULT:
                            generator.addMultiplication($a1.temp, $a2.temp, $temp);
                            break;

                            case DIV:
                            generator.addDivision($a1.temp, $a2.temp, $temp);
                            break;

                            default:
                            break;

                        }
                    }
                } -> ^(multdivop indexexpr indexexpr);

// Binary Operators
// numerical
addsubop returns [boolean isBool, Operator op]
                : (PLUS {$op = Operator.PLUS;}
                | MINUS {$op = Operator.MINUS;}
                ) {
                    $isBool = false;
                };
multdivop returns [boolean isBool, Operator op]      
                : (MULT {$op = Operator.MULT;}
                | DIV {$op = Operator.DIV;}
                ) {
                    $isBool = false;
                };
// boolean
compareop returns [boolean isBool, Operator op]
                : (EQ {$op = Operator.EQ;}
                | NEQ {$op = Operator.NEQ;}
                | LESSER {$op = Operator.LT;}
                | LESSEREQ {$op = Operator.LTE;}
                | GREATER {$op = Operator.GT;}
                | GREATEREQ {$op = Operator.GTE;}
                ) {
                    $isBool = true;
                };
logicop returns [boolean isBool, Operator op]
                : (AND {$op = Operator.AND;}
                | OR {$op = Operator.OR;}
                ) {
                    $isBool = true;
                };
