package CodeGeneration;

import java.util.LinkedList;
import java.util.List;

/**
 * Represents a MIPS Instruction
 */
public class MIPSTranslator {
    private static final String ADD = "add $d, $s, $t";
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
