tree grammar TigerTreeWalk;

options {
    output = AST;
    backtrack = no;
    tokenVocab = Tiger;
    ASTLabelType = CommonTree; 
}

@header {

}

@members {
    private SymbolTable table;

    // Add things to the generator as they come up. 
    private IRGenerator generator = new IRGenerator();
    public TigerTreeWalk(TreeNodeStream input, SymbolTable t) {
        this(input);
        table = t;
    }
}

walk      : typedecllist functdecllist mainfunction EOF
          {
              // Some code generation stuff will go here later?
          };

