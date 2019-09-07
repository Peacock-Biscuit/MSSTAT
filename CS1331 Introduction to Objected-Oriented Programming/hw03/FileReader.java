import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
public class FileReader {
    // I worked on the homework assignment alone, using only course materials.
    public static void main(String[] args) throws FileNotFoundException {
        File commandsFile = new File(args[0]);
        Scanner in = new Scanner(commandsFile);

        while (in.hasNext()) {
            String command = in.next();
            if (command.equals("allcaps")) {
                System.out.println(allCaps(in.next()));
            } else if (command.equals("power")) {
                int base = Integer.parseInt(in.next());
                int power = Integer.parseInt(in.next());
                System.out.println(power(base, power));
            } else if (command.equals("substring")) {
                String str = in.next();
                int startIndex = Integer.parseInt(in.next());
                int endIndex = Integer.parseInt(in.next());
                System.out.println(makeSubstring(str, startIndex, endIndex));
            }
        }

    }

    // place the three required static methods here
    public static String allCaps(String str) {
        return str.toUpperCase();
    }
    public static double power(int base, int power) {
        return Math.pow(base, power);
    }
    public static String makeSubstring(String str, int startIndex, int endIndex) {
        if (str.length() < endIndex) {
            return "Invalid command";
        }
        return str.substring(startIndex, endIndex);
    }
}