package CodeGeneration;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.LinkedList;
import java.util.List;

/**
 * A class which takes in an IR filename and returns a MIPS assembly file.
 */
public class CodeGenerator {
    private List<IRInstruction> ir = new LinkedList<IRInstruction>();
    private List<String> mips = new LinkedList<String>();
    private static final String DEFAULT_DESTINATION = "tiger.as";

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

    private void writeMIPS (String destination) {

    }

    private void IRtoMIPs () {
        for (IRInstruction instruction : ir) {

        }
    }
}
