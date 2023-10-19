import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Scanner;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class Day12A {
    public static void main(String[] args) throws FileNotFoundException {
        Scanner input = new Scanner(new File("input.txt"));
        Pattern numbers = Pattern.compile("-?\\d+");
        ArrayList<Moon> moons = new ArrayList<>();
        while (input.hasNextLine()) {
            Matcher match = numbers.matcher(input.nextLine());
            match.find();
            int x = Integer.parseInt(match.group());
            match.find();
            int y = Integer.parseInt(match.group());
            match.find();
            int z = Integer.parseInt(match.group());
            moons.add(new Moon(x, y, z));
        }
        for (int step = 0; step < 1000; step++) {
            for (int i = 0; i < moons.size(); i++) {
                for (int j = i + 1; j < moons.size(); j++) {
                    gravity(moons.get(i), moons.get(j));
                }
            }
            for (Moon moon: moons) {
                moon.move();
            }
        }
        int energy = 0;
        for (Moon moon: moons) {
            energy += moon.getEnergy();
        }
        System.out.println(energy);
    }

    public static void gravity(Moon a, Moon b) {
        if (a.x != b.x) {
            a.dx += a.x < b.x ? 1 : - 1;
            b.dx += b.x < a.x ? 1 : - 1;
        }
        if (a.y != b.y) {
            a.dy += a.y < b.y ? 1 : - 1;
            b.dy += b.y < a.y ? 1 : - 1;
        }
        if (a.z != b.z) {
            a.dz += a.z < b.z ? 1 : - 1;
            b.dz += b.z < a.z ? 1 : - 1;
        }
    }

    private static class Moon {
        public int x, y, z;
        public int dx, dy, dz;
        public Moon(int x, int y, int z) {
            this.x = x;
            this.y = y;
            this.z = z;
        }

        public void move() {
            x += dx;
            y += dy;
            z += dz;
        }

        public int getEnergy() {
            return (Math.abs(x) + Math.abs(y) + Math.abs(z)) * (Math.abs(dx) + Math.abs(dy) + Math.abs(dz));
        }

        public String toString() {
            return "(" + x + ", " + y + ", " + z + ") (" + dx + ", " + dy + ", " + dz + ")";
        }
    }
}