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
            // Get program
            byte[] encoded = Files.readAllBytes(Paths.get(args[0]));
            String program = new String(encoded, StandardCharsets.UTF_8);
            TigerLexer lex = new TigerLexer(new ANTLRStringStream(program));
            TokenStream tokens = new CommonTokenStream(lex);

            // Parse program
            TigerParser parse = new TigerParser(tokens);
            TigerParser.tigerprogram_return ret = parse.tigerprogram();

            // Report lexing and parsing errors
            int lexerErrors = lex.getNumberOfSyntaxErrors();
            int parseErrors = parse.getNumberOfSyntaxErrors();
            if (lexerErrors > 0 || parseErrors > 0) {
                System.out.println("There were " + 
                                    (lexerErrors+parseErrors) +
                                    " errors total");
            } else {
                // Create tree
                CommonTree ast = (CommonTree) ret.tree;
                DOTTreeGenerator gen = new DOTTreeGenerator();
                StringTemplate st = gen.toDOT(ast);
                // Try writing tree to a dot file
                try {
                    Writer writer = new BufferedWriter(
                                        new OutputStreamWriter(
                                        new FileOutputStream("AST.dot"), "utf-8")); 
                    writer.write(st.toString());
                    writer.close();
                } catch (IOException ex) {
                    System.out.println("There was an error writing to file");
                }

                // Get symbol table from parser
                SymbolTable symbolTable = ret.symbolTable;
                boolean errorsExist = ret.errorExists;
                /*if (!errorsExist) {
                    // Try to walk the tree
                    CommonTreeNodeStream ctns = new CommonTreeNodeStream(ast);
                    try {
                        TigerTreeWalk traversal = new TigerTreeWalk(ctns, symbolTable);
                        traversal.walk();
                    } catch (Exception e) {
                        System.out.println("Semantic error occurred! " + e.getMessage());
                    }
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
