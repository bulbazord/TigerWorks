package CodeGeneration;

import java.io.*;
import java.util.LinkedList;
import java.util.List;

/**
 * A class which takes in an IR filename and returns a MIPS assembly file.
 */
public class CodeGenerator {
    private List<IRInstruction> ir = new LinkedList<IRInstruction>();
    private List<String> mips = new LinkedList<String>();
    private static final String DEFAULT_DESTINATION = "tiger.asm";

    public CodeGenerator (String filename) {
        this(filename, DEFAULT_DESTINATION);
    }

    public CodeGenerator (String filename, String destinationFile) {
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
            for (String m : mips) {
                writer.write(m);
            }
            writer.close();
        } catch (IOException e) {
            System.out.println("ERROR: Could not write MIPS to file " + destination);
            return false;
        }
        return true;
    }

    private void IRtoMIPs () {
        mips.add(".data");
        mips.add(".text");
        for (IRInstruction instruction : ir) {
            List<String> mipsInstructions = MIPSTranslator.IRtoMIPS(instruction);
            mips.addAll(mipsInstructions);
        }
        mips.add("jr $ra");
    }
}
