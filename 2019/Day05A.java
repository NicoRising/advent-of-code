import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Day05A {
    public static void main(String[] args) throws FileNotFoundException {
        String[] input = new Scanner(new File("Input.txt")).next().split(",");
        int[] program = new int[input.length];
        for (int index = 0; index < input.length; index++) {
            program[index] = Integer.parseInt(input[index]);
        }
        int index = 0;
        boolean halt = false;
        int in = 1;
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
                    program[program[index + 3]] = (mode1 == 0 ? program[program[index + 1]] : program[index + 1]) + (mode2 == 0 ? program[program[index + 2]] : program[index + 2]);
                    index += 4;
                    break;
                case 2:
                    program[program[index + 3]] = (mode1 == 0 ? program[program[index + 1]] : program[index + 1]) * (mode2 == 0 ? program[program[index + 2]] : program[index + 2]);
                    index += 4;
                    break;
                case 3:
                    program[program[index + 1]] = in;
                    index += 2;
                    break;
                case 4:
                    out = mode1 == 0 ? program[program[index + 1]] : program[index + 1];
                    index += 2;
                    break;
                default:
                halt = true;
            }
        }
        System.out.println(out);
    }
}