import java.awt.Point;
import java.io.File;
import java.io.FileNotFoundException;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Scanner;

public class Day10B {
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
        Point station = null;
        HashMap<Point, ArrayList<Point>> neighbors = null;
        for (int x = 0; x < WIDTH; x++) {
            for (int y = 0;y < WIDTH;y++) {
                if (grid[x][y] == 1) {
                    HashMap<Point, ArrayList<Point>>  testNeighbors = buildNeighbors(WIDTH, new Point(x, y));
                    int count = 0;
                    for (Point neighbor: testNeighbors.keySet()) {
                        for (Point check: testNeighbors.get(neighbor)) {
                            if (grid[check.x][check.y] == 1) {
                                count++;
                                break;
                            }
                        }
                    }
                    if (count > max) {
                        max = count;
                        station = new Point(x, y);
                        neighbors = testNeighbors;
                    }
                }
            }
        }
        ArrayList<Point> right = new ArrayList<>();
        ArrayList<Point> left = new ArrayList<>();
        for (Point reduced : neighbors.keySet()) {
            if (reduced.x > 0||reduced.x == 0&&reduced.y < 0) {
                right.add(reduced);
            } else {
                left.add(reduced);
            }
        }
        Point[] rightOrder = new Point[right.size()];
        Point[] leftOrder = new Point[left.size()];
        for (int index = 0; index < rightOrder.length; index++) {
            double min = Math.atan((double)right.get(0).y / right.get(0).x);
            int minIndex = 0;
            for (int check = 1; check < right.size(); check++) {
                if (Math.atan((double)right.get(check).y / right.get(check).x) < min) {
                    min = Math.atan((double)right.get(check).y / right.get(check).x);
                    minIndex = check;
                }
            }
            rightOrder[index] = right.get(minIndex);
            right.remove(minIndex);
        }
        for (int index = 0; index < leftOrder.length; index++) {
            if (left.contains(new Point(0, 1))) {
                leftOrder[index] = new Point(0, 1);
                left.remove(new Point(0, 1));
            } else {
                double min = Math.atan((double)left.get(0).y / left.get(0).x);
                int minIndex = 0;
                for (int check = 1; check < left.size(); check++) {
                    if (Math.atan((double)left.get(check).y / left.get(check).x) < min) {
                        min = Math.atan((double)left.get(check).y / left.get(check).x);
                        minIndex = check;
                    }
                }
                leftOrder[index] = left.get(minIndex);
                left.remove(minIndex);
            }
        }
        Point[] order = new Point[rightOrder.length + leftOrder.length];
        for (int index = 0; index < rightOrder.length; index++) {
            order[index] = rightOrder[index];
        }
        for (int index = 0; index < leftOrder.length; index++) {
            order[index + rightOrder.length] = leftOrder[index];
        }
        Point zapped = new Point();
        int tick = 0;
        for (int asteroid = 0; asteroid < 200;) {
            Point relative = order[tick++ % order.length];
            Point test = new Point(station.x + relative.x, station.y + relative.y);
            while (test.x >= 0 && test.y >= 0 && test.x < WIDTH && test.y < WIDTH) {
                if (grid[test.x][test.y] == 1) {
                grid[test.x][test.y] = 0;
                zapped.move(test.x, test.y);
                asteroid++;
                break;
                }
                test.translate(relative.x,relative.y);
            }
        }
        System.out.println(zapped.x * 100 + zapped.y);
    }

    public static HashMap<Point, ArrayList<Point>>  buildNeighbors(final int WIDTH, Point station) {
        HashMap<Point, ArrayList<Point>> neighbors = new HashMap<>();
        for (int x = 0; x < WIDTH; x++) {
            for (int y = 0; y < WIDTH; y++) {
                Point relative = new Point(x - station.x, y - station.y);
                if (relative.x != 0 || relative.y != 0) {
                    int gcd = BigInteger.valueOf(relative.x).gcd(BigInteger.valueOf(relative.y)).intValue();
                    Point reduced = new Point(relative.x / gcd, relative.y / gcd);
                    if (!neighbors.containsKey(reduced)) {
                        neighbors.put(reduced, new ArrayList<Point>());
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
                if (grid[index][line] == 0) {
                    out += '.';
                } else {
                    out += '#';
                }
            }
            System.out.println(out);
        }
    }
}