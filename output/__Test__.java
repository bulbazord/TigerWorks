import java.io.*;
import org.antlr.runtime.*;
import org.antlr.runtime.debug.DebugEventSocketProxy;


public class __Test__ {

    public static void main(String args[]) throws Exception {
        TigerLexer lex = new TigerLexer(new ANTLRFileStream("/home/kia/Desktop/tigerworks/TigerWorks/output/__Test___input.txt", "UTF8"));
        CommonTokenStream tokens = new CommonTokenStream(lex);

        TigerParser g = new TigerParser(tokens, 49100, null);
        try {
            g.FUNCTION();
        } catch (RecognitionException e) {
            e.printStackTrace();
        }
    }
}