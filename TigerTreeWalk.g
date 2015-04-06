tree grammar TigerTreeWalk;

options {
    output = AST;
    backtrack = no;
    tokenVocab = Tiger;
    ASTLabelType = CommonTree; 
}

@header {
    import java.util.List;
    import java.util.LinkedList;
}

@members {
    private SymbolTable table;
    private static final String DEFAULT_FILENAME = "ir.tigir";

    private int tempVarCount = 0;

    // Add things to the generator as they come up. 
    private IRGenerator generator = new IRGenerator();


    public TigerTreeWalk(TreeNodeStream input, SymbolTable t) {
        this(input);
        table = t;
    }

    private String nextTemp() {
        return "t" + tempVarCount++;
    }
}

// The starting point for the walk function. 
walk            : ^(PROG typedecllist functdecllist mainfunction)
                {
                    // This should run at the end of the parsing
                    generator.writeToFile(DEFAULT_FILENAME);
                };

// The beginnign type declaration block 
typedecllist    : ^(TYPEDECLLIST typedecl*);

typedecl        : ^(TYPEDECL TYPE ID EQ type);

type            : basetype
                | ^(TYPE ARRAY INTLIT INTLIT basetype)
                | ^(TYPE ARRAY INTLIT basetype);

basetype        : ^(BASETYPE INT)
                | ^(BASETYPE FIXEDPT);

functdecllist   : ^(FUNCTDECLLIST functdecl*) ;

functdecl       : ^(FUNCTION VOID ID {
                      generator.addLabel(ID.text);
                  } paramlist {
                      for (String param : $param_list.params) {
                        // Initialize the function arguments
                        generator.assignVar(param, "0"));
                      }
                  } blocklist)
                | ^(FUNCTION typeid ID paramlist
                  } paramlist {
                      for (String param : $param_list.params) {
                        // Initialize the function arguments
                        generator.assignVar(param, "0"));
                      }
                  } blocklist);

typeid          : ^(TYPEID basetype)
                | ^(TYPEID ID);

paramlist returns [List<String> params] 
                @init {
                    $params = new LinkedList<String>();
                }
                : ^(PARAMLIST (param {
                    $paramList.params.add($param.name);
                })*);

params returns [String name]
                : ^(PARAM ID {
                    $params.name = $ID.text;
                  } typeid);

mainfunction    : ^(MAIN {
                    generator.addLabel($MAIN.text);
                  } blocklist);

blocklist       : ^(BLOCKLIST block+);

block           : ^(BLOCK declsegment statseq);

declsegment     : ^(DECLSEGMENT typedecllist vardecllist);

vardecllist     :  ^(VARDECLLIST vardecl*);

vardecl         :  ^(VARDECL idlist {
                        for (String name : $idList.names) {
                            generator.assignVar(name, "0");
                        }
                   } typeid);

idlist returns [List<String> names] 
                @init {
                    $names = new ArrayList<String>();
                }
                :  ^(IDLIST (ID {
                    $names.add($ID.text);
                })+);

idstatrule      : ^(ASSIGN value expr)
                | ^(FUNCCALL ID funccalltail);

funccalltail    : LPAREN! f_exprlist RPAREN!;

statseq         : ^(STATS stat+);

ifthen          : ^(IF expr ^(THEN statseq) ^(ELSE statseq)?);

whileloop       : ^(WHILE expr statseq);

forloop         : ^(FOR ID ASSIGN indexexpr indexexpr statseq);

returnstatrule  : RETURN^ expr SEMI!;
breakstatrule   : BREAK^ SEMI!;
stat            : idstatrule | ifthen | whileloop | forloop | returnstatrule 
                | breakstatrule | block;


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


tiger_const       : INTLIT 
                  | FIXEDPTLIT;

value           : ^(VALUE ID valuetail);
valuetail       : -> ^(VALUETAIL (indexexpr (indexexpr)?)?);

// Expression list
exprlist        : (expr (COMMA! expr)*)?;
f_exprlist      : ^(F_EXPRLIST (f_expr+)?);

// Index expression
indexexpr       : indexmultexpr (addsubop^ indexmultexpr)*;
indexmultexpr   : indexlit (multdivop^ indexlit)*; 
indexlit        : INTLIT | ID | FIXEDPTLIT | LPAREN! indexexpr RPAREN!;

// Binary Operators
multdivop returns [Operator type]
                : MULT {$type = Operator.MULT;} 
                | DIV {$type = Operator.DIV;};
addsubop returns [Operator type]
                : PLUS {$type = Operator.PLUS;}
                | MINUS {$type = Operator.MINUS;};
compareop returns [Operator type]
                : EQ {$type = Operator.EQ;}
                | NEQ {$type = Operator.NEQ;}
                | LESSER {$type = Operator.LESSER;}
                | LESSEREQ {$type = Operator.LESSEREQ;}
                | GREATER {$type = Operator.GREATER;}
                | GREATEREQ {$type = Operator.GREATEREQ;};
logicop returns [Operator type]
                : AND {$type = Operator.AND;}
                | OR {$type = Operator.OR;};
