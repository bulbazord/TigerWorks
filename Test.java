import org.antlr.runtime.*;
public class Test {
    public static void main(String[] args) {
        /*String src = "__ ++ void main () begin 5 end;";*/
        String src = "";
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
