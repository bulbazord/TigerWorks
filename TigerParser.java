// $ANTLR 3.5.2 Tiger.g 2015-02-04 17:05:08

import org.antlr.runtime.*;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;

@SuppressWarnings("all")
public class TigerParser extends Parser {
	public static final String[] tokenNames = new String[] {
		"<invalid>", "<EOR>", "<DOWN>", "<UP>", "AND", "ARRAY", "ASSIGN", "BEGIN", 
		"BREAK", "COLON", "COMMA", "DIGIT", "DIV", "DO", "ELSE", "END", "ENDDO", 
		"ENDIF", "EQ", "FIXEDPT", "FOR", "FUNCTION", "GREATER", "GREATEREQ", "ID", 
		"IF", "INT", "LBRACK", "LESSER", "LESSEREQ", "LOWERCASE", "LPAREN", "MAIN", 
		"MINUS", "MULT", "NEQ", "NUMBER", "OF", "OR", "PLUS", "RBRACK", "RETURN", 
		"RPAREN", "SEMI", "THEN", "TO", "TYPE", "UNDERSCORE", "UPPERCASE", "VAR", 
		"VOID", "WHILE", "WHITESPACE"
	};
	public static final int EOF=-1;
	public static final int AND=4;
	public static final int ARRAY=5;
	public static final int ASSIGN=6;
	public static final int BEGIN=7;
	public static final int BREAK=8;
	public static final int COLON=9;
	public static final int COMMA=10;
	public static final int DIGIT=11;
	public static final int DIV=12;
	public static final int DO=13;
	public static final int ELSE=14;
	public static final int END=15;
	public static final int ENDDO=16;
	public static final int ENDIF=17;
	public static final int EQ=18;
	public static final int FIXEDPT=19;
	public static final int FOR=20;
	public static final int FUNCTION=21;
	public static final int GREATER=22;
	public static final int GREATEREQ=23;
	public static final int ID=24;
	public static final int IF=25;
	public static final int INT=26;
	public static final int LBRACK=27;
	public static final int LESSER=28;
	public static final int LESSEREQ=29;
	public static final int LOWERCASE=30;
	public static final int LPAREN=31;
	public static final int MAIN=32;
	public static final int MINUS=33;
	public static final int MULT=34;
	public static final int NEQ=35;
	public static final int NUMBER=36;
	public static final int OF=37;
	public static final int OR=38;
	public static final int PLUS=39;
	public static final int RBRACK=40;
	public static final int RETURN=41;
	public static final int RPAREN=42;
	public static final int SEMI=43;
	public static final int THEN=44;
	public static final int TO=45;
	public static final int TYPE=46;
	public static final int UNDERSCORE=47;
	public static final int UPPERCASE=48;
	public static final int VAR=49;
	public static final int VOID=50;
	public static final int WHILE=51;
	public static final int WHITESPACE=52;

	// delegates
	public Parser[] getDelegates() {
		return new Parser[] {};
	}

	// delegators


	public TigerParser(TokenStream input) {
		this(input, new RecognizerSharedState());
	}
	public TigerParser(TokenStream input, RecognizerSharedState state) {
		super(input, state);
	}

	@Override public String[] getTokenNames() { return TigerParser.tokenNames; }
	@Override public String getGrammarFileName() { return "Tiger.g"; }



	// $ANTLR start "var"
	// Tiger.g:33:1: var : ID ;
	public final void var() throws RecognitionException {
		try {
			// Tiger.g:33:9: ( ID )
			// Tiger.g:33:11: ID
			{
			match(input,ID,FOLLOW_ID_in_var380); 
			}

		}
		catch (RecognitionException re) {
			reportError(re);
			recover(input,re);
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "var"



	// $ANTLR start "expr"
	// Tiger.g:34:1: expr : factor ( PLUS factor )* ;
	public final void expr() throws RecognitionException {
		try {
			// Tiger.g:34:9: ( factor ( PLUS factor )* )
			// Tiger.g:34:11: factor ( PLUS factor )*
			{
			pushFollow(FOLLOW_factor_in_expr390);
			factor();
			state._fsp--;

			// Tiger.g:34:18: ( PLUS factor )*
			loop1:
			while (true) {
				int alt1=2;
				int LA1_0 = input.LA(1);
				if ( (LA1_0==PLUS) ) {
					alt1=1;
				}

				switch (alt1) {
				case 1 :
					// Tiger.g:34:20: PLUS factor
					{
					match(input,PLUS,FOLLOW_PLUS_in_expr394); 
					pushFollow(FOLLOW_factor_in_expr396);
					factor();
					state._fsp--;

					}
					break;

				default :
					break loop1;
				}
			}

			}

		}
		catch (RecognitionException re) {
			reportError(re);
			recover(input,re);
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "expr"



	// $ANTLR start "factor"
	// Tiger.g:35:1: factor : NUMBER ;
	public final void factor() throws RecognitionException {
		try {
			// Tiger.g:35:9: ( NUMBER )
			// Tiger.g:35:11: NUMBER
			{
			match(input,NUMBER,FOLLOW_NUMBER_in_factor406); 
			}

		}
		catch (RecognitionException re) {
			reportError(re);
			recover(input,re);
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "factor"

	// Delegated rules



	public static final BitSet FOLLOW_ID_in_var380 = new BitSet(new long[]{0x0000000000000002L});
	public static final BitSet FOLLOW_factor_in_expr390 = new BitSet(new long[]{0x0000008000000002L});
	public static final BitSet FOLLOW_PLUS_in_expr394 = new BitSet(new long[]{0x0000001000000000L});
	public static final BitSet FOLLOW_factor_in_expr396 = new BitSet(new long[]{0x0000008000000002L});
	public static final BitSet FOLLOW_NUMBER_in_factor406 = new BitSet(new long[]{0x0000000000000002L});
}
