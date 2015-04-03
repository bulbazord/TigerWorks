public class Scope {

    /* Parent scope, to search in higher scopes if a symbol isn't found
     * within the current scope.
     */
    private Scope parent;

    public Scope(Scope parent) {
        this.parent = parent;
    }

    public getParent() {
        return this.parent;
    }
}
