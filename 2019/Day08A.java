import java.io.*;
import java.util.Scanner;

public class Day08A {
    public static void main(String[] args) throws FileNotFoundException {
        final int WIDTH = 25;
        final int HEIGHT = 6;

        String input = new Scanner(new File("input.txt")).next();

        int[] counts = {0, 0, 0};
        int minZeros = WIDTH * HEIGHT + 1;
        int product = 0;

        for (int idx = 0; idx < input.length(); idx++) {
            counts[input.charAt(idx) - '0']++;

            if ((idx + 1) % (WIDTH * HEIGHT) == 0) {
                if (counts[0] < minZeros) {
                    minZeros = counts[0];
                    product = counts[1] * counts[2];
                }

                counts[0] = 0;
                counts[1] = 0;
                counts[2] = 0;
            }
        }

        System.out.println(product);
    }
}
