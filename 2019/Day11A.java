import java.awt.Point;
import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Scanner;

public class Day11A {
    public static void main(String[] args) throws FileNotFoundException {
        final int WIDTH = 500;
        String[] input = new Scanner(new File("input.txt")).next().split(",");
        long[] program = new long[input.length];
        for (int i = 0; i < input.length; i++) {
            program[i] = Long.parseLong(input[i]);
        }
        Intputer ant = new Intputer(program);
        int[][] grid = new int[WIDTH][WIDTH];
        for (int x = 0; x < WIDTH; x++) {
            for (int y = 0; y < WIDTH; y++) {
                grid[x][y] = 0;
            }
        }
        Point location = new Point(WIDTH / 2, WIDTH / 2);
        int dir = 0;
        HashSet<Point> visited = new HashSet<>();
        while (!ant.isHalted()) {
            visited.add(location);
            ant.input(grid[location.x][location.y]);
            long[] output = ant.getOutput();
            grid[location.x][location.y] = (int) output[0];
            dir += output[1] == 0 ? -1 : 1;
            dir = Math.floorMod(dir, 4);
            location = new Point(location);
            switch (dir) {
                case 0:
                    location.translate(0, -1);
                    break;
                case 1:
                    location.translate(1, 0);
                    break;
                case 2:
                    location.translate(0, 1);
                    break;
                default:
                    location.translate(-1, 0);
            }
        }         
        System.out.println(visited.size());
    }

    private static void display(int[][] grid) {
        for (int x = 0; x < grid.length; x++) {
            String output = "";
            for (int y = 0; y < grid[x].length; y++) {
                output += grid[x][y] == 0 ? '.' : '#';
            }
            System.out.println(output);
        }
    }

    private static class Intputer {
        private long[] program;
        private int index;
        private int inputIndex;
        private long relative;
        private boolean halted;
        private ArrayList<Long> output;

        public Intputer(long[] program) {
            this.program = new long[program.length + 1000];
            for (int i = 0; i < this.program.length; i++) {
                this.program[i] = i < program.length ? program[i] : 0;
            }
            index = 0;
            relative = 0;
            halted = false;
            output = new ArrayList< > ();
            process();
        }

        public void input(int input) {
            program[inputIndex] = input;
            process();
        }

        public long[] getOutput() {
            long[] out = new long[output.size()];
            for (int i = 0; i < out.length; i++) {
                out[i] = output.get(i).longValue();
            }
            output.clear();
            return out;
        }

        public boolean isHalted() {
            return halted;
        }

        private void process() {
            boolean paused = false;
            while (!paused && !halted) {
                String command = program[index] + "";
                while (command.length() < 5) {
                command = '0' + command;
                }
                int a = 0;
                int b = 0;
                int c = 0;
                if (index < program.length - 1) {
                    switch (command.charAt(2)) {
                        case '0':
                            a = (int)program[index + 1];
                            break;
                        case '1':
                            a = index + 1;
                            break;
                        default:
                            a = (int)(program[index + 1] + relative);
                    }
                    if (index < program.length - 2) {
                        switch (command.charAt(1)) {
                            case '0':
                                b = (int)program[index + 2];
                                break;
                            case '1':
                                b = index + 2;
                                break;
                            default:
                                b = (int)(program[index + 2] + relative);
                        }
                        if (index < program.length - 3) {
                            switch (command.charAt(0)) {
                                case '0':
                                    c = (int)program[index + 3];
                                    break;
                                case '1':
                                    c = index + 3;
                                    break;
                                default:
                                    c = (int)(program[index + 3] + relative);
                            }
                        }
                    }
                }
                switch (Integer.parseInt(command.substring(3))) {
                    case 1:
                        program[c] = program[a] + program[b];
                        index += 4;
                        break;
                    case 2:
                        program[c] = program[a] * program[b];
                        index += 4;
                        break;
                    case 3:
                        inputIndex = a;
                        index += 2;
                        paused = true;
                        break;
                    case 4:
                        output.add(program[a]);
                        index += 2;
                        break;
                    case 5:
                        index = program[a] != 0 ? (int)program[b] : index + 3;
                        break;
                    case 6:
                        index = program[a] == 0 ? (int)program[b] : index + 3;
                        break;
                    case 7:
                        program[c] = program[a] < program[b] ? 1 : 0;
                        index += 4;
                        break;
                    case 8:
                        program[c] = program[a] == program[b] ? 1 : 0;
                        index += 4;
                        break;
                    case 9:
                        relative += program[a];
                        index += 2;
                        break;
                    default:
                        paused = true;
                        halted = true;
                }
            }
        }
    }
}