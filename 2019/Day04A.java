import java.io.*;
import java.util.Scanner;

public class Day04A {
    public static void main(String[] args) throws FileNotFoundException {
        String range[] = new Scanner(new File("input.txt")).next().split("-");

        int min = Integer.parseInt(range[0]);
        int max = Integer.parseInt(range[1]);

        int valid = 0;

        passwordLoop:
        for (int password = min; password <= max; password++) {
            boolean hasDouble = false;

            // Go through the number from right to left
            for (int numIdx = 1; numIdx < 100_000; numIdx *= 10) {
                int num1 = password / numIdx % 10;
                int num2 = password / numIdx / 10 % 10;

                if (num1 == num2) {
                    hasDouble = true;
                } else if (num1 < num2) {
                    continue passwordLoop;
                }
            }

            if (hasDouble) {
                valid += 1;
            }
        }

        System.out.println(valid);
    }
}
