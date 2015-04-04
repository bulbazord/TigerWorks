public class VarTableEntry extends SymbolTableEntry {

    /* This represents the declared type */
    private TypeTableEntry type;

    public VarTableEntry(Scope scope, String name) {
        super(scope, name);
    }
}
