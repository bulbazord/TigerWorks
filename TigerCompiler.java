import org.antlr.runtime.*;
import org.antlr.runtime.tree.*;
import org.antlr.stringtemplate.*;

import java.io.IOException;
import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;

public class TigerCompiler {
    public static void main(String[] args) {
        if (args.length != 1) {
            System.out.println("Please provide a file, and only a file.");
            System.exit(0);
        }
        try {
            byte[] encoded = Files.readAllBytes(Paths.get(args[0]));
            String program = new String(encoded, StandardCharsets.UTF_8);
            TigerLexer lex = new TigerLexer(new ANTLRStringStream(program));
            TokenStream tokens = new CommonTokenStream(lex);

            TigerParser parse = new TigerParser(tokens);

            TigerParser.tigerprogram_return ret = parse.tigerprogram();

            int lexerErrors = lex.getNumberOfSyntaxErrors();
            int parseErrors = parse.getNumberOfSyntaxErrors();
            if (lexerErrors > 0 || parseErrors > 0) {
                System.out.println("There were " + 
                                    (lexerErrors+parseErrors) +
                                    " errors total");
            } else {
                CommonTree ast = (CommonTree) ret.tree;
                DOTTreeGenerator gen = new DOTTreeGenerator();
                StringTemplate st = gen.toDOT(ast);
                try {
                    Writer writer = new BufferedWriter(
                                        new OutputStreamWriter(
                                        new FileOutputStream("AST.dot"), "utf-8")); 
                    writer.write(st.toString());
                    writer.close();
                } catch (IOException ex) {
                    System.out.println("There was an error writing to file");
                }

                /* Symbol Table stuff! */
                SymbolTable symbolTable = ret.symbolTable;
                boolean errorsExist = ret.errorExists;
                if (!errorsExist) {
                    symbolTable.print();
                }


                // TODO: Properly finish walk.
                /*try {
                    TreeWalker traversal = new TreeWalker(ast);
                    traversal.walk();
                } catch (Exception e) {
                    System.out.println("Semantic error occurred! " + e.getMessage());
                }*/

            }

        } catch (RecognitionException re) {
            System.out.println("A recognition exception has been thrown");
            System.out.println("This should never happen!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /*private static void printTree(CommonTree ast) {
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
    }*/
}
