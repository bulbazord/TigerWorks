import java.io.FileWriter;
import java.io.IOException;
import java.util.LinkedList;
import java.util.List;

public class IRGenerator {

    // Stores the commands thusfar.
    private List<String> list = new LinkedList<String>();

    private int tempVarCount = 0;
    private int tempLabelCount = 0;

    public String generateLabel() {
        return "L" + tempLabelCount++;
    }

    public String generateTemp() {
        return "t" + tempVarCount++;
    }

    /*public boolean add(String s) {
        return list.add(s);
    }*/

    public boolean addAssignment(String var, String val) {
        return list.add(IRTranslator._assign(var, val));
    }

    public boolean addAssignment(String var, int size, String val) {
        return list.add(IRTranslator._assign(var, size, val));
    }

    public boolean addAddition(String a, String b, String c) {
        return list.add(IRTranslator._add(a, b, c));
    }
    
    public boolean addSubtraction(String a, String b, String c) {
        return list.add(IRTranslator._sub(a, b, c));
    }

    public boolean addMultiplication(String a, String b, String c) {
        return list.add(IRTranslator._mult(a, b, c));
    }

    public boolean addDivision(String a, String b, String c) {
        return list.add(IRTranslator._div(a, b, c));
    }

    public boolean addAnd(String a, String b, String c) {
        return list.add(IRTranslator._and(a, b, c));
    }

    public boolean addOr(String a, String b, String c) {
        return list.add(IRTranslator._or(a, b, c));
    }

    public boolean addGoto(String label) {
        return list.add(IRTranslator._goto(label));
    }

    public boolean addBREQ(String a, String b, String label) {
        return list.add(IRTranslator._breq(a, b, label));
    }

    public boolean addBRNEQ(String a, String b, String label) {
        return list.add(IRTranslator._brneq(a, b, label));
    }

    public boolean addBRLT(String a, String b, String label) {
        return list.add(IRTranslator._brlt(a, b, label));
    }

    public boolean addBRLEQ(String a, String b, String label) {
        return list.add(IRTranslator._brleq(a, b, label));
    }

    public boolean addBRGT(String a, String b, String label) {
        return list.add(IRTranslator._brgt(a, b, label));
    }

    public boolean addBRGEQ(String a, String b, String label) {
        return list.add(IRTranslator._brgeq(a, b, label));
    }

    public boolean addReturn(String val) {
        return list.add(IRTranslator._return(val));
    }

    public boolean addCall(String func, String[] params) {
        return list.add(IRTranslator._call(func, params));
    }

    public boolean addCallr(String a, String func, String[] params) {
        return list.add(IRTranslator._callr(a, func, params));
    }

    public boolean addArrayStore(String arr, int i, String val) {
        return list.add(IRTranslator._array_store(arr, i, val));
    }

    public boolean addArrayLoad(String a, String arr, int i) {
        return list.add(IRTranslator._array_load(a, arr, i));
    }

    public boolean addLabel(String name) {
        return list.add(IRTranslator._label(name));
    }

    public boolean addFunctionDeclaration(String ident) {
        return list.add(IRTranslator._label(ident));
    }




     /**
     * A function which takes the code we've made so far and writes it
     * to an output file.
     *
     * @param fileName The name of the file to write to.
     * @return A boolean for whether the write succeeded or not.
     */
     public boolean writeToFile(String fileName) {
         try {
             FileWriter writer = new FileWriter(fileName);
             for (String s: list) {
                 System.out.println(s);
                 writer.write(s + "\n");
             }
             writer.close();
         } catch (IOException e) {
             System.out.println("ERROR: Could not write IR to file " + fileName);
             return false;
         }
         return true;
     }
}
