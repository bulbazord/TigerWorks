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

    /* We will be mapping Scope to a smaller HashMap for each scope's own
     * small symbol table. The scope object will have a parent scope, so we
     * can recursively search upward at the parent tables to find things.
     */
    private Map<Scope, Map<String, SymbolTableEntry>> symbolTable;
    /* Functions get their own little symbol table. This is because
     * they have their own namespace, seperate from types and variables.
     */
    private Map<String, SymbolTableEntry> functionTable;

    /* It's convenient to be able to access the normal primitive types */
    private SymbolTableEntry tigerInt;
    private SymbolTableEntry tigerFixedpt;


    public SymbolTable(Scope globalScope) {
        symbolTable = new HashMap<Scope, Map<String, SymbolTableEntry>>();
        functionTable = new HashMap<String, SymbolTableEntry>();
        setup(globalScope);
    }

    /** Retrieves the Symbol Table entry requested.
     *  Because functions and variables/types have different namespaces
     *  you must check to see if a function is being requested.
     *  If null is returned, it does not exist in the symbol table.
     */
    public SymbolTableEntry get(Scope scope, String name, boolean isFunc) {
        SymbolTableEntry entry = null;
        if (isFunc) {
            entry = functionTable.get(name);
        } else {
            while (entry == null && scope != null) {
                Map<String, SymbolTableEntry> tempTable = symbolTable.get(scope);
                if (tempTable != null) {
                    entry = tempTable.get(name);
                }
                scope = scope.getParent();
            }
        }
        return entry;
    }

    /** Inserts a symbol into the table.
     *  This method checks for you to see if something exists already.
     */
    public void put(SymbolTableEntry entry) {
        if (entry instanceof FunctionTableEntry) {
            System.out.println("Function insertion not implement");
        } else {
            // Either want to insert variable or new type
            SymbolTableEntry exists = get(entry.getScope(), entry.getName(), false);
            if (exists == null) {
                Scope scope = entry.getScope();
                String name = entry.getName();
                // If the scope has never been used before, gotta make the scope's nametable
                if (symbolTable.get(scope) == null) {
                    Map<String, SymbolTableEntry> tempTable = new HashMap<String, SymbolTableEntry>();
                    symbolTable.put(scope, tempTable);
                }
                // Get the nametable, insert the entry
                Map<String, SymbolTableEntry> nameTable = symbolTable.get(scope);
                nameTable.put(name, entry);
            } else {
                if (exists instanceof TypeTableEntry) {
                    System.out.println(entry.getName() + " is already a defined type in this scope");
                } else {
                    System.out.println(entry.getName() + " is already a defined variable in this scope");
                }
            }
        }
    }

    /* Add the following things to our symbol table:
     *  - The int and fixedpt types
     *  - The standard library functions
     */
    public void setup(Scope globalScope) {
        this.tigerInt = new TypeTableEntry(globalScope, "int", PrimitiveType.TIGER_INT, 0, 0);
        this.tigerFixedpt = new TypeTableEntry(globalScope, "fixedpt", PrimitiveType.TIGER_FIXEDPT, 0, 0);

        put(this.tigerInt);
        put(this.tigerFixedpt);
    }

    public void print() {
        System.out.println("Types and Variables: ");
        for (Scope scope : symbolTable.keySet()) {
            Map<String, SymbolTableEntry> nameTable = symbolTable.get(scope);
            for (String name : nameTable.keySet()) {
                System.out.println(nameTable.get(name));
            }
            System.out.println();
        }
        System.out.println();
        System.out.println("Functions: ");
        for (String name : functionTable.keySet()) {
            System.out.println(functionTable.get(name));
        }
    }
}
