import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Scanner;

public class Day06A {
    public static void main(String[] args) throws FileNotFoundException {
        Scanner input = new Scanner(new File("input.txt"));
        HashMap<String, ArrayList<String>> orbitals = new HashMap<>();
        while (input.hasNext()) {
            String orbital = input.next();
            String parent = orbital.substring(0, orbital.indexOf(')'));
            String satallite = orbital.substring(orbital.indexOf(')') + 1);
            if (!orbitals.containsKey(parent)) {
                orbitals.put(parent,new ArrayList<String>());
            }
            orbitals.get(parent).add(satallite);
        }
        System.out.println(countIndirect(orbitals, "COM", 0));
    }

    public static int countIndirect(HashMap<String, ArrayList<String>> orbitals, String current, int depth) {
        int count = depth;
        if (orbitals.containsKey(current)) {
            for (String satallite: orbitals.get(current)){
                count += countIndirect(orbitals, satallite, depth + 1);
            }
        }
        return count;
    }
}