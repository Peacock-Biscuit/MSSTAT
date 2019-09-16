    /** I worked on the homework assignment alone, using only course materials.*/
    /**
    * Create User class and User's info
    * @author Jim Liu
    * @version 6.1
    */
public class User {
    private String username;
    private int password;
    private static int numUsers = 0;
    private static User newestUser;
    private static boolean displayNewest = true;
    /**
    * This is a User constructor.
    * @param username a string that shows the name of the user
    * @param password an integer that means password
    */
    public User(String username, int password) {
        this.username = username;
        this.password = password;
        numUsers++;
        newestUser = this;
    }
    /**
    * This is a method that returns void
    * @param displayNewest a boolean that means whether an user is newest or not
    */
    public static void setDisplayNewest(boolean displayNewest) {
        User.displayNewest = displayNewest;
    }
    /**
    * This is a getter that we want to know the number of users.
    * @return an integer that represents the number of users.
    */
    public static int getNumUsers() {
        return numUsers;
    }
    /**
    * This is a getter that we want to know the username.
    * @return a string that represents username.
    */
    public String getUsername() {
        return username;
    }
    /**
    * This is a getter that return a string.
    * @return a string that shows different welcomemessage under different conditions.
    */
    public static String getWelcomeMessage() {
        if (numUsers == 0) {
            return "This site doesn't have any users yet!";
        } else if (numUsers >= 1 && displayNewest) {
            return newestUser.getUsername() + " just joined our site! Please give them a warm welcome!";
        } else {
            String num = String.valueOf(numUsers);
            return "Welcome to our site! We have " + num + " user(s) and counting!";
        }
    }
    /**
    * This is a method that returns void
    * @param usernameInput a string that shows where an user types his name
    * @param passwordInput an integer that shows where an user types passwords
    * @param newPassword an integer that updates users' passwords
    */
    public void changePassword(String usernameInput, int passwordInput, int newPassword) {
        if (usernameInput == this.username && passwordInput == this.password) {
            this.password = newPassword;
        }
    }
    /**
    * @param usernameInput a string that shows where an user types his name
    * @param passwordInput an integer that shows where an user types passwords
    * @return a boolean that shows whether what users type is the same as their true passwords and names
    */
    public boolean validLogin(String usernameInput, int passwordInput) {
        if (usernameInput == this.username && passwordInput == this.password) {
            return true;
        }
        return false;
    }
}