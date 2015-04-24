import java.io.FileWriter;
import java.io.IOException;
import java.util.LinkedList;
import java.util.List;

public class IRGenerator {

    // Stores the commands thusfar.
    private List<String> list = new LinkedList<String>();

    public boolean addFunctionDeclaration(String ident) {
        return list.add(IRTranslator._label(ident));
    }

    public boolean add(String s) {
        return list.add(s);
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
                 writer.write(s);
             }
             writer.close();
         } catch (IOException e) {
             System.out.println("ERROR: Could not write IR to file " + fileName);
             return false;
         }
         return true;
     }
}
