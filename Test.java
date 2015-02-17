import org.antlr.runtime.*;
import java.util.ArrayList;
import java.util.List;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths;
import java.nio.file.Files;

public class Test {
    public static void main(String[] args) {
        List<String> lines;
        try {
            lines = Files.readAllLines(Paths.get(args[0]),
                                                StandardCharsets.UTF_8);
        } catch (Exception e) {
            lines = new ArrayList<>();
        }

        for (String src : lines) {
            TigerLexer lex = new TigerLexer(new ANTLRStringStream(src));
            while (true) {
                Token token = lex.nextToken();
                if (token.getType() == TigerLexer.EOF) {
                    break;
                } else if (token.getType() != TigerLexer.WHITESPACE) {
                    System.out.print(token.getText() + " ");
                }
            }
            System.out.println();
        }
    }
}
