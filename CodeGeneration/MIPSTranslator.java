package CodeGeneration;

import java.util.LinkedList;
import java.util.List;

/**
 * Represents a MIPS Instruction
 */
public class MIPSTranslator {
    private static final String ADD = "add $d, $s, $t"; // $d = $s + $t
    private static final String ADDI = "addi $d, $s, $imm";
    private static final String AND = "and $d, $s, $t";
    private static final String ANDI = "and $d, $s, $imm";
    private static final String OR = "or $d, $s, $t";
    private static final String ORI = "ori $d, $s, $imm";
    private static final String BEQ = "beq $s, $t, $offset";
    private static final String BGEZ = "bgez $s, $offset"; // Branch on greater than or equal to zero
    private static final String BGTZ = "bgtz $s, $offset"; // Branch on greater than zero
    private static final String BLEZ = "blez $s, $offset"; // Branch on less than or equal to zero
    private static final String BLTZ = "bltz $s, $offset"; // Branch on less than zero
    private static final String BNE = "bne $s, $offset"; // Branch on not equal
    private static final String DIV = "div $s, $t";
    private static final String MULT = "mult $s, $t";
    private static final String J = "j $target"; // jump
    private static final String JR = "jr $target"; // jump to register
    private static final String LW = "lw $t, $offset($s)"; //load byte
    private static final String SW = "sw $t, $offset($s)"; // MEM[$s + offset] = $t

    public static List<String> IRtoMIPS (IRInstruction ir) {
        List<String> result = new LinkedList<String>();
        List<String> params = ir.getParams();
        String a, b, c, label, i, val, arr;
        switch (ir.getType()) {
            case "load": // Loads a into val
                a = params.get(0);
                val = params.get(1);
                break;
            case "store": // Stores val into a
                val = params.get(0);
                a = params.get(1);
                break;
            case "assign":
                // How to handle assign
                if (params.size() > 2) {
                    // This is array assign: assign, $var, $size, $val,
                } else {
                    // Normal variable assign: assign, $var, $val,
                }
                break;
            case "array_load":
                a = params.get(0);
                arr = params.get(1);
                i = params.get(2);
                break;
            case "array_store":
                arr = params.get(0);
                i = params.get(1);
                val = params.get(2);
                break;
            case "call":
                // Not doing this
                break;
            case "return":
                val = params.get(0);
                break;
            case "brleq":
                a = params.get(0);
                b = params.get(1);
                label = params.get(2);
                break;
            case "brgeq":
                a = params.get(0);
                b = params.get(1);
                label = params.get(2);
                break;
            case "brgt":
                a = params.get(0);
                b = params.get(1);
                label = params.get(2);
                break;
            case "brlt":
                a = params.get(0);
                b = params.get(1);
                label = params.get(2);
                break;
            case "brneq":
                a = params.get(0);
                b = params.get(1);
                label = params.get(2);
                break;
            case "breq":
                a = params.get(0);
                b = params.get(1);
                label = params.get(2);
                break;
            case "goto":
                label = params.get(0);
                result.add(_j(label));
                break;
            case "or":
                a = params.get(0);
                b = params.get(1);
                c = params.get(2);
                try {
                    Integer.parseInt(b);
                    //result.add(_addi(c, a, b));
                } catch (NumberFormatException e) {
                    // result.add(_add(c, a, b));
                }
                break;
            case "and":
                a = params.get(0);
                b = params.get(1);
                c = params.get(2);
                try {
                    Integer.parseInt(b);
                    //result.add(_addi(c, a, b));
                } catch (NumberFormatException e) {
                    // result.add(_add(c, a, b));
                }
                break;
            case "sub":
                a = params.get(0);
                b = params.get(1);
                c = params.get(2);
                try {
                    Integer.parseInt(b);
                    //result.add(_addi(c, a, b));
                } catch (NumberFormatException e) {
                    // result.add(_add(c, a, b));
                }
                break;
            case "div":
                a = params.get(0);
                b = params.get(1);
                c = params.get(2);
                try {
                    Integer.parseInt(b);
                    //result.add(_addi(c, a, b));
                } catch (NumberFormatException e) {
                    // result.add(_add(c, a, b));
                }
                break;
            case "mult":
                a = params.get(0);
                b = params.get(1);
                c = params.get(2);
                try {
                    Integer.parseInt(b);
                    //result.add(_addi(c, a, b));
                } catch (NumberFormatException e) {
                    // result.add(_add(c, a, b));
                }
                break;
            case "add":
                a = params.get(0);
                b = params.get(1);
                c = params.get(2);

                try {
                    Integer.parseInt(b);
                    result.add(_addi(c, a, b));
                } catch (NumberFormatException e) {
                    result.add(_add(c, a, b));
                }
                break;
            case "label":
                result.add(ir.toString());
                break;
        }

        return result;
    }

    public static String _sw (String t, String offset, String s) {
        String template = SW;
        return template.replace("$t", t).replace("$offset", offset).replace("$s", s);
    }

    public static String _lw (String t, String offset, String s) {
        String template = LW;
        return template.replace("$t", t).replace("$offset", offset).replace("$s", s);
    }

    public static String _mult (String s, String t) {
        String template = MULT;
        return template.replace("$s", s).replace("$t", t);
    }

    public static String _or (String d, String s, String imm) {
        String template = OR;
        return template.replace("$d", d).replace("$s", s).replace("$imm", imm);
    }

    public static String _ori (String d, String s, String t) {
        String template = ORI;
        return template.replace("$d", d).replace("$s", s).replace("$t", t);
    }

    public static String _add (String d, String s, String t) {
        String template = ADD;
        return template.replace("$d", d).replace("$s", s).replace("$t", t);
    }

    public static String _addi (String d, String s, String imm) {
        String template = ADDI;
        return template.replace("$d", d).replace("$s", s).replace("$imm", imm);
    }

    public static String _and (String d, String s, String t) {
        String template = AND;
        return template.replace("$d", d).replace("$s", s).replace("$t", t);
    }

    public static String _andi (String d, String s, String imm) {
        String template = ANDI;
        return template.replace("$d", d).replace("$s", s).replace("$imm", imm);
    }

    public static String _beq (String s, String t, String offset) {
        String template = BEQ;
        return template.replace("$s", s).replace("$t", t).replace("$offset", offset);
    }

    public static String _bgez (String s, String offset) {
        String template = BGEZ;
        return template.replace("$s", s).replace("$offset", offset);
    }

    public static String _bgtz (String s, String offset) {
        String template = BGTZ;
        return template.replace("$s", s).replace("$offset", offset);
    }

    public static String _blez (String s, String offset) {
        String template = BLEZ;
        return template.replace("$s", s).replace("$offset", offset);
    }

    public static String _bltz (String s, String offset) {
        String template = BLTZ;
        return template.replace("$s", s).replace("$offset", offset);
    }

    public static String _bne (String s, String offset) {
        String template = BNE;
        return template.replace("$s", s).replace("$offset", offset);
    }

    public static String _div (String s, String t) {
        String template = DIV;
        return template.replace("$s", s).replace("$t", t);
    }

    public static String _j (String target) {
        String template = J;
        return template.replace("$target", target);
    }

    public static String _jr (String target) {
        String template = JR;
        return template.replace("$target", target);
    }
}
