import antlr.SemanticException;
import org.antlr.runtime.*;
import org.antlr.runtime.tree.*;
import org.antlr.stringtemplate.*;

/**
 * A class which takes in an AST and traverses it.
 */
public class TreeWalker {
    CommonTree tree;
    // Scope scope = new Scope();
    public TreeWalker (CommonTree t) {
        tree = t;
    }

    /**
     * Walks through the tree. Currently works based on a preorder traversal.
     */
    public void walk () throws SemanticException {
        Tree current = tree.getParent();
        for (int i = 0; i < current.getChildCount(); i++) {
            Tree child = current.getChild(i);
            visit(child);
        }
    }

    private void visit (Tree node) throws SemanticException {
        switch (node.getType()) {
            case TigerLexer.FUNCTION:
                visitFunction(node);
                break;
            default:
        }
    }

    private void visitFunction (Tree node) throws SemanticException {
        if (node.getChildCount() < 2) {
            throw new SemanticException("Function needs to have some kindof parameters. ");
        }
        Tree type = node.getChild(0);
        Tree name = node.getChild(1);
        // Read the parameters
        // The read the body of the function
    }

    private void visitVariable (Tree node)  throws SemanticException {

    }
}
