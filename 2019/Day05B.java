import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Day05B {
    public static void main(String[] args) throws FileNotFoundException {
        String[] input = new Scanner(new File("input.txt")).next().split(",");
        int[] program = new int[input.length];
        for (int index = 0; index<input.length; index++) {
            program[index] = Integer.parseInt(input[index]);
        }
        int index = 0;
        boolean halt = false;
        int in = 5;
        int out = 0;
        while (!halt) {
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
                    program[program[index + 1]] = in;
                    index += 2;
                    break;
                case 4:
                    out = getIndex(mode1, index + 1, program);
                    index += 2;
                    break;
                case 5:
                    index = getIndex(mode1, index + 1, program) != 0 ? getIndex(mode2, index + 2, program) : index + 3;
                    break;
                case 6:
                    index = getIndex(mode1, index + 1, program) == 0 ? getIndex(mode2, index + 2, program) : index + 3;
                    break;
                case 7:
                    program[program[index + 3]] = getIndex(mode1, index + 1, program)<getIndex(mode2, index + 2, program) ? 1 : 0;
                    index += 4;
                break;
                case 8:
                    program[program[index + 3]] = getIndex(mode1, index + 1, program) == getIndex(mode2, index + 2, program) ? 1 : 0;
                    index += 4;
                    break;
                default:
                halt = true;
            }
        }
        System.out.println(out);
    }

    public static int getIndex(int mode, int index, int[] program) {
        return mode == 0 ? program[program[index]] : program[index];
    }
}