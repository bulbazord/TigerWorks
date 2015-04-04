public class Scope {

    /* Parent scope, to search in higher scopes if a symbol isn't found
     * within the current scope.
     */
    private Scope parent;

    /* id to make it easier to identify a scope when printing out
     * the table */
    private String id;

    /* Generic scope definition. Used mostly for inner blocks */
    public Scope(Scope parent) {
        this.parent = parent;
    }

    /* Useful for identifying which scopes are functions */
    public Scope(Scope parent, String id) {
        this.parent = parent;
        this.id = id;
    }

    public Scope getParent() {
        return this.parent;
    }

    public String getId() {
        return this.id;
    }
}
