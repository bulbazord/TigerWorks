package CodeGeneration;

import java.io.*;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

/**
 * A class which takes in an IR filename and returns a MIPS assembly file.
 */
public class CodeGenerator {
    private List<IRInstruction> ir = new LinkedList<IRInstruction>();
    private List<String> mips = new LinkedList<String>();
    private Map<String, String> data = new HashMap<String, String>();
    private static final String DEFAULT_DESTINATION = "tiger.asm";

    public void generate (String filename) {
        generate(filename, DEFAULT_DESTINATION);
    }

    public void generate (String filename, String destinationFile) {
        try {
            BufferedReader br = new BufferedReader(new FileReader(filename));
            String line = br.readLine();

            while (line != null) {
                line = line.trim();
                if (line.length() > 0) {
                    ir.add(new IRInstruction(line));
                }
                line = br.readLine();
            }

            br.close();
        } catch (FileNotFoundException e) {
            System.out.println("File " + filename + " does not exist. ");
        } catch (IOException e) {
            System.out.println("Error reading file. ");
        }

        IRtoMIPs();
        writeMIPS(destinationFile);
    }

    private boolean writeMIPS (String destination) {
        try {
            FileWriter writer = new FileWriter(destination);
            writer.write(".data\n");
            writer.write(".text\n");

            for (String key : data.keySet()) {
                writer.write(data.get(key) + "\n");
            }
            for (String m : mips) {
                writer.write(m + "\n");
            }
            writer.write("jr $ra\n");
            writer.close();
        } catch (IOException e) {
            System.out.println("ERROR: Could not write MIPS to file " + destination);
            return false;
        }
        return true;
    }

    private void IRtoMIPs () {
        for (IRInstruction instruction : ir) {
            List<String> mipsInstructions = MIPSTranslator.IRtoMIPS(instruction, data);
            mips.addAll(mipsInstructions);
        }
    }
}
