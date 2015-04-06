public class TypeTableEntry extends SymbolTableEntry {

    private PrimitiveType trueType;
    /* If it's an array, we want to know how "long" it is. */
    private int length;
    /* If it's a 2 dimensional array it is, we want to know how "tall" it is */
    private int height;
    
    public TypeTableEntry(Scope scope, String name, PrimitiveType trueType, int length, int height) {
        super(scope, name);
        this.trueType = trueType;
        this.length = length;
        this.height = height;
    }

    public boolean equals(TypeTableEntry other) {
        return (this.getScope() == other.getScope())
                && (this.getName().equals(other.getName()));
    }

    public PrimitiveType getTrueType() {
        return this.trueType;
    }

    public int getLength() {
        return this.length;
    }

    public int getHeight() {
        return this.height;
    }

    public String trueTypeToString() {        
        String backingType = "";
        switch (this.trueType) {
            case TIGER_INT:
            backingType = "int";
            break;

            case TIGER_FIXEDPT:
            backingType = "fixedpt";
            break;

            case TIGER_INT_ARR:
            backingType = "array["+this.length+"] of int";
            break;

            case TIGER_FIXEDPT_ARR:
            backingType = "array["+this.length+"] of fixedpt";
            break;

            case TIGER_INT_2D_ARR:
            backingType = "array["+this.length+"]["+this.height+"] of int";
            break;

            case TIGER_FIXEDPT_2D_ARR:
            backingType = "array["+this.length+"]["+this.height+"] of fixedpt";
            break;
            
            default:
            backingType = "Undefined type";
            break;

        }
        return backingType;
 
    }

    public String toString() {
       String scopeName = (this.getScope().getId() == null) ? this.getScope().toString() : this.getScope().getId();
        return "Type" +
                "\n\tName: " + this.getName() +
                "\n\tScope: " + scopeName +
                "\n\tTrue type: " + trueTypeToString();
    }
}
