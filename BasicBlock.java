import java.util.ArrayList;

public class BasicBlock {

    private ArrayList<String> instructions; // holds all the instructions
    private int firstLineNum;
    
    // constructor
    public BasicBlock(int start, ArrayList<Instruction> ir) {
        instructions = ir;
        this.start = firstLineNum;
    }
    
    // retrieves all instructions from the BasicBlock
    public ArrayList<String> getInstructions() {
        return instructions;
    }
    
    // first index that this block begins with
    public int getFirstLineNum() {
        return firstLineNum;
    }


    //@TODO Add more to the basic block as needed
}
