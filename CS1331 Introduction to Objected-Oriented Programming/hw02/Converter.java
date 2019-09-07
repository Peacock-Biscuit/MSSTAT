public class Converter {
    public static void main(String[] args) {
        // You can use this main method to test your other methods
        System.out.println("fahrenheitToCelsius: " + fahrenheitToCelsius(34));
        System.out.println("celsiusToFahrenheit: " + celsiusToFahrenheit(4));
        System.out.println("printFahrenheitConversionTable:");
        printFahrenheitConversionTable(32, 35);
        // Feel free to add your own tests!

    }
    public static double fahrenheitToCelsius(int temp) {
        double celsius = (temp - 32) / 1.8;
        return celsius;
    }
    public static double celsiusToFahrenheit(int temp) {
        double falhewnheit = temp * 1.8 + 32;
        return falhewnheit;
    }
    public static void printFahrenheitConversionTable(int lower, int upper) {
        for (int i = lower; i <= upper; i++) {
            System.out.printf("Fahrenheit: " + i + " -> Celsius: ");
            System.out.printf("%.3f", fahrenheitToCelsius(i));
            System.out.printf("\n");
        }
    }
    public static void printCelsiusConversionTable(int lower, int upper) {
        int i = lower;
        while (i <= upper) {
            System.out.printf("Celsius: " + i + " -> Fahrenheit: ");
            System.out.printf("%.3f", celsiusToFahrenheit(i));
            System.out.printf("\n");
            i++;
        }
    }
    public static boolean celsiusWarmer(int celsius, int fahrenheit) {
        return celsius > fahrenheitToCelsius(fahrenheit);
    }
    public static boolean fahrenheitWarmer(int fahrenheit, int celsius) {
        boolean t = fahrenheit > celsiusToFahrenheit(celsius) ? true : false;
        return t;
    }
}