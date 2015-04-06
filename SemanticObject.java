public class SemanticObject {

    private boolean isConstant;

    private TypeTableEntry type;

    private String name;

    public SemanticObject(boolean isConstant, SymbolTableEntry type, String name) {
        this.isConstant = isConstant;
        this.type = (TypeTableEntry) type;
        this.name = name;
    }

    public boolean getIsConstant() {
        return this.isConstant;
    }

    public SymbolTableEntry getType() {
        return this.type;
    }

    public String getName() {
        return this.name;
    }
}
