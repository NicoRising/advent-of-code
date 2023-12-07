import java.awt.Point;
import java.io.*;
import java.util.*;

public class Day03B{
    public static void main(String[] args) throws FileNotFoundException{
        Scanner input = new Scanner(new File("input.txt"));
        String[] redInput = input.next().split(",");
        String[] greenInput = input.next().split(",");

        Map<Point, Integer> redPoints = new HashMap<Point, Integer>();
        Point currLoc = new Point();
        int wireDist = 1;

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

                redPoints.put(new Point(currLoc), wireDist);
                wireDist++;
            }
        }

        currLoc.setLocation(0, 0);
        wireDist = 1;

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

                if (!(currLoc.x == 0 && currLoc.y == 0) && redPoints.containsKey(currLoc)) {
                    int dist = wireDist + redPoints.get(currLoc);

                    if (dist < minDist) {
                        minDist = dist;
                    }
                }

                wireDist++;
            }
        }

        System.out.println(minDist);
    }
}
