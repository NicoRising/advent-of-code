import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Day07A {
    public static void main(String[] args) throws FileNotFoundException {
        String[] input = new Scanner(new File("input.txt")).next().split(",");
        int[] program = new int[input.length];
        for (int index = 0; index < input.length; index++) {
            program[index] = Integer.parseInt(input[index]);
        }
        int max = 0;
        for (int a = 0; a < 5; a++) {
            for (int b = 0; b < 5; b++) {
                for (int c = 0; c < 5; c++) {
                for (int d = 0; d < 5; d++) {
                    for (int e = 0; e < 5; e++) {
                        if (a != b && a != c && a != d && a != e && b != c && b != d && b != e && c != d && c != e && d != e) { // Why I did it this way I have no idea
                            int output = run(program, new int[]{e, run(program, new int[]{d, run(program, new int[]{c, run(program, new int[]{b, run(program, new int[]{a, 0})})})})});
                            max = output > max ? output : max;
                        }
                    }
                }
                }
            }
        }
        System.out.println(max);
    }

    public static int run(int[] program, int[] input) {
        int index = 0;
        int inputIndex = 0;
        while (true) {
            String command = program[index] + "";
            while (command.length() < 5) {
                command = '0' + command;
            }
            int op = Integer.parseInt(command.substring(3));
            int mode1 = Integer.parseInt(command.charAt(2) + "");
            int mode2 = Integer.parseInt(command.charAt(1) + "");
            switch (op) {
                case 1:
                    program[program[index + 3]] = getIndex(mode1, index + 1, program) + getIndex(mode2, index + 2, program);
                    index += 4;
                    break;
                case 2:
                    program[program[index + 3]] = getIndex(mode1, index + 1, program) * getIndex(mode2, index + 2, program);
                    index += 4;
                    break;
                case 3:
                    program[program[index + 1]] = input[inputIndex++];
                    index += 2;
                    break;
                case 4:
                    return getIndex(mode1, index + 1, program);
                case 5:
                    index = getIndex(mode1, index + 1, program) != 0 ? getIndex(mode2, index + 2, program) : index + 3;
                    break;
                case 6:
                    index = getIndex(mode1, index + 1, program) == 0 ? getIndex(mode2, index + 2, program) : index + 3;
                    break;
                case 7:
                    program[program[index + 3]] = getIndex(mode1, index + 1, program) < getIndex(mode2, index + 2, program) ? 1 : 0;
                    index += 4;
                    break;
                case 8:
                    program[program[index + 3]] = getIndex(mode1, index + 1, program) == getIndex(mode2, index + 2, program) ? 1 : 0;
                    index += 4;
                    break;
                default:
                    return 0;
            }
        }
    }

    public static int getIndex(int mode, int index, int[] program) {
        return mode == 0 ? program[program[index]] : program[index];
    }
}