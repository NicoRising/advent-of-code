import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Day02A {
    public static void main(String[] args) throws FileNotFoundException {
        String[] input = new Scanner(new File("input.txt")).next().split(",");
        int[] program = new int[input.length];

        for (int index = 0; index < input.length; index++) {
            program[index] = Integer.parseInt(input[index]);
        }

        program[1] = 12;
        program[2] = 2;

        int idx = 0;
        int idx_a, idx_b, idx_c;
        boolean halt = false;

        while (!halt) {
            switch (program[idx]) {
                case 1:
                    idx_a = program[idx + 1];
                    idx_b = program[idx + 2];
                    idx_c = program[idx + 3];

                    program[idx_c] = program[idx_a] + program[idx_b];

                    idx += 4;
                    break;
                case 2:
                    idx_a = program[idx + 1];
                    idx_b = program[idx + 2];
                    idx_c = program[idx + 3];

                    program[idx_c] = program[idx_a] * program[idx_b];

                    idx += 4;
                    break;
                case 99:
                    halt = true;
                    break;
                default:
                    throw new RuntimeException("Unknown opcode: " + program[idx]);
            }
        }

        System.out.println(program[0]);
    }
}
