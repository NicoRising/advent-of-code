import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Scanner;

public class Day13A {
    public static void main(String[] args) throws FileNotFoundException {
        String[] input = new Scanner(new File("input.txt")).next().split(",");
        long[] program = new long[input.length];
        for (int i = 0; i < input.length; i++) {
            program[i] = Long.parseLong(input[i]);
        }
        Intputer game = new Intputer(program);
        long[] output = game.output();
        int blocks = 0;
        for (int i = 0; i < output.length; i++) {
            blocks += i % 3 == 2 && output[i] == 2 ? 1 : 0;
        }
        System.out.println(blocks);
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
            output = new ArrayList<>();
            process();
        }

        public void input(int input) {
            program[inputIndex] = input;
            process();
        }

        public long[] output() {
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
                    switch(command.charAt(2)) {
                        case '0':
                            a = (int) program[index + 1];
                            break;
                        case '1':
                            a = index + 1;
                            break;
                        default:
                            a = (int) (program[index + 1] + relative);
                    }
                    if (index < program.length - 2) {
                        switch(command.charAt(1)) {
                            case '0':
                                b = (int) program[index + 2];
                                break;
                            case '1':
                                b = index + 2;
                                break;
                            default:
                                b = (int) (program[index + 2] + relative);
                        }
                        if (index < program.length - 3) {
                            switch(command.charAt(0)) {
                                case '0':
                                    c = (int) program[index + 3];
                                    break;
                                case '1':
                                    c = index + 3;
                                    break;
                                default:
                                    c = (int) (program[index + 3] + relative);
                            }
                        }
                    }
                }
                switch(Integer.parseInt(command.substring(3))) {
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
                    index = program[a] != 0 ? (int) program[b] : index + 3;
                    break;
                case 6:
                    index = program[a] == 0 ? (int) program[b] : index + 3;
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