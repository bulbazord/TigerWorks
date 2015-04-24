import java.util.Arrays;
import java.util.List;

public class FunctionTableEntry extends SymbolTableEntry {

    private TypeTableEntry returnType;

    private List<TypeTableEntry> parameterList;

    public FunctionTableEntry(Scope scope, String name, SymbolTableEntry returnType, TypeTableEntry... parameters) {
        this(scope, name, returnType, Arrays.asList(parameters));
    }


    public FunctionTableEntry(Scope scope, String name, SymbolTableEntry returnType, List<TypeTableEntry> parameterList) {
        super(scope, name);
        this.returnType = (TypeTableEntry) returnType;
        this.parameterList = parameterList;
    }

    public TypeTableEntry getReturnType() {
        return this.returnType;
    }

    public List<TypeTableEntry> getParameterList() {
        return this.parameterList;
    }

    public String toString() {
        String ret = (this.returnType == null) ? "void" : this.returnType.getName();
        int numParam = (this.parameterList == null) ? 0 : this.parameterList.size();
        return "Function" +
                "\n\tName: " + this.getName() +
                "\n\tScope: " + this.getScope().getId() +
                "\n\tReturn type: " + ret +
                "\n\tNumber of Parameters: " + numParam;
    }
}
