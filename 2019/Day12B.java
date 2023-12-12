import java.awt.Point;
import java.io.*;
import java.util.*;
import java.util.stream.Collectors;

public class Day12B {
    public static void main(String[] args) throws FileNotFoundException {
        Scanner input = new Scanner(new File("input.txt")).useDelimiter("[^-\\d]+");
        List<Moon> moons = new ArrayList<Moon>();

        while (input.hasNext()) {
            moons.add(new Moon(input.nextInt(), input.nextInt(), input.nextInt()));
        }

        int xRepeat = 0;
        int yRepeat = 0;
        int zRepeat = 0;

        Set<List<Point>> xHistory = new HashSet<List<Point>>();
        Set<List<Point>> yHistory = new HashSet<List<Point>>();
        Set<List<Point>> zHistory = new HashSet<List<Point>>();

        int step = 0;

        while (xRepeat * yRepeat * zRepeat == 0) {
            List<Point> xPoints = new ArrayList<Point>();
            List<Point> yPoints = new ArrayList<Point>();
            List<Point> zPoints = new ArrayList<Point>();

            for (Moon moon : moons) {
                xPoints.add(new Point(moon.x, moon.dx));
                yPoints.add(new Point(moon.y, moon.dy));
                zPoints.add(new Point(moon.z, moon.dz));
            }

            if (xRepeat == 0) {
                if (xHistory.contains(xPoints)) {
                    xRepeat = step;
                } else {
                    xHistory.add(xPoints);
                }
            }

            if (yRepeat == 0) {
                if (yHistory.contains(yPoints)) {
                    yRepeat = step;
                } else {
                    yHistory.add(yPoints);
                }
            }

            if (zRepeat == 0) {
                if (zHistory.contains(zPoints)) {
                    zRepeat = step;
                } else {
                    zHistory.add(zPoints);
                }
            }

            for (Moon moonA : moons) {
                for (Moon moonB : moons) {
                    // A moon applying gravity to itself does nothing
                    moonA.applyGravity(moonB);
                }
            }

            moons.forEach(moon -> moon.applyVelocity());
            step++;
        }

        Map<Integer, Integer> factors = new HashMap<Integer, Integer>();

        for (int num : new int[]{xRepeat, yRepeat, zRepeat}) {
            for (int divisor = 2; divisor <= num; divisor++) {
                int count = 0;

                while (num % divisor == 0) {
                    num /= divisor;
                    count++;
                }

                if (count > 0) {
                    int currPow = factors.getOrDefault(divisor, 0);

                    if (count > currPow) {
                        factors.put(divisor, count);
                    }
                }
            }
        }

        System.out.println(factors.entrySet()
                                  .stream()
                                  .map(entry -> (long)Math.pow(entry.getKey(), entry.getValue()))
                                  .reduce(1L, (acc, num) -> acc * num));
    }

    private static class Moon {
        int x, y, z;
        int dx, dy, dz;

        public Moon(int x, int y, int z) {
            this.x = x;
            this.y = y;
            this.z = z;

            dx = 0;
            dy = 0;
            dz = 0;
        }

        public Moon(Moon moon) {
            x = moon.x;
            y = moon.y;
            z = moon.z;

            dx = moon.dx;
            dy = moon.dy;
            dz = moon.dz;
        }

        public void applyVelocity() {
            x += dx;
            y += dy;
            z += dz;
        }

        public void applyGravity(Moon other) {
            int xDiff = x - other.x;
            int yDiff = y - other.y;
            int zDiff = z - other.z;

            dx -= xDiff > 0 ? 1 : xDiff < 0 ? -1 : 0;
            dy -= yDiff > 0 ? 1 : yDiff < 0 ? -1 : 0;
            dz -= zDiff > 0 ? 1 : zDiff < 0 ? -1 : 0;
        }

        public int energy() {
            return (Math.abs(x)  + Math.abs(y)  + Math.abs(z)) *
                   (Math.abs(dx) + Math.abs(dy) + Math.abs(dz));
        }

        public String toString() {
            return String.format("(<%d, %d, %d>, <%d, %d, %d>)", x, y, z, dx, dy, dz);
        }
    }
}
