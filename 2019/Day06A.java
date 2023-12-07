import java.io.*;
import java.util.*;

public class Day06A {
    public static void main(String[] args) throws FileNotFoundException {
        Scanner input = new Scanner(new File("input.txt"));
        Map<String, List<String>> orbitals = new HashMap<String, List<String>>();

        while (input.hasNext()) {
            String[] bodies = input.next().split("\\)");
            String parent = bodies[0];
            String satallite = bodies[1];

            if (!orbitals.containsKey(parent)) {
                orbitals.put(parent, new ArrayList<String>());
            }

            orbitals.get(parent).add(satallite);
        }

        System.out.println(countIndirect(orbitals, "COM", 0));
    }

    public static int countIndirect(Map<String, List<String>> orbitals, String current, int distance) {
        int count = distance;

        if (orbitals.containsKey(current)) {
            for (String satallite : orbitals.get(current)){
                count += countIndirect(orbitals, satallite, distance + 1);
            }
        }

        return count;
    }
}
