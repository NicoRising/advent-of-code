import java.io.*;
import java.util.*;

public class Day10A {
    public static void main(String[] args) throws FileNotFoundException {
        final int WIDTH;

        Scanner input = new Scanner(new File("input.txt"));
        String line = input.next();
        WIDTH = line.length();

        boolean[][] field = new boolean[WIDTH][WIDTH];

        for (int row = 0; row < WIDTH; row++) {
            for (int col = 0; col < WIDTH; col++) {
                if (line.charAt(col) == '#') {
                    field[row][col] = true;
                }
            }

            if (input.hasNext()) {
                line = input.next();
            }
        }

        int maxVisible = 0;

        for (int row = 0; row < WIDTH; row++) {
            for (int col = 0; col < WIDTH; col++) {
                if (field[row][col]) {
                    int visible = calcVisible(row, col, field);
                    maxVisible = visible > maxVisible? visible : maxVisible;
                }
            }
        }

        System.out.println(maxVisible);
    }

    private static int calcVisible(int stationRow, int stationCol, boolean[][] field) {
        Set<Double> usedRatios = new HashSet<Double>();
        int visible = 0;

        for (int row = 0; row < field.length; row++) {
            for (int col = 0; col < field[row].length; col++) {
                if (row == stationRow && col == stationCol) {
                    // Reset the used ratios so angles opposite used angles can be used
                    usedRatios.clear();
                } else if (field[row][col]) {
                    double ratio = (double)(row - stationRow) / (col - stationCol);

                    if (!usedRatios.contains(ratio)) {
                        usedRatios.add(ratio);
                        visible++;
                    }

                }
            }
        }

        return visible;
    }
}
