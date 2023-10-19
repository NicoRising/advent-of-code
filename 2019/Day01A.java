import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Day01A {
    public static void main(String[] args) throws FileNotFoundException {
        Scanner input = new Scanner(new File("input.txt"));
        int sum = 0;
        while (input.hasNext()) {
            sum += input.nextInt() / 3 - 2;
        }
        System.out.println(sum);
    }
}