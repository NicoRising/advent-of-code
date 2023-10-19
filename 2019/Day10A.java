import java.awt.Point;
import java.io.File;
import java.io.FileNotFoundException;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Scanner;

public class Day10A {
    public static void main(String[] args) throws FileNotFoundException {
        final int WIDTH;
        Scanner input = new Scanner(new File("input.txt"));
        ArrayList<String> lines = new ArrayList<>();
        while (input.hasNext()) {
            lines.add(input.next());
        }
        WIDTH = lines.size();
        int[][] grid = new int[WIDTH][WIDTH];
        for (int line = 0; line < WIDTH; line++) {
            for (int index = 0; index < WIDTH; index++) {
                if (lines.get(line).charAt(index) == '.') {
                    grid[index][line] = 0;
                } else {
                    grid[index][line] = 1;
                }
            }
        }
        int max = 0;
        for (int x = 0; x < WIDTH; x++) {
            for (int y = 0; y < WIDTH; y++) {
                if (grid[x][y] == 1) {
                HashMap<Point, ArrayList<Point> >  neighbors = buildNeighbors(WIDTH, new Point(x, y));
                int count = 0;
                for (Point neighbor : neighbors.keySet()) {
                    for (Point check : neighbors.get(neighbor)) {
                        if (grid[check.x][check.y] == 1) {
                            count++;
                            break;
                        }
                    }
                }
                max = count > max ? count : max;
                }
            }
        }
        System.out.println(max);
    }

    public static HashMap<Point, ArrayList<Point> >  buildNeighbors(final int WIDTH, Point station) {
        HashMap<Point, ArrayList<Point>> neighbors = new HashMap<>();
        for (int x = 0; x < WIDTH; x++) {
            for (int y = 0; y < WIDTH; y++) {
                Point relative = new Point(x - station.x, y - station.y);
                if (relative.x != 0||relative.y != 0) {
                    int gcd = BigInteger.valueOf(relative.x).gcd(BigInteger.valueOf(relative.y)).intValue();
                    Point reduced = new Point(relative.x / gcd, relative.y / gcd);
                    if (!neighbors.containsKey(reduced)) {
                        neighbors.put(reduced,  new ArrayList<Point>());
                    }
                    relative.translate(station.x, station.y);
                    neighbors.get(reduced).add(relative);
                }
            }
        }
        return neighbors;
    }
    public static void display(int[][] grid) {
        for (int line = 0; line < grid.length; line++) {
            String out = "";
            for (int index = 0; index < grid[line].length; index++) {
                if (grid[line][index] == 0) {
                    out += '.';
                } else {
                    out += '#';
                }
            }
            System.out.println(out);
        }
    }
}