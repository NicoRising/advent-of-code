import java.io.*;
import java.util.Scanner;

public class Day02B {
    public static void main(String[] args) throws FileNotFoundException {
        String[] input = new Scanner(new File("input.txt")).next().split(",");
        int[] originalProgram = new int[input.length];

        for (int index = 0; index < input.length; index++) {
            originalProgram[index] = Integer.parseInt(input[index]);
        }

        for (int noun = 0; noun <= 99; noun++) {
            for (int verb = 0; verb <= 99; verb++) {
                int[] program = originalProgram.clone();

                program[1] = noun;
                program[2] = verb;

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
                            throw new RuntimeException("Invalid opcode: " + program[idx]);
                    }
                }

                if (program[0] == 19690720) {
                    System.out.println(noun * 100 + verb);
                    return;
                }
            }
        }
    }
}
