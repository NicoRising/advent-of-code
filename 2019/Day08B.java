import java.io.*;
import java.util.Scanner;

public class Day08B {
    public static void main(String[] args) throws FileNotFoundException {
        final int WIDTH = 25;
        final int HEIGHT = 6;

        String input = new Scanner(new File("input.txt")).next();
        String image = "";

        for (int row = 0; row < HEIGHT; row++) {
            for (int col = 0; col < WIDTH; col++) {
                int idx = row * WIDTH + col;

                while (input.charAt(idx) == '2') {
                    idx += WIDTH * HEIGHT;
                }

                if (input.charAt(idx) == '0') {
                    image += ' ';
                } else {
                    image += '#';
                }
            }

            image += '\n';
        }

        System.out.print(image);
    }
}
