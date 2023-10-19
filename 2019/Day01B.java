import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Day01B {
    public static void main(String[] args) throws FileNotFoundException {
        Scanner input = new Scanner(new File("input.txt"));
        int sum = 0;
        while (input.hasNext()) {
            sum += calculateFuel(input.nextInt() / 3 - 2);
        }
        System.out.println(sum);
    }

    public static int calculateFuel(int mass){
        if(mass <= 6){
            return mass;
        }
        return mass + calculateFuel(mass / 3 - 2);
    }
}