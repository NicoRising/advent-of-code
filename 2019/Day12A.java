import java.io.*;
import java.util.*;

public class Day12A {
    public static void main(String[] args) throws FileNotFoundException {
        Scanner input = new Scanner(new File("input.txt")).useDelimiter("[^-\\d]+");
        List<Moon> moons = new ArrayList<Moon>();

        while (input.hasNext()) {
            moons.add(new Moon(input.nextInt(), input.nextInt(), input.nextInt()));
        }

        for (int step = 0; step < 1_000; step++) {
            for (Moon moonA : moons) {
                for (Moon moonB : moons) {
                    // A moon applying gravity to itself does nothing
                    moonA.applyGravity(moonB);
                }
            }

            moons.forEach(moon -> moon.applyVelocity());
        }

        System.out.println(moons.stream().mapToInt(moon -> moon.energy()).sum());
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
