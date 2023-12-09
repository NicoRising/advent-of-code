import java.awt.Point;
import java.io.*;
import java.util.*;

public class Day10B {
    public static void main(String[] args) throws FileNotFoundException {
        final int WIDTH;

        Scanner input = new Scanner(new File("input.txt"));
        String line = input.next();
        WIDTH = line.length();

        boolean[][] field = new boolean[WIDTH][WIDTH];

        for (int row = 0; row < WIDTH; row++) {
            for (int col = 0; col < WIDTH; col++) {
                if (line.charAt(col) == '#') {
                    field[row][col] = true;
                }
            }

            if (input.hasNext()) {
                line = input.next();
            }
        }

        int maxVisible = 0;
        int maxRow = 0;
        int maxCol = 0;

        for (int row = 0; row < WIDTH; row++) {
            for (int col = 0; col < WIDTH; col++) {
                if (field[row][col]) {
                    int visible = calcVisible(row, col, field);

                    if (visible > maxVisible) {
                        maxVisible = visible;
                        maxRow = row;
                        maxCol = col;
                    }
                }
            }
        }

        Point asteroid = calcOrdering(maxRow, maxCol, field).get(199);
        System.out.println(asteroid.x * 100 + asteroid.y);
    }

    private static int calcVisible(int stationRow, int stationCol, boolean[][] field) {
        Set<Float> usedRatios = new HashSet<Float>();
        int visible = 0;

        for (int row = 0; row < field.length; row++) {
            for (int col = 0; col < field[row].length; col++) {
                if (row == stationRow && col == stationCol) {
                    // Reset the used ratios so angles opposite used angles can be used
                    usedRatios.clear();
                } else if (field[row][col]) {
                    float ratio = (float)(row - stationRow) / (col - stationCol);

                    if (!usedRatios.contains(ratio)) {
                        usedRatios.add(ratio);
                        visible++;
                    }
                }
            }
        }

        return visible;
    }

    private static List<Point> calcOrdering(int stationRow,
                                            int stationCol,
                                            boolean[][] field) {

        Map<Double, PriorityQueue<Point>> angleMap = new HashMap<Double, PriorityQueue<Point>>();
        Comparator<Point> comp = new AsteroidComparator(new Point(stationCol, stationRow));

        for (int row = 0; row < field.length; row++) {
            for (int col = 0; col < field[row].length; col++) {
                if (field[row][col] && !(row == stationRow && col == stationCol)) {
                    // Negate row diff so angles move clockwise
                    double angle = Math.atan2(col - stationCol, stationRow - row);

                    if (angle < 0) {
                        angle += Math.PI * 2;
                    }

                    if (!angleMap.containsKey(angle)) {
                        angleMap.put(angle, new PriorityQueue<Point>(comp));
                    }

                    angleMap.get(angle).add(new Point(col, row));
                }
            }
        }

        List<Point> order = new ArrayList<Point>();
        List<Double> angles = new LinkedList<Double>(angleMap.keySet());
        Collections.sort(angles);

        for (int idx = 0; !angles.isEmpty(); idx++) {
            Point next = angleMap.get(angles.get(idx % angles.size())).poll();

            if (next != null) {
                order.add(next);
            } else {
                angles.remove(idx % angles.size());
            }
        }

        return order;
    }

    // Class to order asteroids by distance from the station
    private static class AsteroidComparator implements Comparator<Point> {
        Point station;

        public AsteroidComparator(Point station) {
            this.station = station;
        }

        @Override
        public int compare(Point asteroid1, Point asteroid2) {
            return (int)(station.distanceSq(asteroid1) - station.distanceSq(asteroid2));
        }
    }
}
