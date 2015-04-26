import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;
import java.util.Map;
import java.util.Iterator;
import java.util.List;


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


    // set up CFG
    public ControlFlowGraph(BasicBlock[] b) {
        basicBlocks = new ArrayList<BasicBlock();
        ebbs = new ArrayList<ExtendedBasicBlock>();
        edges = new HashSet<>();

        Map<Integer, String> 
        
    }
