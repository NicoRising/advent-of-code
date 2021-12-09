import java.awt.Point;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Scanner;

public class Day03B{
    public static void main(String[] args) throws FileNotFoundException{
        Scanner input = new Scanner(new File("input.txt"));
        String[] redInput = input.next().split(",");
        String[] greenInput = input.next().split(",");
        Point location = new Point();
        ArrayList<Point> red = new ArrayList<>();
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
        ArrayList<Point> green = new ArrayList<>();
        for (String move: greenInput) {
            for (int distance = 0; distance < Integer.parseInt(move.substring(1)); distance++){
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
                green.add(new Point(location));
            }
        }
        int min = 0;
        for (int redStep = 0; redStep < red.size(); redStep++) {
            for (int greenStep = 0; greenStep < green.size() && (redStep + greenStep < min || min == 0); greenStep++) {
                if (red.get(redStep).equals(green.get(greenStep)) && (redStep + greenStep < min || min == 0)) {
                    min = redStep + greenStep + 2; // Account for zero-indexing
                }
            }
        }
        System.out.println(min);
    }
}