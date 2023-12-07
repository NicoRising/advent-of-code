import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Day01B {
    public static void main(String[] args) throws FileNotFoundException {
        Scanner input = new Scanner(new File("input.txt"));
        int sum = 0;

        while (input.hasNext()) {
            sum += calculateFuel(input.nextInt() / 3 - 2);
        }

        System.out.println(sum);
    }

    private static int calculateFuel(int mass){
        if (mass <= 0) {
            return 0;
        } else {
            return mass + calculateFuel(mass / 3 - 2);
        }
    }
}
