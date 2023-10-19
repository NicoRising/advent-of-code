import java.io.File;
import java.io.FileNotFoundException;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Scanner;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class Day12B {
    public static void main(String[] args) throws FileNotFoundException {
        Scanner input = new Scanner(new File("input.txt"));
        Pattern numbers = Pattern.compile("-?\\d+");
        ArrayList<Moon> moonList = new ArrayList<>();
        while (input.hasNextLine()) {
            Matcher match = numbers.matcher(input.nextLine());
            match.find();
            int x = Integer.parseInt(match.group());
            match.find();
            int y = Integer.parseInt(match.group());
            match.find();
            int z = Integer.parseInt(match.group());
            moonList.add(new Moon(x,y,z));
        }
        Moon[] moons = moonList.toArray(new Moon[moonList.size()]);
        Moon[] origin = new Moon[moons.length];
        for (int i = 0; i < moons.length; i++) {
            origin[i] = new Moon(moons[i]);
        }
        long xRepeat = 0;
        long yRepeat = 0;
        long zRepeat = 0;
        long step = 0;
        for (; xRepeat * yRepeat * zRepeat == 0; step++) {
            if (step%1 != 0) {
                System.out.println(step);
                for (int i = 0; i < moons.length; i++) {
                    System.out.println(moons[i]);
                }
                System.out.println();
            }
            for (int i = 0; i < moons.length; i++) {
                for (int j = i + 1; j < moons.length; j++) {
                    gravity(moons[i],moons[j]);
                }
            }
            for (int i = 0; i < moons.length; i++) {
                moons[i].move();
            }
            xRepeat = xRepeat == 0 ? step + 1 : xRepeat;
            yRepeat = yRepeat == 0 ? step + 1 : yRepeat;
            zRepeat = zRepeat == 0 ? step + 1 : zRepeat;
            for (int i = 0; i < moons.length; i++) {
                if (xRepeat == step + 1) {
                    if (moons[i].x != origin[i].x || moons[i].dx != origin[i].dx) {
                        xRepeat = 0;
                    }
                }
                if (yRepeat == step + 1) {
                    if (moons[i].y != origin[i].y || moons[i].dy != origin[i].dy) {
                        yRepeat = 0;
                    }
                }
                if (zRepeat == step + 1) {
                    if (moons[i].z != origin[i].z || moons[i].dz != origin[i].dz) {
                        zRepeat = 0;
                    }
                }
            }
        }
        long lcm = xRepeat * yRepeat / BigInteger.valueOf(xRepeat).gcd(BigInteger.valueOf(yRepeat)).longValue();
        lcm *= zRepeat / BigInteger.valueOf(lcm).gcd(BigInteger.valueOf(zRepeat)).longValue();
        System.out.println(lcm);
    }
    
    public static void gravity(Moon a, Moon b) {
        if(a.x != b.x) {
            a.dx += a.x < b.x ? 1 : - 1;
            b.dx += b.x < a.x ? 1 : - 1;
        }
        if(a.y != b.y) {
            a.dy += a.y < b.y ? 1 : - 1;
            b.dy += b.y < a.y ? 1 : - 1;
        }
        if(a.z != b.z) {
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
            dx = 0;
            dy = 0;
            dz = 0;
        }

        public Moon(Moon moon) {
            this.x = moon.x;
            this.y = moon.y;
            this.z = moon.z;
            this.dx = moon.dx;
            this.dy = moon.dy;
            this.dz = moon.dz;
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