// $ANTLR 3.5.2 Tiger.g 2015-02-04 17:05:08

import org.antlr.runtime.*;
import java.util.Stack;
import java.util.List;
import java.util.ArrayList;

@SuppressWarnings("all")
public class TigerLexer extends Lexer {
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
	// delegators
	public Lexer[] getDelegates() {
		return new Lexer[] {};
	}

	public TigerLexer() {} 
	public TigerLexer(CharStream input) {
		this(input, new RecognizerSharedState());
	}
	public TigerLexer(CharStream input, RecognizerSharedState state) {
		super(input,state);
	}
	@Override public String getGrammarFileName() { return "Tiger.g"; }

	// $ANTLR start "AND"
	public final void mAND() throws RecognitionException {
		try {
			int _type = AND;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:2:5: ( '&' )
			// Tiger.g:2:7: '&'
			{
			match('&'); 
			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "AND"

	// $ANTLR start "ASSIGN"
	public final void mASSIGN() throws RecognitionException {
		try {
			int _type = ASSIGN;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:3:8: ( ':=' )
			// Tiger.g:3:10: ':='
			{
			match(":="); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "ASSIGN"

	// $ANTLR start "COLON"
	public final void mCOLON() throws RecognitionException {
		try {
			int _type = COLON;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:4:7: ( ':' )
			// Tiger.g:4:9: ':'
			{
			match(':'); 
			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "COLON"

	// $ANTLR start "COMMA"
	public final void mCOMMA() throws RecognitionException {
		try {
			int _type = COMMA;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:5:7: ( ',' )
			// Tiger.g:5:9: ','
			{
			match(','); 
			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "COMMA"

	// $ANTLR start "DIV"
	public final void mDIV() throws RecognitionException {
		try {
			int _type = DIV;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:6:5: ( '/' )
			// Tiger.g:6:7: '/'
			{
			match('/'); 
			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "DIV"

	// $ANTLR start "EQ"
	public final void mEQ() throws RecognitionException {
		try {
			int _type = EQ;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:7:4: ( '=' )
			// Tiger.g:7:6: '='
			{
			match('='); 
			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "EQ"

	// $ANTLR start "GREATER"
	public final void mGREATER() throws RecognitionException {
		try {
			int _type = GREATER;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:8:9: ( '>' )
			// Tiger.g:8:11: '>'
			{
			match('>'); 
			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "GREATER"

	// $ANTLR start "GREATEREQ"
	public final void mGREATEREQ() throws RecognitionException {
		try {
			int _type = GREATEREQ;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:9:11: ( '>=' )
			// Tiger.g:9:13: '>='
			{
			match(">="); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "GREATEREQ"

	// $ANTLR start "LBRACK"
	public final void mLBRACK() throws RecognitionException {
		try {
			int _type = LBRACK;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:10:8: ( '[' )
			// Tiger.g:10:10: '['
			{
			match('['); 
			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "LBRACK"

	// $ANTLR start "LESSER"
	public final void mLESSER() throws RecognitionException {
		try {
			int _type = LESSER;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:11:8: ( '<' )
			// Tiger.g:11:10: '<'
			{
			match('<'); 
			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "LESSER"

	// $ANTLR start "LESSEREQ"
	public final void mLESSEREQ() throws RecognitionException {
		try {
			int _type = LESSEREQ;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:12:10: ( '<=' )
			// Tiger.g:12:12: '<='
			{
			match("<="); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "LESSEREQ"

	// $ANTLR start "LPAREN"
	public final void mLPAREN() throws RecognitionException {
		try {
			int _type = LPAREN;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:13:8: ( '(' )
			// Tiger.g:13:10: '('
			{
			match('('); 
			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "LPAREN"

	// $ANTLR start "MINUS"
	public final void mMINUS() throws RecognitionException {
		try {
			int _type = MINUS;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:14:7: ( '-' )
			// Tiger.g:14:9: '-'
			{
			match('-'); 
			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "MINUS"

	// $ANTLR start "MULT"
	public final void mMULT() throws RecognitionException {
		try {
			int _type = MULT;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:15:6: ( '*' )
			// Tiger.g:15:8: '*'
			{
			match('*'); 
			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "MULT"

	// $ANTLR start "NEQ"
	public final void mNEQ() throws RecognitionException {
		try {
			int _type = NEQ;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:16:5: ( '<>' )
			// Tiger.g:16:7: '<>'
			{
			match("<>"); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "NEQ"

	// $ANTLR start "OR"
	public final void mOR() throws RecognitionException {
		try {
			int _type = OR;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:17:4: ( '|' )
			// Tiger.g:17:6: '|'
			{
			match('|'); 
			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "OR"

	// $ANTLR start "PLUS"
	public final void mPLUS() throws RecognitionException {
		try {
			int _type = PLUS;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:18:6: ( '+' )
			// Tiger.g:18:8: '+'
			{
			match('+'); 
			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "PLUS"

	// $ANTLR start "RBRACK"
	public final void mRBRACK() throws RecognitionException {
		try {
			int _type = RBRACK;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:19:8: ( ']' )
			// Tiger.g:19:10: ']'
			{
			match(']'); 
			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "RBRACK"

	// $ANTLR start "RPAREN"
	public final void mRPAREN() throws RecognitionException {
		try {
			int _type = RPAREN;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:20:8: ( ')' )
			// Tiger.g:20:10: ')'
			{
			match(')'); 
			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "RPAREN"

	// $ANTLR start "SEMI"
	public final void mSEMI() throws RecognitionException {
		try {
			int _type = SEMI;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:21:6: ( ';' )
			// Tiger.g:21:8: ';'
			{
			match(';'); 
			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "SEMI"

	// $ANTLR start "UNDERSCORE"
	public final void mUNDERSCORE() throws RecognitionException {
		try {
			int _type = UNDERSCORE;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:22:12: ( '_' )
			// Tiger.g:22:14: '_'
			{
			match('_'); 
			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "UNDERSCORE"

	// $ANTLR start "BEGIN"
	public final void mBEGIN() throws RecognitionException {
		try {
			int _type = BEGIN;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:42:5: ( 'begin' )
			// Tiger.g:42:7: 'begin'
			{
			match("begin"); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "BEGIN"

	// $ANTLR start "END"
	public final void mEND() throws RecognitionException {
		try {
			int _type = END;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:45:5: ( 'end' )
			// Tiger.g:45:7: 'end'
			{
			match("end"); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "END"

	// $ANTLR start "FUNCTION"
	public final void mFUNCTION() throws RecognitionException {
		try {
			int _type = FUNCTION;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:48:5: ( 'function' )
			// Tiger.g:48:7: 'function'
			{
			match("function"); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "FUNCTION"

	// $ANTLR start "VOID"
	public final void mVOID() throws RecognitionException {
		try {
			int _type = VOID;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:51:5: ( 'void' )
			// Tiger.g:51:7: 'void'
			{
			match("void"); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "VOID"

	// $ANTLR start "MAIN"
	public final void mMAIN() throws RecognitionException {
		try {
			int _type = MAIN;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:54:5: ( 'main' )
			// Tiger.g:54:7: 'main'
			{
			match("main"); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "MAIN"

	// $ANTLR start "TYPE"
	public final void mTYPE() throws RecognitionException {
		try {
			int _type = TYPE;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:57:5: ( 'type' )
			// Tiger.g:57:7: 'type'
			{
			match("type"); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "TYPE"

	// $ANTLR start "ARRAY"
	public final void mARRAY() throws RecognitionException {
		try {
			int _type = ARRAY;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:60:5: ( 'array' )
			// Tiger.g:60:7: 'array'
			{
			match("array"); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "ARRAY"

	// $ANTLR start "OF"
	public final void mOF() throws RecognitionException {
		try {
			int _type = OF;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:63:5: ( 'of' )
			// Tiger.g:63:7: 'of'
			{
			match("of"); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "OF"

	// $ANTLR start "INT"
	public final void mINT() throws RecognitionException {
		try {
			int _type = INT;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:66:5: ( 'int' )
			// Tiger.g:66:7: 'int'
			{
			match("int"); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "INT"

	// $ANTLR start "FIXEDPT"
	public final void mFIXEDPT() throws RecognitionException {
		try {
			int _type = FIXEDPT;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:69:5: ( 'fixedpt' )
			// Tiger.g:69:7: 'fixedpt'
			{
			match("fixedpt"); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "FIXEDPT"

	// $ANTLR start "VAR"
	public final void mVAR() throws RecognitionException {
		try {
			int _type = VAR;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:72:5: ( 'var' )
			// Tiger.g:72:7: 'var'
			{
			match("var"); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "VAR"

	// $ANTLR start "IF"
	public final void mIF() throws RecognitionException {
		try {
			int _type = IF;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:75:5: ( 'if' )
			// Tiger.g:75:7: 'if'
			{
			match("if"); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "IF"

	// $ANTLR start "THEN"
	public final void mTHEN() throws RecognitionException {
		try {
			int _type = THEN;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:78:5: ( 'then' )
			// Tiger.g:78:7: 'then'
			{
			match("then"); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "THEN"

	// $ANTLR start "ENDIF"
	public final void mENDIF() throws RecognitionException {
		try {
			int _type = ENDIF;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:81:5: ( 'endif' )
			// Tiger.g:81:7: 'endif'
			{
			match("endif"); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "ENDIF"

	// $ANTLR start "ELSE"
	public final void mELSE() throws RecognitionException {
		try {
			int _type = ELSE;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:84:5: ( 'else' )
			// Tiger.g:84:7: 'else'
			{
			match("else"); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "ELSE"

	// $ANTLR start "WHILE"
	public final void mWHILE() throws RecognitionException {
		try {
			int _type = WHILE;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:87:5: ( 'while' )
			// Tiger.g:87:7: 'while'
			{
			match("while"); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "WHILE"

	// $ANTLR start "DO"
	public final void mDO() throws RecognitionException {
		try {
			int _type = DO;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:90:5: ( 'do' )
			// Tiger.g:90:7: 'do'
			{
			match("do"); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "DO"

	// $ANTLR start "ENDDO"
	public final void mENDDO() throws RecognitionException {
		try {
			int _type = ENDDO;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:93:5: ( 'enddo' )
			// Tiger.g:93:7: 'enddo'
			{
			match("enddo"); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "ENDDO"

	// $ANTLR start "FOR"
	public final void mFOR() throws RecognitionException {
		try {
			int _type = FOR;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:96:5: ( 'for' )
			// Tiger.g:96:7: 'for'
			{
			match("for"); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "FOR"

	// $ANTLR start "TO"
	public final void mTO() throws RecognitionException {
		try {
			int _type = TO;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:99:5: ( 'to' )
			// Tiger.g:99:7: 'to'
			{
			match("to"); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "TO"

	// $ANTLR start "BREAK"
	public final void mBREAK() throws RecognitionException {
		try {
			int _type = BREAK;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:102:5: ( 'break' )
			// Tiger.g:102:7: 'break'
			{
			match("break"); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "BREAK"

	// $ANTLR start "RETURN"
	public final void mRETURN() throws RecognitionException {
		try {
			int _type = RETURN;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:105:5: ( 'return' )
			// Tiger.g:105:7: 'return'
			{
			match("return"); 

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "RETURN"

	// $ANTLR start "ID"
	public final void mID() throws RecognitionException {
		try {
			int _type = ID;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:108:5: ( ( UPPERCASE | LOWERCASE ) ( UPPERCASE | LOWERCASE | DIGIT | UNDERSCORE )+ )
			// Tiger.g:108:7: ( UPPERCASE | LOWERCASE ) ( UPPERCASE | LOWERCASE | DIGIT | UNDERSCORE )+
			{
			if ( (input.LA(1) >= 'A' && input.LA(1) <= 'Z')||(input.LA(1) >= 'a' && input.LA(1) <= 'z') ) {
				input.consume();
			}
			else {
				MismatchedSetException mse = new MismatchedSetException(null,input);
				recover(mse);
				throw mse;
			}
			// Tiger.g:108:32: ( UPPERCASE | LOWERCASE | DIGIT | UNDERSCORE )+
			int cnt1=0;
			loop1:
			while (true) {
				int alt1=2;
				int LA1_0 = input.LA(1);
				if ( ((LA1_0 >= '0' && LA1_0 <= '9')||(LA1_0 >= 'A' && LA1_0 <= 'Z')||LA1_0=='_'||(LA1_0 >= 'a' && LA1_0 <= 'z')) ) {
					alt1=1;
				}

				switch (alt1) {
				case 1 :
					// Tiger.g:
					{
					if ( (input.LA(1) >= '0' && input.LA(1) <= '9')||(input.LA(1) >= 'A' && input.LA(1) <= 'Z')||input.LA(1)=='_'||(input.LA(1) >= 'a' && input.LA(1) <= 'z') ) {
						input.consume();
					}
					else {
						MismatchedSetException mse = new MismatchedSetException(null,input);
						recover(mse);
						throw mse;
					}
					}
					break;

				default :
					if ( cnt1 >= 1 ) break loop1;
					EarlyExitException eee = new EarlyExitException(1, input);
					throw eee;
				}
				cnt1++;
			}

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "ID"

	// $ANTLR start "NUMBER"
	public final void mNUMBER() throws RecognitionException {
		try {
			int _type = NUMBER;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:112:5: ( ( DIGIT )+ )
			// Tiger.g:112:7: ( DIGIT )+
			{
			// Tiger.g:112:7: ( DIGIT )+
			int cnt2=0;
			loop2:
			while (true) {
				int alt2=2;
				int LA2_0 = input.LA(1);
				if ( ((LA2_0 >= '0' && LA2_0 <= '9')) ) {
					alt2=1;
				}

				switch (alt2) {
				case 1 :
					// Tiger.g:
					{
					if ( (input.LA(1) >= '0' && input.LA(1) <= '9') ) {
						input.consume();
					}
					else {
						MismatchedSetException mse = new MismatchedSetException(null,input);
						recover(mse);
						throw mse;
					}
					}
					break;

				default :
					if ( cnt2 >= 1 ) break loop2;
					EarlyExitException eee = new EarlyExitException(2, input);
					throw eee;
				}
				cnt2++;
			}

			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "NUMBER"

	// $ANTLR start "WHITESPACE"
	public final void mWHITESPACE() throws RecognitionException {
		try {
			int _type = WHITESPACE;
			int _channel = DEFAULT_TOKEN_CHANNEL;
			// Tiger.g:115:5: ( ( '\\t' | ' ' | '\\r' | '\\n' | '\\u000C' )+ )
			// Tiger.g:115:7: ( '\\t' | ' ' | '\\r' | '\\n' | '\\u000C' )+
			{
			// Tiger.g:115:7: ( '\\t' | ' ' | '\\r' | '\\n' | '\\u000C' )+
			int cnt3=0;
			loop3:
			while (true) {
				int alt3=2;
				int LA3_0 = input.LA(1);
				if ( ((LA3_0 >= '\t' && LA3_0 <= '\n')||(LA3_0 >= '\f' && LA3_0 <= '\r')||LA3_0==' ') ) {
					alt3=1;
				}

				switch (alt3) {
				case 1 :
					// Tiger.g:
					{
					if ( (input.LA(1) >= '\t' && input.LA(1) <= '\n')||(input.LA(1) >= '\f' && input.LA(1) <= '\r')||input.LA(1)==' ' ) {
						input.consume();
					}
					else {
						MismatchedSetException mse = new MismatchedSetException(null,input);
						recover(mse);
						throw mse;
					}
					}
					break;

				default :
					if ( cnt3 >= 1 ) break loop3;
					EarlyExitException eee = new EarlyExitException(3, input);
					throw eee;
				}
				cnt3++;
			}

			_channel = HIDDEN;
			}

			state.type = _type;
			state.channel = _channel;
		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "WHITESPACE"

	// $ANTLR start "DIGIT"
	public final void mDIGIT() throws RecognitionException {
		try {
			// Tiger.g:118:5: ( '0' .. '9' )
			// Tiger.g:
			{
			if ( (input.LA(1) >= '0' && input.LA(1) <= '9') ) {
				input.consume();
			}
			else {
				MismatchedSetException mse = new MismatchedSetException(null,input);
				recover(mse);
				throw mse;
			}
			}

		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "DIGIT"

	// $ANTLR start "LOWERCASE"
	public final void mLOWERCASE() throws RecognitionException {
		try {
			// Tiger.g:121:5: ( 'a' .. 'z' )
			// Tiger.g:
			{
			if ( (input.LA(1) >= 'a' && input.LA(1) <= 'z') ) {
				input.consume();
			}
			else {
				MismatchedSetException mse = new MismatchedSetException(null,input);
				recover(mse);
				throw mse;
			}
			}

		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "LOWERCASE"

	// $ANTLR start "UPPERCASE"
	public final void mUPPERCASE() throws RecognitionException {
		try {
			// Tiger.g:124:5: ( 'A' .. 'Z' )
			// Tiger.g:
			{
			if ( (input.LA(1) >= 'A' && input.LA(1) <= 'Z') ) {
				input.consume();
			}
			else {
				MismatchedSetException mse = new MismatchedSetException(null,input);
				recover(mse);
				throw mse;
			}
			}

		}
		finally {
			// do for sure before leaving
		}
	}
	// $ANTLR end "UPPERCASE"

	@Override
	public void mTokens() throws RecognitionException {
		// Tiger.g:1:8: ( AND | ASSIGN | COLON | COMMA | DIV | EQ | GREATER | GREATEREQ | LBRACK | LESSER | LESSEREQ | LPAREN | MINUS | MULT | NEQ | OR | PLUS | RBRACK | RPAREN | SEMI | UNDERSCORE | BEGIN | END | FUNCTION | VOID | MAIN | TYPE | ARRAY | OF | INT | FIXEDPT | VAR | IF | THEN | ENDIF | ELSE | WHILE | DO | ENDDO | FOR | TO | BREAK | RETURN | ID | NUMBER | WHITESPACE )
		int alt4=46;
		alt4 = dfa4.predict(input);
		switch (alt4) {
			case 1 :
				// Tiger.g:1:10: AND
				{
				mAND(); 

				}
				break;
			case 2 :
				// Tiger.g:1:14: ASSIGN
				{
				mASSIGN(); 

				}
				break;
			case 3 :
				// Tiger.g:1:21: COLON
				{
				mCOLON(); 

				}
				break;
			case 4 :
				// Tiger.g:1:27: COMMA
				{
				mCOMMA(); 

				}
				break;
			case 5 :
				// Tiger.g:1:33: DIV
				{
				mDIV(); 

				}
				break;
			case 6 :
				// Tiger.g:1:37: EQ
				{
				mEQ(); 

				}
				break;
			case 7 :
				// Tiger.g:1:40: GREATER
				{
				mGREATER(); 

				}
				break;
			case 8 :
				// Tiger.g:1:48: GREATEREQ
				{
				mGREATEREQ(); 

				}
				break;
			case 9 :
				// Tiger.g:1:58: LBRACK
				{
				mLBRACK(); 

				}
				break;
			case 10 :
				// Tiger.g:1:65: LESSER
				{
				mLESSER(); 

				}
				break;
			case 11 :
				// Tiger.g:1:72: LESSEREQ
				{
				mLESSEREQ(); 

				}
				break;
			case 12 :
				// Tiger.g:1:81: LPAREN
				{
				mLPAREN(); 

				}
				break;
			case 13 :
				// Tiger.g:1:88: MINUS
				{
				mMINUS(); 

				}
				break;
			case 14 :
				// Tiger.g:1:94: MULT
				{
				mMULT(); 

				}
				break;
			case 15 :
				// Tiger.g:1:99: NEQ
				{
				mNEQ(); 

				}
				break;
			case 16 :
				// Tiger.g:1:103: OR
				{
				mOR(); 

				}
				break;
			case 17 :
				// Tiger.g:1:106: PLUS
				{
				mPLUS(); 

				}
				break;
			case 18 :
				// Tiger.g:1:111: RBRACK
				{
				mRBRACK(); 

				}
				break;
			case 19 :
				// Tiger.g:1:118: RPAREN
				{
				mRPAREN(); 

				}
				break;
			case 20 :
				// Tiger.g:1:125: SEMI
				{
				mSEMI(); 

				}
				break;
			case 21 :
				// Tiger.g:1:130: UNDERSCORE
				{
				mUNDERSCORE(); 

				}
				break;
			case 22 :
				// Tiger.g:1:141: BEGIN
				{
				mBEGIN(); 

				}
				break;
			case 23 :
				// Tiger.g:1:147: END
				{
				mEND(); 

				}
				break;
			case 24 :
				// Tiger.g:1:151: FUNCTION
				{
				mFUNCTION(); 

				}
				break;
			case 25 :
				// Tiger.g:1:160: VOID
				{
				mVOID(); 

				}
				break;
			case 26 :
				// Tiger.g:1:165: MAIN
				{
				mMAIN(); 

				}
				break;
			case 27 :
				// Tiger.g:1:170: TYPE
				{
				mTYPE(); 

				}
				break;
			case 28 :
				// Tiger.g:1:175: ARRAY
				{
				mARRAY(); 

				}
				break;
			case 29 :
				// Tiger.g:1:181: OF
				{
				mOF(); 

				}
				break;
			case 30 :
				// Tiger.g:1:184: INT
				{
				mINT(); 

				}
				break;
			case 31 :
				// Tiger.g:1:188: FIXEDPT
				{
				mFIXEDPT(); 

				}
				break;
			case 32 :
				// Tiger.g:1:196: VAR
				{
				mVAR(); 

				}
				break;
			case 33 :
				// Tiger.g:1:200: IF
				{
				mIF(); 

				}
				break;
			case 34 :
				// Tiger.g:1:203: THEN
				{
				mTHEN(); 

				}
				break;
			case 35 :
				// Tiger.g:1:208: ENDIF
				{
				mENDIF(); 

				}
				break;
			case 36 :
				// Tiger.g:1:214: ELSE
				{
				mELSE(); 

				}
				break;
			case 37 :
				// Tiger.g:1:219: WHILE
				{
				mWHILE(); 

				}
				break;
			case 38 :
				// Tiger.g:1:225: DO
				{
				mDO(); 

				}
				break;
			case 39 :
				// Tiger.g:1:228: ENDDO
				{
				mENDDO(); 

				}
				break;
			case 40 :
				// Tiger.g:1:234: FOR
				{
				mFOR(); 

				}
				break;
			case 41 :
				// Tiger.g:1:238: TO
				{
				mTO(); 

				}
				break;
			case 42 :
				// Tiger.g:1:241: BREAK
				{
				mBREAK(); 

				}
				break;
			case 43 :
				// Tiger.g:1:247: RETURN
				{
				mRETURN(); 

				}
				break;
			case 44 :
				// Tiger.g:1:254: ID
				{
				mID(); 

				}
				break;
			case 45 :
				// Tiger.g:1:257: NUMBER
				{
				mNUMBER(); 

				}
				break;
			case 46 :
				// Tiger.g:1:264: WHITESPACE
				{
				mWHITESPACE(); 

				}
				break;

		}
	}


	protected DFA4 dfa4 = new DFA4(this);
	static final String DFA4_eotS =
		"\2\uffff\1\42\3\uffff\1\44\1\uffff\1\47\37\uffff\14\36\1\110\1\36\1\112"+
		"\1\36\1\114\1\36\1\116\3\36\1\124\3\36\1\130\1\36\1\132\3\36\1\uffff\1"+
		"\36\1\uffff\1\137\1\uffff\1\36\1\uffff\5\36\1\uffff\1\146\2\36\1\uffff"+
		"\1\151\1\uffff\1\152\1\153\1\154\1\36\1\uffff\2\36\1\160\1\161\1\162\1"+
		"\163\1\uffff\2\36\4\uffff\1\166\1\167\1\36\4\uffff\2\36\2\uffff\1\173"+
		"\1\36\1\175\1\uffff\1\176\2\uffff";
	static final String DFA4_eofS =
		"\177\uffff";
	static final String DFA4_minS =
		"\1\11\1\uffff\1\75\3\uffff\1\75\1\uffff\1\75\11\uffff\14\60\12\uffff\1"+
		"\147\1\145\1\144\1\163\1\156\1\170\1\162\1\151\1\162\1\151\1\160\1\145"+
		"\1\60\1\162\1\60\1\164\1\60\1\151\1\60\1\164\1\151\1\141\1\60\1\145\1"+
		"\143\1\145\1\60\1\144\1\60\1\156\1\145\1\156\1\uffff\1\141\1\uffff\1\60"+
		"\1\uffff\1\154\1\uffff\1\165\1\156\1\153\1\146\1\157\1\uffff\1\60\1\164"+
		"\1\144\1\uffff\1\60\1\uffff\3\60\1\171\1\uffff\1\145\1\162\4\60\1\uffff"+
		"\1\151\1\160\4\uffff\2\60\1\156\4\uffff\1\157\1\164\2\uffff\1\60\1\156"+
		"\1\60\1\uffff\1\60\2\uffff";
	static final String DFA4_maxS =
		"\1\174\1\uffff\1\75\3\uffff\1\75\1\uffff\1\76\11\uffff\14\172\12\uffff"+
		"\1\147\1\145\1\144\1\163\1\156\1\170\1\162\1\151\1\162\1\151\1\160\1\145"+
		"\1\172\1\162\1\172\1\164\1\172\1\151\1\172\1\164\1\151\1\141\1\172\1\145"+
		"\1\143\1\145\1\172\1\144\1\172\1\156\1\145\1\156\1\uffff\1\141\1\uffff"+
		"\1\172\1\uffff\1\154\1\uffff\1\165\1\156\1\153\1\146\1\157\1\uffff\1\172"+
		"\1\164\1\144\1\uffff\1\172\1\uffff\3\172\1\171\1\uffff\1\145\1\162\4\172"+
		"\1\uffff\1\151\1\160\4\uffff\2\172\1\156\4\uffff\1\157\1\164\2\uffff\1"+
		"\172\1\156\1\172\1\uffff\1\172\2\uffff";
	static final String DFA4_acceptS =
		"\1\uffff\1\1\1\uffff\1\4\1\5\1\6\1\uffff\1\11\1\uffff\1\14\1\15\1\16\1"+
		"\20\1\21\1\22\1\23\1\24\1\25\14\uffff\1\54\1\55\1\56\1\2\1\3\1\10\1\7"+
		"\1\13\1\17\1\12\40\uffff\1\51\1\uffff\1\35\1\uffff\1\41\1\uffff\1\46\5"+
		"\uffff\1\27\3\uffff\1\50\1\uffff\1\40\4\uffff\1\36\6\uffff\1\44\2\uffff"+
		"\1\31\1\32\1\33\1\42\3\uffff\1\26\1\52\1\43\1\47\2\uffff\1\34\1\45\3\uffff"+
		"\1\53\1\uffff\1\37\1\30";
	static final String DFA4_specialS =
		"\177\uffff}>";
	static final String[] DFA4_transitionS = {
			"\2\40\1\uffff\2\40\22\uffff\1\40\5\uffff\1\1\1\uffff\1\11\1\17\1\13\1"+
			"\15\1\3\1\12\1\uffff\1\4\12\37\1\2\1\20\1\10\1\5\1\6\2\uffff\32\36\1"+
			"\7\1\uffff\1\16\1\uffff\1\21\1\uffff\1\30\1\22\1\36\1\34\1\23\1\24\2"+
			"\36\1\32\3\36\1\26\1\36\1\31\2\36\1\35\1\36\1\27\1\36\1\25\1\33\3\36"+
			"\1\uffff\1\14",
			"",
			"\1\41",
			"",
			"",
			"",
			"\1\43",
			"",
			"\1\45\1\46",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\4\36\1\50\14\36\1\51\10\36",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\13\36\1\53\1\36\1\52\14\36",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\10\36\1\55\5\36\1\56\5\36"+
			"\1\54\5\36",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\1\60\15\36\1\57\13\36",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\1\61\31\36",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\7\36\1\63\6\36\1\64\11\36"+
			"\1\62\1\36",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\21\36\1\65\10\36",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\5\36\1\66\24\36",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\5\36\1\70\7\36\1\67\14\36",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\7\36\1\71\22\36",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\16\36\1\72\13\36",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\4\36\1\73\25\36",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"",
			"\1\74",
			"\1\75",
			"\1\76",
			"\1\77",
			"\1\100",
			"\1\101",
			"\1\102",
			"\1\103",
			"\1\104",
			"\1\105",
			"\1\106",
			"\1\107",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\32\36",
			"\1\111",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\32\36",
			"\1\113",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\32\36",
			"\1\115",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\32\36",
			"\1\117",
			"\1\120",
			"\1\121",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\3\36\1\123\4\36\1\122\21\36",
			"\1\125",
			"\1\126",
			"\1\127",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\32\36",
			"\1\131",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\32\36",
			"\1\133",
			"\1\134",
			"\1\135",
			"",
			"\1\136",
			"",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\32\36",
			"",
			"\1\140",
			"",
			"\1\141",
			"\1\142",
			"\1\143",
			"\1\144",
			"\1\145",
			"",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\32\36",
			"\1\147",
			"\1\150",
			"",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\32\36",
			"",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\32\36",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\32\36",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\32\36",
			"\1\155",
			"",
			"\1\156",
			"\1\157",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\32\36",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\32\36",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\32\36",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\32\36",
			"",
			"\1\164",
			"\1\165",
			"",
			"",
			"",
			"",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\32\36",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\32\36",
			"\1\170",
			"",
			"",
			"",
			"",
			"\1\171",
			"\1\172",
			"",
			"",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\32\36",
			"\1\174",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\32\36",
			"",
			"\12\36\7\uffff\32\36\4\uffff\1\36\1\uffff\32\36",
			"",
			""
	};

	static final short[] DFA4_eot = DFA.unpackEncodedString(DFA4_eotS);
	static final short[] DFA4_eof = DFA.unpackEncodedString(DFA4_eofS);
	static final char[] DFA4_min = DFA.unpackEncodedStringToUnsignedChars(DFA4_minS);
	static final char[] DFA4_max = DFA.unpackEncodedStringToUnsignedChars(DFA4_maxS);
	static final short[] DFA4_accept = DFA.unpackEncodedString(DFA4_acceptS);
	static final short[] DFA4_special = DFA.unpackEncodedString(DFA4_specialS);
	static final short[][] DFA4_transition;

	static {
		int numStates = DFA4_transitionS.length;
		DFA4_transition = new short[numStates][];
		for (int i=0; i<numStates; i++) {
			DFA4_transition[i] = DFA.unpackEncodedString(DFA4_transitionS[i]);
		}
	}

	protected class DFA4 extends DFA {

		public DFA4(BaseRecognizer recognizer) {
			this.recognizer = recognizer;
			this.decisionNumber = 4;
			this.eot = DFA4_eot;
			this.eof = DFA4_eof;
			this.min = DFA4_min;
			this.max = DFA4_max;
			this.accept = DFA4_accept;
			this.special = DFA4_special;
			this.transition = DFA4_transition;
		}
		@Override
		public String getDescription() {
			return "1:1: Tokens : ( AND | ASSIGN | COLON | COMMA | DIV | EQ | GREATER | GREATEREQ | LBRACK | LESSER | LESSEREQ | LPAREN | MINUS | MULT | NEQ | OR | PLUS | RBRACK | RPAREN | SEMI | UNDERSCORE | BEGIN | END | FUNCTION | VOID | MAIN | TYPE | ARRAY | OF | INT | FIXEDPT | VAR | IF | THEN | ENDIF | ELSE | WHILE | DO | ENDDO | FOR | TO | BREAK | RETURN | ID | NUMBER | WHITESPACE );";
		}
	}

}
