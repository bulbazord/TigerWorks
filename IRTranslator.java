//import jdk.nashorn.internal.objects.NativeUint16Array;

import java.util.HashMap;
import java.util.Map;

/**
 * A class which takes in values and creates the corresponding IR code.
 */
public class IRTranslator {
    private static final String ASSIGN = "assign, $var, $val, ";
    private static final String ARR_ASSIGN = "assign, $var, $size, $val, ";
    private static final String ADD = "add, $a, $b, $c";    // $c = $a + $b
    private static final String SUB = "sub, $a, $b, $c";    // $c = $a - $b
    private static final String MULT = "mult, $a, $b, $c";  // $c = $a * $b
    private static final String DIV = "div, $a, $b, $c";    // $c = $a / $b
    private static final String AND = "and, $a, $b, $c";    // $c = $a & $b
    private static final String OR = "or, $a, $b, $c";      // $c = $a | $b
    private static final String GOTO = "goto, $label, , ";
    private static final String BREQ = "breq, $a, $b, $label"; // goto $label if $a = $b
    private static final String BRNEQ = "brneq, $a, $b, $label";
    private static final String BRLT = "brlt, $a, $b, $label";
    private static final String BRGT = "brgt, $a, $b, $label";
    private static final String BRGEQ = "brgeq, $a, $b, $label";
    private static final String BRLEQ = "brleq, $a, $b, $label";
    private static final String RETURN = "return, $val, , ";
    private static final String CALL = "call, $func, $params";
    private static final String CALLR = "callr, $a, $func, $params";         // $a <- $func($params)
    private static final String ARRAY_STORE = "array_store, $arr, $i, $val"; //$arr[$i] <- $val
    private static final String ARRAY_LOAD = "array_load, $a, $arr, $i";     // $a <- $arr[$i]
    private static final String LABEL = "$name: ";


    public static String _assign (String var, String val) {
        String template = ASSIGN;
        return template.replace("$var", var).replace("$val", val);
    }

    public static String _assign (String var, int size, String val) {
        String template = ARR_ASSIGN;
        return template.replace("$var", var).replace("$val", val).replace("$size", "" + size);
    }

    public static String _add (String a, String b, String c) {
        String template = ADD;
        return template.replace("$a", a).replace("$b", b).replace("$c", c);
    }

    public static String _sub (String a, String b, String c) {
        String template = SUB;
        return template.replace("$a", a).replace("$b", b).replace("$c", c);
    }

    public static String _mult (String a, String b, String c) {
        String template = MULT;
        return template.replace("$a", a).replace("$b", b).replace("$c", c);
    }

    public static String _div (String a, String b, String c) {
        String template = DIV;
        return template.replace("$a", a).replace("$b", b).replace("$c", c);
    }

    public static String _and (String a, String b, String c) {
        String template = AND;
        return template.replace("$a", a).replace("$b", b).replace("$c", c);
    }

    public static String _or (String a, String b, String c) {
        String template = OR;
        return template.replace("$a", a).replace("$b", b).replace("$c", c);
    }

    public static String _goto (String label) {
        String template = GOTO;
        return template.replace("$label", label);
    }

    public static String _breq (String a, String b, String label) {
        String template = BREQ;
        return template.replace("$a", a).replace("$b", b).replace("$label", label);
    }

    public static String _brneq (String a, String b, String label) {
        String template = BRNEQ;
        return template.replace("$a", a).replace("$b", b).replace("$label", label);
    }

    public static String _brlt (String a, String b, String label) {
        String template = BRLT;
        return template.replace("$a", a).replace("$b", b).replace("$label", label);
    }

    public static String _brgt (String a, String b, String label) {
        String template = BRGT;
        return template.replace("$a", a).replace("$b", b).replace("$label", label);
    }

    public static String _brgeq (String a, String b, String label) {
        String template = BRGEQ;
        return template.replace("$a", a).replace("$b", b).replace("$label", label);
    }

    public static String _brleq (String a, String b, String label) {
        String template = BRLEQ;
        return template.replace("$a", a).replace("$b", b).replace("$label", label);
    }

    public static String _return (String val) {
        String template = RETURN;
        return template.replace("$val", val);
    }

    public static String _call (String func, String[] params) {
        String template = CALL;
        return template.replace("$func", func).replace("$params", list(params));
    }

    public static String _callr (String a, String func, String[] params) {
        String template = CALLR;
        return template.replace("$a", a).replace("$func", func).replace("$params", list(params));
    }

    public static String _array_store (String arr, int i, String val) {
        String template = ARRAY_STORE;
        return template.replace("$arr", arr).replace("$i", "" + i).replace("$val", val);
    }

    public static String _array_load (String a, String arr, int i) {
        String template = ARRAY_LOAD;
        return template.replace("$a", a).replace("$arr", arr).replace("$i", "" + i);
    }

    public static String _label(String name) {
        String template = LABEL;
        return template.replace("$name", name);
    }

    private static String list(String[] params) {
        String result = "";

        if (params.length > 0) {
            result += params[0];
            for (int i = 1; i < params.length; i++) {
                result += ", " + params[i];
            }
        }

        return result;
    }
}
