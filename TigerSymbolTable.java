import java.util.HashMap;

/**
 * The symbol table for the Tiger language. In Tiger,symbols can be: functions, variables, types
 * In Tiger, all functions have global scope. Types can have global scope but variables cannot.(verify?)
 * Types and variables share the same namespace but functions are in a different namespace.
 */
public class TigerSymbolTable {

    private VariableTable varTable = new VariableTable();
    private HashMap<String, FunctionEntry> funcTable = new HashMap<String, FunctionEntry>();

    public void addFunction (String symbol) {
        funcTable.put(symbol, null);
    }

    public void addVariable (String symbol) {
        varTable.put(symbol, null);
    }

    /**
     *
     * @param symbol The name of the variable to look up.
     * @param scope
     * @return
     */
    public VariableEntry getVariable (String symbol, String scope) {
        FunctionEntry func = funcTable.get(scope);

        return func.table.get(symbol);
    }

    private class VariableEntry {

    }

    private class FunctionEntry {
        // Each function has its own variable table due to nested scope.
        public VariableTable table = new VariableTable();

    }

    private class VariableTable extends HashMap<String, VariableEntry> {}
}
