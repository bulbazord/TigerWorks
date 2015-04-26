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

    Set<String> nonCondBranches;
    Set<String> conditionalBranches;
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

        Map<Integer, String>  nonCondBranches = new HashMap<Integer, String>();
        Set<Integer> conditionalBranches = new HashSet<Integer>();
        Map<String,Integer> labels = new HashMap<>();

        // sweep the IR code and handle all branches
        for (int i = 0; i < ir.size(); i++) { // i is the current line in the ir code
            Instruction inst = ir.get(i);

            if(inst.isLabel()) {
                labels.put(inst.getLabelName(), new Integer(i));
            } else if (!inst.isEmpty() == 0) {
                if(branches().contains(inst.getOp())) {
                  //@TODO put it in our hashmap 
                } else if(condBranches().contains(inst.getOp())) {
                    //@TODO put it in our hashset
                } else {
                    // we aren't doing anything kek
                }
            }

        }


        Set<Integer> branchDestinations = new HashSet<Integer>();
        // were gonna populate a hashset for branch target addresses
        


        // sweep the IR code again
        // were going to build our basic blocks here

        int start = 0;
        for(int i = 0; i < ir.size(); i++) {
            Integer intobj = new Integer(i);
            if(branchDestinations.contains(intobj)) {
                //is it a destination of a branch? Lets start a new basic block
            } else if (branches().containsKey(intobj)) {
                //lets make a basic block and put it into our ArrayList
            } else if (i == irCode.size()--) {
                // congrats! were at the end of the program, lets put the rest into a basic block
            } else {
                // no need to make a new block yet, so don't do anything
            }
        }



        // Here we populate our edge list of the CFG




        // then we have to make our extended basic blocks at the end

        // WOOT were done with making the CFG!!!!!
    }

    public Boolean isBranch(Instruction inst) {
        if(inst.isLabel() || inst.isEmpty()) {
            return false; // its an empty line or a label
        } else {
            if(branches.contains(inst.getOp) || condBranches.contains(inst.getOp)) {
                return true; // will branch
            }
            return false; 
        }
    }

    public Set<String> branches() {
        branches = new HashSet<>();
        branches.add("goto");
        branches.add("call");
        branches.add("callr");
        branches.add("return");
        return branches;

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
