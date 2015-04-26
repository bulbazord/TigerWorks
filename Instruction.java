import java.util.ArrayList;
import java.util.Set;
import java.util.Iterator;
import java.util.Map;


/**
*  instruction that represents a line of IR code
*  
*/
public class Instruction {
    
    private ArrayList<String> operationAndParams;
    String name;
    boolean isLabel;


    /* empty line */
    public Instruction() {
        operationAndParams = new ArrayList<String>();
        
    }

    /* is a label */
    public Instruction(String l) {
        name = l;
        isLabel = true;
    }

    /*
    * typical assign statements are of this size
    */
    public Instruction(String oper, String, dst, String src) {
        operationAndParams = new ArrayList<String>();
        operationAndParams.add(oper);
        operationAndParams.add(dst);
        operationAndParams.add(src);
    }


    /*
    * typical goto statement
    */
    public Instruction(String oper, String destAddr) {
        operationAndParams = new ArrayList<String>();
        operationAndParams.add(oper);
        operationAndParams.add(destAddr);
    }


    /*
    * binary operations
    */
    public Instruction(String oper, String dstReg, String srcOne, String srcTwo) {
        operationAndParams = new ArrayList<String>();
        operationAndParams.add(oper);
        operationAndParams.add(dstReg);
        operationAndParams.add(srcOne);
        operationAndParams.add(srcTwo);
    }

    /*
    * function call with no retval
    * op is "call"
    */
    public Instruction(String oper, String funcName, ArrayList<String> paramList) {
        operationAndParams = new ArrayList<String>();
        operationAndParams.add(oper);
        operationAndParams.add(funcName);
        for (int i = 0; i <  paramList.size(); i++) {
            operationAndParams.add(paramList.get(i))
        }

    /*
    * function call with returns
    * op is "callr"
    */
    public Instruction(String oper, String dstReg, String funcName, ArrayList<String> paramList) {
        operationAndParams = new ArrayList<String>();
        operationAndParams.add(oper);
        operationAndParams.add(dstReg);
        operationAndParams.add(funcName);
        for (int i = 0; i < paramList.size(); i++) {
            operationAndParams.add(paramList.get(i));
        }
    }

    //@TODO function support (not function call)





    public boolean isEmpty() {
        if(operationAndParams == null && !isLabel) {
            return true;
        } else {
            return false;
        }
    }

    /* @return operation of instruction
    *  anatomy of instruction
    *  [opcode <--- | dstReg | src1 | (src2)? ]
    */
    public String getOp() {
        return operationAndParams.get(0);
    }

    /* @return destination register of instruction
    *  anatomy of instruction
    *  [opcode | dstReg <--- | src1 | (src2)? ]
    */
    public String getDstReg() {
        return operationAndParams.get(1);
    }

    /* @return left source register in instruction
    *  anatomy of instruction
    *  [opcode | dstReg | src1 <--- | (src2)? ]
    */
    public String getSrcOne() {
        return operationAndParams.get(2);
    }

    /*@ return right source register in instruction if present, empty string otherwise.
    *  anatomy of instruction
    *  [opcode | dstReg | src1 | (src2)? <--- ]
    */
    public String getSrcTwo() {
        if (operationAndParams.size() > 3) {
            return operationAndParams.get(3);
        } else {
            return "";
        }
    }

    /*
    * @return label name.
    */
    public String getName() {
        if (isLabel) {
            return name;
        }
        return "";
    }

    



    
}
