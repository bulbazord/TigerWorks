package CodeGeneration;

import java.util.ArrayList;
import java.util.List;

/**
 * A class to represent one line of an IR expression.
 */
public class IRInstruction {
    private String string;
    private String type;
    private List<String> parameters = new ArrayList<String>();
    public IRInstruction (String instruction) {
        string = instruction;
        String[] params = instruction.split(",");

        if (params.length > 0) {
            type = params[0];
            for (int i = 1; i < params.length; i++) {
                parameters.add(params[i]);
            }
        }
    }

    public List<String> getParams () {
        return parameters;
    }

    public String getType () {
        return type;
    }

    public String toString () {
        return string;
    }
}
