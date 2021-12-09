import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Day02B {
    public static void main(String[] args) throws FileNotFoundException {
        String[] input = new Scanner(new File("Input.txt")).next().split(",");
        int[] program = new int[input.length];
        for (int index = 0; index < input.length; index++) {
            program[index] = Integer.parseInt(input[index]);
        }
        int out = 0;
        for (int noun = 0; noun < 100 && out == 0; noun++) {
            for (int verb = 0; verb < 100 && out == 0; verb++) {
                int[] copy = program.clone();
                copy[1] = noun;
                copy[2] = verb;
                int index = 0;
                boolean halt = false;
                while (!halt) {
                    switch (copy[index]) {
                        case 1:
                            copy[copy[index + 3]] = copy[copy[index + 1]] + copy[copy[index + 2]];
                            index += 4;
                            break;
                        case 2:
                            copy[copy[index + 3]] = copy[copy[index + 1]] * copy[copy[index + 2]];
                            index += 4;
                            break;
                        default:
                            halt = true;
                    }
                }
                if(copy[0] == 19690720) {
                    out = noun * 100 + verb;
                }
            }
        }
        System.out.println(out);
    }
}