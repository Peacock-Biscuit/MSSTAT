    /** I worked on the homework assignment alone, using only course materials.*/
    /**
    * Create Bar class and print out the shape of bars
    * @author Jim Liu
    * @version 5.1
    */
public class WaterFountain {
    private String modelName;
    private boolean requiresMaintenance;
    private int cupsPoured = 1;
    private static int totalWaterFountains = 0;
    public static final String SOFTWARE_VERSION = "2.0.0";
    /**
    * This is a constructor.
    * @param modelName a string which is the fountain's name.
    * @param cupsPoured a intger which is the number of cups of water.
    */
    public WaterFountain(String modelName, int cupsPoured) {
        this.modelName = modelName;
        this.cupsPoured = cupsPoured;
        requiresMaintenance = false;
        totalWaterFountains++;
    }
    /**
    * This is a getter
    * @return modelName
    */
    public String getmodelName() {
        return modelName;
    }
    /**
    * This is a setter.
    * @return modelName
    */
    public String setmodelName() {
        return modelName;
    }
    /**
    * This is a getter.
    * @return boolean whether the fountain need to be fixed.
    */
    public boolean isrequiresMaintenance() {
        return requiresMaintenance;
    }
    /**
    * This is a setter.
    * @param reqMaintenance a boolean show if a fountain needs to be fixed.
    */
    public void setrequiresMaintenance(boolean reqMaintenance) {
        this.requiresMaintenance = requiresMaintenance;
    }
    /**
    * This is a getter that returns the number of cups of water.
    * @return the integer that represents the number of cups of water.
    */
    public int getCupsPoured() {
        return cupsPoured;
    }
    /**
    * This is a setter that returns the number of cups of water.
    * @return the integer that shows the number of cups of water.
    */
    public int setCupsPoured() {
        return cupsPoured;
    }
     /**
    * This is a getter that returns the number of water fountains that have been created.
    * @return the integer that represents the number of foundtains.
    */
    public static int gettotalWaterFountains() {
        return totalWaterFountains;
    }
    /**
    * This is a method that if foundains need to be fixed, the number of cups of water increases.
    */
    public void pourCup() {
        if (!this.requiresMaintenance) {
            cupsPoured++;
        }
    }
    /**
    * This is a method that check if two fountains are same.
    * @param other a constructor used for comparison.
    * @return a boolean that represents two fountains are same
    */
    public boolean equals(WaterFountain other) {
        return (this.modelName == other.modelName
            && this.cupsPoured == other.cupsPoured
            && this.SOFTWARE_VERSION == other.SOFTWARE_VERSION);
    }
    /**
    * This is a method that return a string
    * @return a string to show infomation of water fountains
    */
    public String toString() {
        if (requiresMaintenance) {
            String cups = String.valueOf(cupsPoured);
            return (modelName
                + " has poured "
                + cups
                + " cups, requires maintenance, and is running version: "
                + SOFTWARE_VERSION);
        } else {
            String cups = String.valueOf(cupsPoured);
            return (modelName
                + " has poured "
                + cups
                + " cups, does not require maintenance, and is running version: "
                + SOFTWARE_VERSION);
        }

    }
}