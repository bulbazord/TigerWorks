tree grammar TigerTreeWalk;

options {
    output = AST;
    backtrack = true;
    tokenVocab = Tiger;
    ASTLabelType = CommonTree; 
}

@header {
    import java.util.List;
    import java.util.LinkedList;
    import java.util.Queue;
}

@members {
    private SymbolTable table;
    private static final String DEFAULT_FILENAME = "ir.tigir";

    // This has to be a queue to account for nested loops. 
    private Queue<String> loopLabels = new LinkedList<String>();

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
                      generator.addLabel($ID.text);
                  } paramlist {
                      for (String param : $paramlist.params) {
                        generator.assignVar(param, "0");
                      }
                  } blocklist)
                | ^(FUNCTION typeid ID {
                      generator.addLabel($ID.text);
                  } paramlist {
                      for (String param : $paramlist.params) {
                        generator.assignVar(param, "0");
                      }
                  } blocklist);

typeid          : ^(TYPEID basetype)
                | ^(TYPEID ID);

paramlist returns [List<String> params] 
                @init {
                    $params = new LinkedList<String>();
                }
                : ^(PARAMLIST (param {
                    $paramlist.params.add($param.name);
                })*);

param returns [String name]
                : ^(PARAM ID {
                    $param.name = $ID.text;
                  } typeid);

mainfunction    : ^(MAIN {
                    generator.addLabel($MAIN.text);
                  } blocklist);

blocklist       : ^(BLOCKLIST block+);

block           : ^(BLOCK declsegment statseq);

declsegment     : ^(DECLSEGMENT typedecllist vardecllist);

vardecllist     :  ^(VARDECLLIST vardecl*);

vardecl         :  ^(VARDECL idlist {
                        for (String name : $idlist.names) {
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

ifthen          : ^(IF expr ^(THEN statseq) ^(ELSE statseq))
                | ^(IF expr ^(THEN statseq));

whileloop       : ^(WHILE expr statseq);

forloop         : ^(FOR ID ASSIGN indexexpr indexexpr statseq);

returnstatrule  : RETURN^ expr SEMI!;
breakstatrule   : BREAK^ SEMI!;
stat            : idstatrule | ifthen | whileloop | forloop | returnstatrule 
                | breakstatrule | block;


// Expressions

expr returns [Operator type]
                : logicexpr (logicop^ logicexpr)*;
logicexpr returns [Operator type]       
                : compareexpr (compareop^ compareexpr)*;
compareexpr     : addsubexpr (addsubop^ addsubexpr)*;
addsubexpr      : ^(addsubop tiger_const expr) 
                | ^(addsubop value expr)
                | ^(addsubop expr expr);

// Expressions for the purpose of not allowing nested function calls

f_expr            : f_logicexpr (logicop^ f_logicexpr)*;
f_logicexpr       : f_compareexpr (compareop^ f_compareexpr)*;
f_compareexpr     : f_addsubexpr (addsubop^ f_addsubexpr)*;
f_addsubexpr      : f_exprlit (multdivop^ f_exprlit)*;
f_exprlit         : tiger_const | value | LPAREN! f_expr RPAREN!;


tiger_const       : INTLIT 
                  | FIXEDPTLIT;

value           : ^(VALUE ID indexexpr indexexpr) 
                | ^(VALUE ID indexexpr)
                | ^(VALUE ID);

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
