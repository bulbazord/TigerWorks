import java.util.HashMap;
import java.util.Map;

/**
 * The symbol table for the Tiger language. In Tiger,symbols can be: functions, variables, types
 * In Tiger, all functions have global scope. Types can have global scope but variables cannot.
 * Types and variables share the same namespace but functions are in a different namespace.
 * Functions can be shadowed by variables/types in more local scopes.
 */
public class SymbolTable {

    /* Variables representing the built in types. For ease of access */
    public static String TIGER_INT = "int";
    public static String TIGER_FIXEDPT = "fixedpt";

    /* We will be mapping Scope to a smaller HashMap for each scope's own
     * small symbol table. The scope object will have a parent scope, so we
     * can recursively search upward at the parent tables to find things.
     */
    private Map<Scope, HashMap<String, SymbolTableEntry>> symbolTable;


    public SymbolTable(Scope globalScope) {
        symbolTable = new HashMap<Scope, HashMap<String, SymbolTableEntry>>();
        setup(globalScope);
    }

    public SymbolTableEntry get(Scope scope, String name) {
        Map<String, SymbolTableEntry> nameTable = symbolTable.get(scope);
        SymbolTableEntry entry = null;
        while (scope != null && entry == null) {
            entry = nameTable.get(name);
            scope = scope.getParent();
        }
        return entry;
    }

    /* Add the following things to our symbol table:
     *  - The int and fixedpt types
     *  - The standard library functions
     */
    public void setup(Scope globalScope) {
    }
}
