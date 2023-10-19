import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Day08B {
    public static void main(String[] args) throws FileNotFoundException {
        final int WIDTH = 25;
        final int HEIGHT = 6;
        String input = new Scanner(new File("input.txt")).next();
        int[][][] layers = new int[input.length() / WIDTH / HEIGHT][HEIGHT][WIDTH];
        for (int layer = 0; layer < layers.length; layer++) {
            int count = 0;
            for (int row = 0; row < HEIGHT; row++) {
                for (int col = 0; col < WIDTH; col++) {
                    layers[layer][row][col] = Integer.parseInt(input.charAt(layer * WIDTH * HEIGHT + row * WIDTH + col) + "");
                    count += layers[layer][row][col] == 0 ? 1 : 0;
                }
            }
        }
        int[][] image = new int[HEIGHT][WIDTH];
        for (int row = 0; row < HEIGHT; row++) {
            for (int col = 0; col < WIDTH; col++) {
                for (int[][] layer: layers) {
                    if (layer[row][col] == 0 || layer[row][col] == 1) {
                        image[row][col] = layer[row][col];
                        break;
                    }
                }
            }
        }
        display(image); // TODO: Use OCR to convert image into a proper AoC output to keep every day consistent :P
    }

    public static void display(int[][] image) {
        for (int row = 0; row < image.length; row++) {
            String line = "";
            for (int col = 0; col < image[row].length; col++) {
                switch (image[row][col]) {
                    case 0:
                        line += ' ';
                        break;
                    case 1:
                        line += '#';
                        break;
                    default:
                        line += 'O';
                }
            }
            System.out.println(line);
        }
    }
}