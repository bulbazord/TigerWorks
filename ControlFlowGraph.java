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

    Set<String> allBranches;
    Set<String> conditionalBranches;
    ArrayList<BasicBlock> basicBlocks;
    ArrayList<ExtendedBasicBlock> ebbs;
    Set<Edge> edges;


    private class Edge {
         int src;
         int dst;

        public Edge(int src, int dst) {
            this.src = src;
            this.dst = dst;
            }

        public boolean equals(Object other) { // comapres Edges to see if they are the same.

            if(other == null || !(other instanceof Edge)) {
                return false;

            } else if ( ((Edge) other).src == src && ((Edge) other).dst == dst) {
                return true;
                
            } else {
                return false;
            }

            }
        }

    private class ExtendedBasicBlock {
        private ArrayList<BasicBlock> blocks;

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
        basicBlocks = new ArrayList<BasicBlock>();
        ebbs = new ArrayList<ExtendedBasicBlock>();
        edges = new HashSet<>();

        Map<Integer, String>  allBranches = new HashMap<Integer, String>();
        Set<Integer> conditionalBranches = new HashSet<Integer>();
        Map<String,Integer> labels = new HashMap<>();
        String target;

        // sweep the IR code and handle all branches
        for (int i = 0; i < ir.size(); i++) { // i is the current line in the ir code
            Instruction inst = ir.get(i);

            if(inst.isLabel()) {
                labels.put(inst.getName(), new Integer(i));
            } else if (!inst.isEmpty()) {
                if(branches().contains(inst.getOp())) {
                    target = getTarget(inst);
                    allBranches.put(new Integer(i), target);
                } else if(condBranches().contains(inst.getOp())) {
                    target = getTarget(inst);
                    allBranches.put(new Integer(i), target);
                    conditionalBranches.add(new Integer(i));
                }
            }
        }



        // set of branch target addresses
        Set<Integer> branchDestinations = new HashSet<Integer>();
        Iterator branchIterator = allBranches.entrySet().iterator();

        while(branchIterator.hasNext()) {
            Map.Entry mapping = (Map.Entry) branchIterator.next();

            String lab = (String) mapping.getValue();

            if(lab != null) {
                Integer line = labels.get(lab);
                if (line == null) {
                    // break to label that is not there.
                }

                branchDestinations.add(line); // add the adress of the label jumping to
            }
        }
        // were gonna populate a hashset for branch target addresses
        


        // sweep the IR code again
        // were going to build our basic blocks here

        int start = 0;
        for(int i = 0; i < ir.size(); i++) {
            Integer intobj = new Integer(i);
            if(branchDestinations.contains(intobj)) {
                if(start != i) {
                    // make block and insert it into the CFG
                    List<Instruction> blockCode = ir.subList(start, i);
                    BasicBlock block = new BasicBlock(start, blockCode);
                    basicBlocks.add(block); 
                }
                //is it a destination of a branch? Lets start a new basic block
            } else if (allBranches.containsKey(intobj)) {
                // are we branching away? make a block
                List<Instruction> blockCode = ir.subList(start, i+1);
                BasicBlock block = new BasicBlock(start, blockCode);
                basicBlocks.add(block);
            } else if (i == ir.size() - 1) {
                // congrats! were at the end of the program, lets put the rest into a basic block
                List<Instruction> blockCode = ir.subList(start, i+1);
                BasicBlock block = new BasicBlock(start, blockCode);
                basicBlocks.add(block);
            } else {
                // no need to make a new block yet, so don't do anything here :)
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
            if(allBranches.contains(inst.getOp()) || conditionalBranches.contains(inst.getOp())) {
                return true; // will branch
            }
            return false; 
        }
    }

    public Set<String> branches() {
        Set<String> br = new HashSet<>();
        br.add("goto");
        br.add("call");
        br.add("callr");
        br.add("return");
        return br;

    }

    public Set<String> condBranches() {
        Set<String> cb = new HashSet<>();
        cb.add("breq");
        cb.add("brneq");
        cb.add("brlt");
        cb.add("brgep");
        cb.add("brleq");

        return cb;  
    }

    // grabs target address for label
    public String getTarget(Instruction inst) {
        if(inst.getOp() == "return") {
            return null;
        } else if(inst.getOp() == "call") {
            return inst.getParam(1);
        } else if (inst.getOp() == "callr") {
            return inst.getParam(2);
        } else if(inst.getOp() == "goto") {
            return inst.getDstReg();
        } else {
            return inst.getSrcTwo();
        }
    }

    // consolidate basic blocks into an extended basic block
    public ExtendedBasicBlock generateEbb(BasicBlock start, Set<BasicBlock> others) {
      //  ArrayList<BasicBlock> blocks = basicBlocks.get(edge.dst);
        return null;
    }
}
