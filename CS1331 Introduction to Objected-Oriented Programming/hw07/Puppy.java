    /** I worked on the homework assignment alone, using only course materials.*/
import java.util.Random;
    /**
    * Create Puppy class which represents whether the puppy could be adopted
    * @author Jim Liu
    * @version 7.1
    */
public class Puppy {
    private static Random r = new Random();
    private String name;
    private int age;
    private int health;
    private static int start = 5;
    private static int stop = 35;
    /**
    * This is a constructor.
    * @param name a string which is a puppy's name.
    * @param age an integer which is the age of the puppy.
    * @param health an integer which is the health of the puppy.
    */
    public Puppy(String name, int age, int health) {
        this.name = name;
        this.age = age;
        this.health = health;
    }
    /**
    * This is a constructor.
    * @param name a string which is a puppy's name.
    */
    public Puppy(String name) {
        this(name, r.nextInt(16), r.nextInt(stop - start + 1) + start);
    }
    /**
    * This is a getter.
    * @return name a string which is a puppy's name.
    */
    public String getName() {
        return name;
    }
    /**
    * This is a setter.
    * @param name a string that represents a puppy's name you could set.
    */
    public void setName(String name) {
        this.name = name;
    }
    /**
    * This is a getter.
    * @return age an integer that represents a puppy's age.
    */
    public int getAge() {
        return age;
    }
   /**
    * This is a getter.
    * @param age an integer that represents the age of the puppy you could set.
    */
    public void setAge(int age) {
        this.age = age;
    }
   /**
    * This is a getter.
    * @return health an integer that represents the health of the puppy.
    */
    public int getHealth() {
        return health;
    }
   /**
    * This is a setter.
    * @param health an integer that represents the health of the puppy you could set.
    */
    public void setHealth(int health) {
        this.health = health;
    }
   /**
    * This is a method.
    * @return a string that represents a puppy's information.
    */
    public String toString() {
        String h = String.valueOf(health);
        String a = String.valueOf(age);
        return (name + ": a puppy " + a + " years old with " + h + " health");
    }
   /**
    * This is a method.
    * @return boolean that represents whether a puppy should be adopted.
    */
    public boolean canAdopt() {
        if (health >= 50) {
            return true;
        }
        return false;
    }
   /**
    * This is a method.
    * When using this method, a puppy's health will be increased by 1.
    */
    public void fetch() {
        health++;
    }
   /**
    * This is a method.
    * @param inside a boolean that represents whether fething is inside or not
    * The puppy's health will be increased by different numbers based on fetching inside or outside.
    */
    public void fetch(boolean inside) {
        if (inside) {
            health += 5;
        } else {
            health += 10;
        }
    }
   /**
    * This is a method.
    * @param distance an integer that represents the distance that a puppy goes over.
    * The puppy's health will be increased by different distance it goes over.
    */
    public void fetch(int distance) {
        double d = Integer.valueOf(distance);
        health += (int) d / 10;
    }
}