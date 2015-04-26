public class VarTableEntry extends SymbolTableEntry {

    /* The type of value could be anything. 
     * Make it an Object, cast as necessary*/
    private Object value;

    /* This represents the declared type */
    private TypeTableEntry type;

    /* This represents the true type */
    private PrimitiveType trueType;

    /* This is each element's type */
    private PrimitiveType elementType;

    /* Use when it has an initialized value. */
    public VarTableEntry(Scope scope, String name, SymbolTableEntry type, PrimitiveType trueType, Object value) {
        super(scope, name);
        this.type = (TypeTableEntry) type;
        this.trueType = trueType;
        this.value = value;
    }

    /* Use when no initialized value */
    public VarTableEntry(Scope scope, String name, SymbolTableEntry type, PrimitiveType trueType) {
        super(scope, name);
        this.type = (TypeTableEntry) type;
        this.trueType = trueType;
    }

    public TypeTableEntry getType() {
        return this.type;
    }
    
    public Object getValue() {
        return this.value;
    }

    public PrimitiveType getTrueType() {
        return this.trueType;
    }

    public void changeValue(Object update) {
        System.out.println("ChangeValue not implemented");
    }

    public String valueToString() {
        if (value != null) {
            String actualValue = "";
            switch (this.trueType) {
                case TIGER_INT:
                case TIGER_FIXEDPT:
                actualValue = this.value.toString();
                break;

                case TIGER_INT_ARR:
                actualValue = "[";
                for (int i = 0; i < ((TypeTableEntry)type).getLength(); i++) {
                    actualValue = actualValue + ((Integer[])value)[i].toString() + ",";
                }
                actualValue = actualValue + "]";
                break;

                case TIGER_FIXEDPT_ARR:
                actualValue = "[";
                for (int i = 0; i < ((TypeTableEntry)type).getLength(); i++) {
                    actualValue = actualValue + ((Double[])value)[i].toString() + ",";
                }
                actualValue = actualValue + "]";
                break;

                case TIGER_INT_2D_ARR:
                actualValue = "[";
                for (int i = 0; i < ((TypeTableEntry)type).getHeight(); i++) {
                    actualValue = actualValue + "[";
                    for (int j = 0; j < ((TypeTableEntry)type).getLength(); j++) {
                        actualValue = actualValue + ((Integer[][])value)[j][i].toString() + ",";
                    }
                    actualValue = actualValue + "],";
                }
                actualValue = actualValue + "]";
                break;

                case TIGER_FIXEDPT_2D_ARR:
                actualValue = "[";
                for (int i = 0; i < ((TypeTableEntry)type).getHeight(); i++) {
                    actualValue = actualValue + "[";
                    for (int j = 0; j < ((TypeTableEntry)type).getLength(); j++) {
                        actualValue = actualValue + ((Double[][])value)[j][i].toString() + ",";
                    }
                    actualValue = actualValue + "],";
                }
                actualValue = actualValue + "]";
                break;

                default:
                break;
            }
            return actualValue;
        } else {
            return "No value set";
        }
    }

    public String toString() {
        String actualValue = valueToString();
        String scopeName = (this.getScope().getId() == null) ? this.getScope().toString() : this.getScope().getId();
        return "Variable" +
                "\n\tName: " + this.getName() +
                "\n\tScope: " + scopeName + 
                "\n\tType: " + this.type.getName() +
                "\n\tTrue type: " + this.type.trueTypeToString() + 
                "\n\tValue: " + actualValue;
    }
}
