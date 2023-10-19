import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Day02A {
    public static void main(String[] args) throws FileNotFoundException {
        String[] input = new Scanner(new File("input.txt")).next().split(",");
        int[] program = new int[input.length];
        for(int index = 0; index < input.length; index++) {
            program[index] = Integer.parseInt(input[index]);
        }
        program[1] = 12;
        program[2] = 2;
        int index = 0;
        boolean halt = false;
        while (!halt) {
            switch (program[index]) {
                case 1:
                    program[program[index + 3]] = program[program[index + 1]] + program[program[index + 2]];
                    index += 4;
                    break;
                case 2:
                    program[program[index + 3]] = program[program[index + 1]] * program[program[index + 2]];
                    index += 4;
                    break;
                default:
                    halt = true;
            }
        }
        System.out.println(program[0]);
    }
}