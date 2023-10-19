import java.io.File;
import java.io.FileNotFoundException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Scanner;

public class Day07B {
    public static void main(String[] args) throws FileNotFoundException {
        String[] input = new Scanner(new File("input.txt")).next().split(",");
        int[] program = new int[input.length];
        for (int index = 0; index < input.length; index++) {
            program[index] = Integer.parseInt(input[index]);
        }
        int max = 0;
        Integer[] phases = new Integer[5];
        for (phases[0] = 5; phases[0] < 10; phases[0]++) {
            for (phases[1] = 5; phases[1] < 10; phases[1]++) {
                for (phases[2] = 5; phases[2] < 10; phases[2]++) {
                for (phases[3] = 5; phases[3] < 10; phases[3]++) {
                    for (phases[4] = 5; phases[4] < 10; phases[4]++) {
                        if (new HashSet<Integer>(Arrays.asList(phases)).size() == phases.length) {
                            Intputer[] intputers = new Intputer[5];
                            for (int index = 0; index < intputers.length; index++) {
                                intputers[index] = new Intputer(program);
                                intputers[index].input(phases[index]);
                            }
                            int signal = 0;
                            int last = 0;
                            boolean halted = false;
                            while (!halted) {
                                for (int index = 0; index < intputers.length; index++) {
                                    signal = intputers[index].input(signal);
                                    if (signal == -1) {
                                        halted = true;
                                    } else if(index == intputers.length - 1) {
                                        last = signal;
                                    }
                                }
                            }
                            max = last > max ? last : max;
                        }
                    }
                }
                }
            }
        }
        System.out.println(max);
    }

    private static class Intputer {
        private int[] program;
        private int index;
        private int inputIndex;
        private boolean halted;

        public Intputer(int[] program) {
            this.program = program;
            index = 0;
            halted = false;
            process();
        }
        
        public int input(int input) {
            program[inputIndex] = input;
            return process();
        }

        private int process() {
            int output = -1;
            boolean paused = false;
            while (!paused && !halted) {
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
                        inputIndex = program[index + 1];
                        index += 2;
                        paused = true;
                        break;
                    case 4:
                        output = getIndex(mode1, index + 1, program);
                        index += 2;
                        break;
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
                        paused = true;
                        halted = true;
                }
            }
            return output;
        }

        private int getIndex(int mode, int index, int[] program) {
            return mode == 0 ? program[program[index]] : program[index];
        }
    }
}