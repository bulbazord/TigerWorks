import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.io.IOException;
import java.util.ArrayList;


public class NaiveRegisterAllocator {

    private String outFile = "ir2.tigir";
    private ArrayList<String> instructions;

    public NaiveRegisterAllocator() {
        this.instructions = new ArrayList<String>();
    }

    public void _assign(String op, String arg1, String arg2, String arg3) {
        int i = 1;
        // Regular assignment
        if (arg3.equals("")) {
            //Loads
            //If arg2 isn't a number
            if (!arg2.matches("\\d+")) {
                instructions.add("load, " + arg2 + ", " + "$" + i + ", ");
                instructions.add("store, " + "$"+i + ", " + arg1 + ", ");
            } else {
                instructions.add("store, " + arg2 + ", " + arg1 + ", ");
            }
            //Stores
        // Array assignment
        } else {
            //Loads
            instructions.add("load, " + arg2 + ", " + "$" + i + ", ");
            instructions.add("load, " + arg3 + ", " + "$" + (i+1) + ", ");
            //Stores
        }

    }

    public void _binary(String op, String arg1, String arg2, String arg3) {
        int i = 1;
        //Loads here
        if (!arg1.matches("\\d+")) {
            instructions.add("load, " + arg1 + ", " + "$" + i + ", ");
            arg1 = "$"+i;
            i++;
        }

        if (!arg2.matches("\\d+")) {
            instructions.add("load, " + arg2 + ", " + "$" + i + ", ");
            arg2 = "$"+i;
            i++;
        }

        switch(op) {
            case "add": 
            instructions.add("add, " + arg1 + ", " + arg2 + ", " + "$"+i);
            break;

            case "sub": 
            instructions.add("sub, " + arg1 + ", " + arg2 + ", " + "$"+i);
            break;

            case "mult": 
            instructions.add("mult, " + arg1 + ", " + arg2 + ", " + "$"+i);
            break;

            case "div": 
            instructions.add("div, " + arg1 + ", " + arg2 + ", " + "$"+i);
            break;

            case "and": 
            instructions.add("and, " + arg1 + ", " + arg2 + ", " + "$"+i);
            break;

            case "or": 
            instructions.add("or, " + arg1 + ", " + arg2 + ", " + "$"+i);
            break;

            default:
            break;

        }

        //Stores here
        instructions.add("store, " + "$"+i + ", " + arg3 + ", ");
    }

    public void _branch(String op, String arg1, String arg2, String arg3) {
        int i = 1;
        //Loads here
        if (!arg1.matches("\\d+")) {
            instructions.add("load, " + arg1 + ", " + "$" + i + ", ");
            arg1 = "$"+i;
            i++;
        }
        if (!arg2.matches("\\d+")) {
            instructions.add("load, " + arg2 + ", " + "$" + i + ", ");
            arg2 = "$"+i;
            i++;
        }
        //Gen instruction here
        switch(op) {
            case "breq":
            instructions.add("breq, " + arg1 + ", " + arg2 + ", " + arg3);
            break;

            case "brneq":
            instructions.add("brneq, " + arg1 + ", " + arg2 + ", " + arg3);
            break;

            case "brlt":
            instructions.add("brlt, " + arg1 + ", " + arg2 + ", " + arg3);
            break;

            case "brleq":
            instructions.add("brleq, " + arg1 + ", " + arg2 + ", " + arg3);
            break;

            case "brgt":
            instructions.add("brgt, " + arg1 + ", " + arg2 + ", " + arg3);
            break;

            case "brgeq":
            instructions.add("brgeq, " + arg1 + ", " + arg2 + ", " + arg3);
            break;

            default:
            break;
        }
    }

    public void _array(String op, String arg1, String arg2, String arg3) {
        int i = 1;
        if (op.equals("array_load")) {
            if (!arg3.matches("\\d+")) {
                instructions.add("load, " + arg3 + ", " + "$"+i);
                arg3 = "$"+i;
                i++;
            }
            instructions.add("load, " + arg2 + "["+arg3+"]" + ", " + "$"+i + ", ");
            instructions.add("store, " + "$"+i + ", " + arg1 + ", ");
        } else {
            if (!arg3.matches("\\d+")) {
                instructions.add("load, " + arg3 + ", " + "$"+i);
                arg3 = "$"+i;
                i++;
            }
            if (!arg2.matches("\\d+")) {
                instructions.add("load, " + arg2 + ", " + "$"+i);
                arg2 = "$"+i;
                i++;
            }

            instructions.add("store, " + arg3 + ", " + arg1 + "["+arg2+"]"+ ", ");
        }
    }


    public void write() {
        try {
            BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(outFile)));
            for (String i : instructions) {
                writer.write(i);
                writer.newLine();
            }
            writer.close();
        } catch (IOException e) {
            System.out.println("There was an error writing to file");
        }
    }

    public void allocate(String filename) {
        try {
            BufferedReader reader = new BufferedReader(new FileReader(filename));
            String currentLine = "";
            while (!currentLine.contains("#END")) {
                currentLine = reader.readLine();
                String actual = currentLine;
                if (!currentLine.contains("#END") && !currentLine.contains(":")) {
                    String op = currentLine.substring(0, currentLine.indexOf(","));
                    currentLine = currentLine.substring(currentLine.indexOf(","));
                    String[] instr = new String[3];
                    if (!op.equals("call") && !op.equals("callr") && !op.equals("return") && !op.equals("goto")) {
                        for (int i = 0; i < 3; i++) {
                            if (currentLine.startsWith(",")) {
                                currentLine = currentLine.substring(1);
                            }

                            currentLine = currentLine.trim();
                            if (currentLine.contains(",")) {
                                instr[i] = currentLine.substring(0, currentLine.indexOf(","));
                                currentLine = currentLine.substring(currentLine.indexOf(","));
                            } else {
                                instr[i] = currentLine.trim();
                            }
                        }

                        // Handle instructions here
                        if (op.equals("assign")) { 
                            _assign(op, instr[0], instr[1], instr[2]);
                        } else if (op.equals("add") || op.equals("sub") || op.equals("mult") || op.equals("div")) { 
                            _binary(op, instr[0], instr[1], instr[2]); 
                        } else if (op.equals("breq") || op.equals("brneq") || op.equals("brlt") || op.equals("brgt") || op.equals("brgeq") || op.equals("brleq")) {
                            _branch(op, instr[0], instr[1], instr[2]); 
                        } else if (op.equals("array_store") || op.equals("array_load")) {
                            _array(op, instr[0], instr[1], instr[2]); 
                        } else {
                            System.out.println("Unrecognized operation in IR");
                        }
                    } else {
                        instructions.add(actual);
                    }
                } else {
                    instructions.add(actual);
                }
            }
        } catch (IOException e) {
            System.out.println("File could not be read: " + filename);
        }
    }
}
