    /** I worked on the homework assignment alone, using only course materials.*/
    /**
    * Create Bar class and print out the shape of bars
    * @author Jim Liu
    * @version 4.1
    * @since 2019.09.10
    */
public class Bar {
    /**
    * Create the Bar data field
    * @param chocolateType the flavor of the bar you choose
    * @param barLength the length of the bar
    * @param barWidth the width of the bar
    */
    public Bar(String chocolateType, int barLength, int barWidth) {
        this.chocolateType = chocolateType;
        this.barLength = barLength;
        this.barWidth = barWidth;
    }
    private String chocolateType;

    private int barLength;

    private int barWidth;
   /**
   * This method is used to caculate a perimeter of the bar.
   * We use the defult barLength and barWidth to get the perimeter.
   * @return int This returns sum of width and length of the bar and then mutiply 2 to get the perimeter.
   */
    public int getPerimeter() {
        return 2 * (barWidth + barLength);
    }
    /**
   * This method is used to caculate an area of the bar.
   * We use the defult barLength and barWidth to get the area.
   * @return int This returns multiplication of the length of the bar and the width of the bar.
   */
    public int getArea() {
        return barLength * barWidth;
    }
    /**
   * This method is used to determine that bar we difine is square.
   * We use the defult barLength and barWidth to know whether the length is the same as the width.
   * @return boolean This returns truth or false of whether the length is equal to the width.
   */
    public boolean isSquare() {
        return barWidth == barLength;
    }
    /**
   * This method is used to calculate the cost of the bar.
   * @param chocolateCost This is the first parameter to calculateCost method
   * @param trimCost This is the second parameter to calculateCost method
   * @return boolean This returns truth or false of whether the length is equal to the width.
   */
    public double calculateCost(double chocolateCost, double trimCost) {
        Double len = Double.valueOf(barLength);
        Double wid = Double.valueOf(barWidth);
        return chocolateCost * len * wid + 2 * (len + wid) * trimCost;
    }
    /**
   * This method is used to print out a string that shows two cases. One of case is that the bar is not square.
   * The other is that the bar is square.
   * @return String This returns a string that shows the bar's area and type.
   */
    public String getDetails() {
        if (barLength == barWidth) {
            int area = barWidth * barLength;
            String areaStr = String.valueOf(area);
            return "Square " + areaStr + " piece bar of " + chocolateType + " chocolate";
        } else {
            String len = String.valueOf(barLength);
            String wid = String.valueOf(barWidth);
            return len + " by " + wid + " bar of " + chocolateType + " chocolate";
        }
    }
    /**
   * This method is used to print out the shape of the bar.
   */
    public void drawBar() {
        String name = chocolateType.toUpperCase();
        char oneChar = name.charAt(0);
        for (int i = 0; i < barLength; i++) {
            for (int j = 0; j < barWidth; j++) {
                System.out.print(oneChar);
            }
            System.out.println();
        }
    }
}