import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Day04B {
    public static void main(String[] args) throws FileNotFoundException {
        String input = new Scanner(new File("input.txt")).next();
        int min = Integer.parseInt(input.substring(0,input.indexOf('-')));
        int max = Integer.parseInt(input.substring(input.indexOf('-') + 1));
        int count = 0;
        for (int password = min; password <= max; password++) {
            String[] numbers = (password + "").split("");
            boolean pair = false;
            boolean increases = true;
            for (int index = 1; index < numbers.length; index++) {
                if (numbers[index].equals(numbers[index - 1]) && (index <= 1 || !numbers[index].equals(numbers[index - 2]))) {
                    if ((index >= numbers.length - 1 || !numbers[index].equals(numbers[index + 1]))) {
                        pair = true;
                    }
                }
                if (numbers[index].compareTo(numbers[index - 1]) < 0) {
                    increases = false;
                    break;
                }
            }
            if (pair && increases) {
                count += 1;
            }
        }
        System.out.println(count);
    }
}