import java.awt.Point;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.HashSet;
import java.util.Scanner;

public class Day03A {
    public static void main(String[] args) throws FileNotFoundException {
        Scanner input = new Scanner(new File("input.txt"));
        String[] redInput = input.next().split(",");
        String[] greenInput = input.next().split(",");
        Point location = new Point();
        HashSet<Point> red = new HashSet<>();
        for (String move: redInput) {
            for (int distance = 0; distance < Integer.parseInt(move.substring(1)); distance++) {
                switch (move.charAt(0)) {
                    case 'U':
                        location.translate(0, 1);
                        break;
                    case 'D':
                        location.translate(0, -1);
                        break;
                    case 'L':
                        location.translate(-1, 0);
                        break;
                    default:
                        location.translate(1, 0);
                }
                red.add(new Point(location));
            }
        }
        location.move(0, 0);
        HashSet<Point> green = new HashSet<>();
        for (String move: greenInput) {
            for (int distance = 0; distance < Integer.parseInt(move.substring(1)); distance++) {
                switch(move.charAt(0)) {
                    case 'U':
                        location.translate(0, 1);
                        break;
                    case 'D':
                        location.translate(0, -1);
                        break;
                    case 'L':
                        location.translate(-1, 0);
                        break;
                    default:
                        location.translate(1, 0);
                }
                green.add(new Point(location));
            }
        }
        location.move(0, 0);
        for (Point point: red) {
            if (green.contains(point) && (Math.abs(point.x) + Math.abs(point.y) < Math.abs(location.x) + Math.abs(location.y) || location.x == 0 && location.y == 0)) {
                location = point;
            }
        }
        System.out.println(Math.abs(location.x) + Math.abs(location.y));
    }
}