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
    private static final String BEQ = "beq $s, $t, $offset";
    private static final String BGEZ = "bgez $s, $offset"; // Branch on greater than or equal to zero
    private static final String BGTZ = "bgtz $s, $offset"; // Branch on greater than zero
    private static final String BLEZ = "blez $s, $offset"; // Branch on less than or equal to zero
    private static final String BLTZ = "bltz $s, $offset"; // Branch on less than zero
    private static final String BNE = "bne $s, $offset"; // Branch on not equal
    private static final String DIV = "div $s, $t";
    private static final String J = "j $target"; // jump
    private static final String JR = "jr $target"; // jump to register
    
    public static List<String> IRtoMIPS (IRInstruction ir) {
        List<String> result = new LinkedList<String>();
        List<String> params = ir.getParams();
        if (ir.getType().equals("assign")) {
            // How to handle assign
            if (params.size() > 2) {
                // This is array assign: assign, $var, $size, $val,
            } else {
                // Normal variable assign: assign, $var, $val,
            }
        } else if (ir.getType().equals("array_load")) {
            String a = params.get(0);
            String arr = params.get(1);
            String i = params.get(2);
        } else if (ir.getType().equals("array_store")) {
            String arr = params.get(0);
            String i = params.get(1);
            String val = params.get(2);
        } else if (ir.getType().equals("call")) {
            String func = params.get(0);
            // Params are everything else in the list
        } else if (ir.getType().equals("return")) {
            String val = params.get(0);
        } else if (ir.getType().equals("brleq")) {
            String a = params.get(0);
            String b = params.get(1);
            String label = params.get(2);
        } else if (ir.getType().equals("brgeq")) {
            String a = params.get(0);
            String b = params.get(1);
            String label = params.get(2);
        } else if (ir.getType().equals("brgt")) {
            String a = params.get(0);
            String b = params.get(1);
            String label = params.get(2);
        } else if (ir.getType().equals("brlt")) {
            String a = params.get(0);
            String b = params.get(1);
            String label = params.get(2);
        } else if (ir.getType().equals("brneq")) {
            String a = params.get(0);
            String b = params.get(1);
            String label = params.get(2);
        } else if (ir.getType().equals("breq")) {
            String a = params.get(0);
            String b = params.get(1);
            String label = params.get(2);
        } else if (ir.getType().equals("goto")) {
            String label = params.get(0);

            result.add(_j(label));
        } else if (ir.getType().equals("or")) {
            String a = params.get(0);
            String b = params.get(1);
            String c = params.get(2);

            try {
                Integer.parseInt(b);
                //result.add(_addi(c, a, b));
            } catch (NumberFormatException e) {
                // result.add(_add(c, a, b));
            }
        } else if (ir.getType().equals("and")) {
            String a = params.get(0);
            String b = params.get(1);
            String c = params.get(2);

            try {
                Integer.parseInt(b);
                //result.add(_addi(c, a, b));
            } catch (NumberFormatException e) {
                // result.add(_add(c, a, b));
            }
        } else if (ir.getType().equals("sub")) {
            String a = params.get(0);
            String b = params.get(1);
            String c = params.get(2);

            try {
                Integer.parseInt(b);
                //result.add(_addi(c, a, b));
            } catch (NumberFormatException e) {
                // result.add(_add(c, a, b));
            }
        } else if (ir.getType().equals("div")) {
            String a = params.get(0);
            String b = params.get(1);
            String c = params.get(2);

            try {
                Integer.parseInt(b);
                //result.add(_addi(c, a, b));
            } catch (NumberFormatException e) {
                // result.add(_add(c, a, b));
            }
        } else if (ir.getType().equals("mult")) {
            String a = params.get(0);
            String b = params.get(1);
            String c = params.get(2);

            try {
                Integer.parseInt(b);
                //result.add(_addi(c, a, b));
            } catch (NumberFormatException e) {
                // result.add(_add(c, a, b));
            }
        } else if (ir.getType().equals("add") || ir.getType().equals("sub")) {
            String a = params.get(0);
            String b = params.get(1);
            String c = params.get(2);

            try {
                Integer.parseInt(b);
                result.add(_addi(c, a, b));
            } catch (NumberFormatException e) {
                result.add(_add(c, a, b));
            }
        } else if (ir.getType().equals("label")) {
            // Labels are the same in IR and MIPS
            result.add(ir.toString());
        }
        return result;
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
