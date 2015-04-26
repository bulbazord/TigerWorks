import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;
import java.util.Map;
import java.util.Iterator;
import java.util.List;

/*
* This is where the magic happens
* Here we parse the IR Code and generate a control flow graph with basic blocks
* Then we consolidate them into extended basic blocks and use those to perform register
* allocation.
* *WE CANNOT REGISTER ALLOCATE WITHOUT A COMPLETE CFG!!!!
*
*/
public class ControlFlowGraph {

    Set<String> branches;
    Set<String> condBranches
    ArrayList<BasicBlock> basicBlocks;
    ArrayList<ExtendedBasicBlock> ebbs; //@TODO make class ExtenededBasicBlock
    Set<Edge> edges;


    private class Edge {
        public int src;
        public int dst;

        public Edge(int src, int dst) {
            this.src = src;
            this.dst = dst;
            }


        public boolean equals(Object other) { // comapres Edges to see if they are the same.

            if(other == null || !(other instanceof Edge)) {
                return false;

            } else if (other.src == src && other.dst == dst) {
                return true;
                
            } else {
                return false;
            }

            }
        
        }

    private class ExtendedBasicBlock {
        private Arraylist<BasicBlock> blocks;

        ExtendedBasicBlock() {
            blocks = new ArrayList<BasicBlock>();

        }

        ExtendedBasicBlock(ArrayList<BasicBlock> bBlocks) {
            blocks = bBlocks;
        }

        /*
        * @return components of this EBB
        */
        public ArrayList<BasicBlock> getComponents() {
            return blocks;
        }
        
    }


    // set up CFG
    public ControlFlowGraph(ArrayList<Instruction> ir) {
        basicBlocks = new ArrayList<BasicBlock();
        ebbs = new ArrayList<ExtendedBasicBlock>();
        edges = new HashSet<>();

        Map<Integer, String>  branches = new HashMap<>();
        Set<Integer> condBranches = new HashSet<>();
        Map<String,Integer> labels = new HashMap<>();

        for (int i = 0; i < ir.size(); i++) { // i is the current line in the ir code
            Instruction inst = ir.get(i);

            if(/*we have a label*/) {
                labels.put(inst.getLabelName(), new Integer(i));
            } else if (/* not an empty line*/) {
                if(){} //@TODO finish later
            }

        }
        
    }

    public Set<String> branches() {
        branches = new HashSet<>();
        branches.add("goto");
        return branches;
        // would add more for function calls but we aren't implementing

    }

    public Set<string> condBranches() {
        condBranches = new HashSet<>();
        condBranches.add("breq");
        condBranches.add("brneq");
        condBranches.add("brlt");
        condBranches.add("brgep");
        condBranches.add("brleq");

        return condBranches;
    }
}
