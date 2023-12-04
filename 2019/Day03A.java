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

        HashSet<Point> redPoints = new HashSet<Point>();
        Point currLoc = new Point();

        for (String move : redInput) {
            char dir = move.charAt(0);
            int length = Integer.parseInt(move.substring(1));

            for (int i = 0; i < length; i++) {
                switch (dir) {
                    case 'U':
                        currLoc.translate(0, 1);
                        break;
                    case 'D':
                        currLoc.translate(0, -1);
                        break;
                    case 'L':
                        currLoc.translate(-1, 0);
                        break;
                    case 'R':
                        currLoc.translate(1, 0);
                }

                redPoints.add(new Point(currLoc));
            }
        }

        currLoc.setLocation(0, 0);

        Point minIntersect;
        int minDist = Integer.MAX_VALUE;

        for (String move : greenInput) {
            char dir = move.charAt(0);
            int length = Integer.parseInt(move.substring(1));

            for (int i = 0; i < length; i++) {
                switch (dir) {
                    case 'U':
                        currLoc.translate(0, 1);
                        break;
                    case 'D':
                        currLoc.translate(0, -1);
                        break;
                    case 'L':
                        currLoc.translate(-1, 0);
                        break;
                    case 'R':
                        currLoc.translate(1, 0);
                }

                if (!(currLoc.x == 0 && currLoc.y == 0) && redPoints.contains(currLoc)) {
                    int dist = Math.abs(currLoc.x) + Math.abs(currLoc.y);

                    if (dist < minDist) {
                        minDist = dist;
                    }
                }
            }
        }

        System.out.println(minDist);
    }
}
