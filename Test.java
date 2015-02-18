import org.antlr.runtime.*;
import org.antlr.runtime.tree.CommonTree;
import java.util.ArrayList;
import java.util.List;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths;
import java.nio.file.Files;

public class Test {
    public static void main(String[] args) {
        try {
            byte[] encoded = Files.readAllBytes(Paths.get(args[0]));
            String program = new String(encoded, StandardCharsets.UTF_8);
            TigerLexer lex = new TigerLexer(new ANTLRStringStream(program));
            TokenStream tokens = new CommonTokenStream(lex);

            TigerParser parse = new TigerParser(tokens);

            TigerParser.tigerprogram_return ret = parse.tigerprogram();

            CommonTree ast = (CommonTree) ret.tree;
            printTree(ast);

        } catch (RecognitionException re) {
            System.out.println("RE thrown");
        } catch (Exception e) {
            System.out.println("Need a file bruh");
        }
    }

    private static void printTree(CommonTree ast) {
        print(ast, 0);
    }

    private static void print(CommonTree tree, int level) {
        for (int i = 0; i < level; i++) {
            System.out.print("--");
        }

        System.out.println(" " + tree.getText());

        if (tree.getChildren() != null) {
            for (Object ie : tree.getChildren()) {
                print((CommonTree) ie, level + 1);
            }
        }
    }
}
