import java.io.*;
import java.util.*;

public class Day09B {
    public static void main(String[] args) throws FileNotFoundException {
        String[] input = new Scanner(new File("input.txt")).next().split(",");
        long[] program = new long[input.length];

        for (int index = 0; index < input.length; index++) {
            program[index] = Long.parseLong(input[index]);
        }

        IntComputer computer = new IntComputer(program);

        computer.run();
        computer.write(2);
        computer.read(true);
    }

    // More like Longcode computer, am I right?
    private static class IntComputer {
        long[] originalProgram;
        long[] program;

        long pointer;
        long relativeBase;

        boolean isHalted;
        boolean awaitingInput;
        boolean awaitingOutput;

        long inputIdx;
        long output;

        public IntComputer(long[] program) {
            this.originalProgram = program;
            reset();
        }

        public void reset() {
            this.program = originalProgram.clone();
            pointer = 0;
            relativeBase = 0;

            isHalted = false;
            awaitingInput = false;
            awaitingOutput = false;
        }

        public void dump() {
            System.out.println(Arrays.toString(program));
        }

        public void run() {
            while (!isHalted && !awaitingInput && !awaitingOutput) {
                long op = get(pointer++);
                long[] operands;

                switch ((int)op % 100) {
                    case 1:
                        // Add
                        operands = getParams(op, 3, true);
                        set(operands[2], operands[0] + operands[1]);
                        break;
                    case 2:
                        // Multiply
                        operands = getParams(op, 3, true);
                        set(operands[2], operands[0] * operands[1]);
                        break;
                    case 3:
                        // Input
                        operands = getParams(op, 1, true);
                        awaitingInput = true;
                        inputIdx = operands[0];
                        break;
                    case 4:
                        // Output
                        operands = getParams(op, 1, false);
                        awaitingOutput = true;
                        output = operands[0];
                        break;
                    case 5:
                        // Jump-if-true
                        operands = getParams(op, 2, false);

                        if (operands[0] != 0) {
                            pointer = operands[1];
                        }

                        break;
                    case 6:
                        // Jump-if-false
                        operands = getParams(op, 2, false);

                        if (operands[0] == 0) {
                            pointer = operands[1];
                        }

                        break;
                    case 7:
                        // Less than
                        operands = getParams(op, 3, true);
                        set(operands[2], operands[0] < operands[1] ? 1 : 0);
                        break;
                    case 8:
                        // Equals
                        operands = getParams(op, 3, true);
                        set(operands[2], operands[0] == operands[1] ? 1 : 0);
                        break;
                    case 9:
                        // Relative base offset
                        operands = getParams(op, 1, false);
                        relativeBase += operands[0];
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

        public long[] getParams(long op, int arity, boolean hasWrite) {
            long[] operands = new long[arity];

            for (int idx = 0, mag = 100; idx < arity; idx++, mag *= 10) {
                long mode = op / mag % 10;
                long operandIdx;
                
                if (mode == 0) {
                    // Position mode
                    operandIdx = get(pointer++);
                } else if (mode == 1) {
                    // Immediate mode
                    operandIdx = pointer++;
                } else {
                    // Relative mode
                    operandIdx = get(pointer++) + relativeBase;
                }

                // If an operation will write to its final parameter, it should be sent as an index
                if (hasWrite && idx == arity - 1) {
                    operands[idx] = operandIdx;
                } else {
                    operands[idx] = get(operandIdx);
                }
            }

            return operands;
        }

        // So I don't have to do so many casts
        public long get(long idx) {
            return get((int)idx);
        }

        // Basically an ArrayList, but only resizes exactly what it needs
        public long get(int idx) {
            if (idx < program.length) {
                return program[idx];
            } else {
                long[] newProgram = new long[idx + 1];

                // Utilizes the fact that Java long arrays initialize values to 0
                for (int copyIdx = 0; copyIdx < program.length; copyIdx++) {
                    newProgram[copyIdx] = program[copyIdx];
                }

                program = newProgram;
                return program[idx];
            }
        }

        public void set(long idx, long value) {
            set((int)idx, value);
        }

        public void set(int idx, long value) {
            if (idx < program.length) {
                program[idx] = value;
            } else {
                long[] newProgram = new long[idx + 1];

                for (int copyIdx = 0; copyIdx < program.length; copyIdx++) {
                    newProgram[copyIdx] = program[copyIdx];
                }

                program = newProgram;
                program[idx] = value;
            }
        }

        public void write(long input) {
            if (awaitingInput) {
                awaitingInput = false;
                set(inputIdx, input);
                run();
            } else {
                throw new RuntimeException("Attempted to input while not awaiting input: " + input);
            }
        }

        public long read() {
            return read(false);
        }

        public long read(boolean print) {
            if (awaitingOutput) {
                long out = output;
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
