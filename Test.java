import org.antlr.runtime.*;
public class Test {
    public static void main(String[] args) {
        String src = "begin 1 + 2 + 3 end";
        TigerLexer lex = new TigerLexer(new ANTLRStringStream(src));
        while (true) {
            Token token = lex.nextToken();
            if (token.getType() == TigerLexer.EOF) {
                break;
            }
            System.out.println(token.getType() + " :: " + token.getText());
        }
    }
}
