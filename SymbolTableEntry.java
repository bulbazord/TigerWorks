public class SymbolTableEntry {

    private String name;

    private Scope scope;

    public SymbolTableEntry(Scope scope, String name) {
        this.name = name;
        this.scope = scope;
    }

    public Scope getScope() {
        return this.scope;
    }

    public String getName() {
        return this.name;
    }

    public boolean equals(SymbolTableEntry entry) {
        return this.name.equals(entry.getName());
    }
    
    public String toString() {
        return "Entry:\n\tName: " + this.name + "\n\tScope: "
                    + this.scope.getId();
    }
}
