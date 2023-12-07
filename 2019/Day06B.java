import java.io.*;
import java.util.*;

public class Day06B {
    public static void main(String[] args) throws FileNotFoundException {
        Scanner input = new Scanner(new File("input.txt"));
        Map<String, String> reverseOrbitals = new HashMap<String, String>();

        while (input.hasNext()) {
            String[] bodies = input.next().split("\\)");
            String parent = bodies[0];
            String satallite = bodies[1];

            reverseOrbitals.put(satallite, parent);
        }

        List<String> youPath = new ArrayList<String>();
        List<String> santaPath = new ArrayList<String>();

        Set<String> youVisited = new HashSet<String>();
        Set<String> santaVisited = new HashSet<String>();

        String youNext = "YOU";
        String santaNext = "SAN";

        boolean intersected = false;

        while (!intersected) {
            // If one hits the root, it shouldn't matter since get() will just return null
            youNext = reverseOrbitals.get(youNext);
            santaNext = reverseOrbitals.get(santaNext);

            youPath.add(youNext);
            santaPath.add(santaNext);

            youVisited.add(youNext);
            santaVisited.add(santaNext);

            intersected = santaVisited.contains(youNext);

        }

        int transfers;

        if (santaVisited.contains(youNext)) {
            transfers = youPath.size() + santaPath.indexOf(youNext) - 1;
        } else {
            transfers = santaPath.size() + youPath.indexOf(santaNext) - 1;
        }

        System.out.println(transfers);
    }
}
