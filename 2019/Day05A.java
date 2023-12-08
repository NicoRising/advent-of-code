import java.io.*;
import java.util.*;

public class Day05A {
    public static void main(String[] args) throws FileNotFoundException {
        String[] input = new Scanner(new File("input.txt")).next().split(",");
        int[] program = new int[input.length];

        for (int index = 0; index < input.length; index++) {
            program[index] = Integer.parseInt(input[index]);
        }

        IntComputer computer = new IntComputer(program);
        computer.run();
        computer.write(1);

        int lastRead = 0;

        while (!computer.isHalted) {
            lastRead = computer.read();
        }

        System.out.println(lastRead + "");
    }

    private static class IntComputer {
        int[] originalProgram;
        int[] program;

        int pointer;

        boolean isHalted;
        boolean awaitingInput;
        boolean awaitingOutput;

        int inputIdx;
        int output;

        public IntComputer(int[] program) {
            this.originalProgram = program;
            reset();
        }

        public void reset() {
            this.program = originalProgram.clone();
            pointer = 0;

            isHalted = false;
            awaitingInput = false;
            awaitingOutput = false;
        }

        public void dump() {
            System.out.println(Arrays.toString(program));
        }

        public void run() {
            while (!isHalted && !awaitingInput && !awaitingOutput) {
                int op = program[pointer++];
                int[] operands;

                switch (op % 100) {
                    case 1:
                        // Add
                        operands = getOperands(op, 2);
                        program[program[pointer++]] = operands[0] + operands[1];
                        break;
                    case 2:
                        // Multiply
                        operands = getOperands(op, 2);
                        program[program[pointer++]] = operands[0] * operands[1];
                        break;
                    case 3:
                        // Input
                        awaitingInput = true;
                        inputIdx = program[pointer++];
                        break;
                    case 4:
                        // Output
                        operands = getOperands(op, 1);
                        awaitingOutput = true;
                        output = operands[0];
                        break;
                    case 99:
                        // Halt
                        isHalted = true;
                        break;
                    default:
                        throw new RuntimeException("Unknown opcode: " + op);
                }
            }
        }

        public int[] getOperands(int op, int arity) {
            int[] operands = new int[arity];

            for (int idx = 0, mag = 100; idx < arity; idx++, mag *= 10) {
                operands[idx] = program[op / mag % 10 == 0 ? program[pointer++] : pointer++];
            }

            return operands;
        }

        public void write(int input) {
            if (awaitingInput) {
                awaitingInput = false;
                program[inputIdx] = input;
                run();
            } else {
                throw new RuntimeException("Attempted to input while not awaiting input: " + input);
            }
        }

        public int read() {
            return read(false);
        }

        public int read(boolean print) {
            if (awaitingOutput) {
                int out = output;
                awaitingOutput = false;
                run();

                if (print) {
                    System.out.println(out);
                }

                return out;
            } else {
                throw new RuntimeException("Attempted to output while not awaiting output");
            }
        }
    }
}
