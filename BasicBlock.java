import java.util.ArrayList;

public class BasicBlock {

    private ArrayList<String> instructions; // holds all the instructions
    private int firstLineNum;


    public BasicBlock(int start, ArrayList<Instruction> ir) {
        instructions = ir;
        this.start = firstLineNum;
    }

    public ArrayList getInstructions() {
        return instructions;
    }

    public int getFirstLineNum() {
        return firstLineNum;
    }


    //@TODO Add more to the basic block as needed
}
