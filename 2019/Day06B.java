import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Scanner;

public class Day06B {
    public static void main(String[] args) throws FileNotFoundException {
        Scanner input = new Scanner(new File("input.txt"));
        HashMap<String, String> reverseOrbitals = new HashMap<>();
        while (input.hasNext()) {
            String orbital = input.next();
            String parent = orbital.substring(0,orbital.indexOf(')'));
            String satallite = orbital.substring(orbital.indexOf(')') + 1);
            reverseOrbitals.put(satallite, parent);
        }
        ArrayList<String> youPath = new ArrayList<>();
        ArrayList<String> santaPath = new ArrayList<>();
        youPath.add(reverseOrbitals.get("YOU"));
        santaPath.add(reverseOrbitals.get("SAN"));
        while (!santaPath.contains(youPath.get(youPath.size() - 1))) {
            youPath.add(reverseOrbitals.get(youPath.get(youPath.size() - 1)));
            santaPath.add(reverseOrbitals.get(santaPath.get(santaPath.size() - 1)));
        }
        System.out.println(youPath.size() + santaPath.indexOf(youPath.get(youPath.size() - 1)) - 1);
    }
}