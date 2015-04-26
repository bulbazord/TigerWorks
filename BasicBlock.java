import java.util.ArrayList;

public class BasicBlock {

    ArrayList<String> instructions; // holds all the instructions
    ArrayList<BasicBlock> next; // holds all basic blocks that can follow from this current one, can reference itself if loop.


    public BasicBlock(String firstInstruction) {
        instructions = new ArrayList<String>();
        instructions.add(firstInstruction);
    }

    public void addInstruction(String i) {
        instructions.add(i);
    }

    // retrieves an instruction from the basic block.
    public String getInstruction(int i) {
        instructions.get(i);
    }

}
