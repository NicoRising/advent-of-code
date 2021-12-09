import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Day08A {
    public static void main(String[] args) throws FileNotFoundException {
        final int WIDTH = 25;
        final int HEIGHT = 6;
        String input = new Scanner(new File("input.txt")).next();
        int[][][] layers = new int[input.length() / WIDTH / HEIGHT][HEIGHT][WIDTH];
        int min = 0;
        int minLayer = 0;
        for (int layer = 0; layer < layers.length; layer++) {
            int count = 0;
            for (int row = 0; row < HEIGHT; row++) {
                for (int col = 0; col < WIDTH; col++) {
                layers[layer][row][col] = Integer.parseInt(input.charAt(layer * WIDTH * HEIGHT + row * WIDTH + col) + "");
                count += layers[layer][row][col] == 0 ? 1 : 0;
                }
            }
            if (count < min||min == 0) {
                min = count;
                minLayer = layer;
            }
        }
        int oneCount = 0;
        int twoCount = 0;
        for (int row = 0; row < HEIGHT; row++) {
            for (int col = 0; col < WIDTH; col++) {
                oneCount += layers[minLayer][row][col] == 1 ? 1 : 0;
                twoCount += layers[minLayer][row][col] == 2 ? 1 : 0;
            }
        }
        System.out.println(oneCount * twoCount);
    }
}