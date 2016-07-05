import java.sql.*;
import java.util.Scanner;
import java.util.Date;
import java.text.SimpleDateFormat;

public class SimpleBank {
    private static final String DBID = "censored";
    private static final String DBPW = "censored";

    private static final String separator = "---------------------------------------------------------------------";

    private static SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    private static Scanner sc;
    private static Connection con;

    private static Boolean existUser(String id) throws Exception
    {
        String query = String.format("SELECT * FROM USERS WHERE UserID = '%s'",
                id);
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery(query);

        Boolean result = rs.next();
        stmt.close();
        return result;
    }

    private static int getBalance(String username) throws Exception {
        String query = String.format("SELECT * FROM USERS WHERE UserID = '%s'", username);
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery(query);

        int money = 0;
        if (rs.next())
            money = rs.getInt(3);
        stmt.close();
        return money;
    }

    private static void register() throws Exception
    {
        String id;
        while (true) {
            System.out.print("ID: ");
            id = sc.nextLine();

            if (existUser(id))
                System.out.println("same ID exists");
            else
                break;
        }
        System.out.print("Password: ");
        String password = sc.nextLine();

        String query = String.format("INSERT INTO USERS VALUES ('%s', '%s', 0)",
                id, password);
        Statement stmt = con.createStatement();
        stmt.executeUpdate(query);
        stmt.close();

        System.out.println("new account " + id + " is created");
    }

    private static String init() throws Exception
    {
        int warningCount = 0;
        while (true) {
            System.out.println("CS360\tSimple Bank");
            System.out.println("please type 'new' to create a new account");
            System.out.print("user name: ");
            String username = sc.nextLine();
            if (username.equals("new")) { register(); continue; }

            System.out.print("password: ");
            String password = sc.nextLine();

            String query = String.format("SELECT * FROM USERS WHERE UserID = '%s' AND Passwd = '%s'",
                    username, password);
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery(query);

            if (rs.next()) {
                System.out.println("\n" + separator);
                System.out.println(username + "'s total amount: " + rs.getInt(3));
                System.out.println(separator);

                stmt.close();
                return username;
            }
            stmt.close();
            warningCount++;
            System.out.println("invalid username / password");
            if (warningCount == 3) {
                System.out.println("unable to log-in to Simple Bank after 3 attempts");
                throw new Exception();
            }
        }
    }

    private static void list(String username) throws Exception
    {
        String query = String.format("SELECT * FROM LOGS WHERE UserID = '%s'", username);
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery(query);

        System.out.println("CS360\tSimple Bank Log");
        System.out.println(separator);
        System.out.printf("%-10s\t%-15s\t%-10s\t%-10s\t%-10s\n", "Date", "Mode", "From", "To", "Money");
        System.out.println(separator);

        while (rs.next()) {
            Date t = rs.getDate(1);
            String mode = rs.getString(3), otherId = rs.getString(4);
            int moneyIn = rs.getInt(5), moneyOut = rs.getInt(6), moneyDiff = moneyIn - moneyOut;
            String from = "", to = "";
            if (mode.equals("DEPOSIT")) { from = "null"; to = username; }
            else if (mode.equals("WITHDRAW")) { from = username; to = "null"; }
            else if (mode.equals("SEND")) { from = username; to = otherId; }
            else if (mode.equals("RECEIVE")) { from = otherId; to = username; }

            String moneyStr = "";
            if (moneyDiff > 0)
                moneyStr = "+" + moneyDiff;
            else
                moneyStr = "" + moneyDiff;
            System.out.printf("%-10s\t%-15s\t%-10s\t%-10s\t%s\n", t, mode, from, to, moneyStr);
        }

        stmt.close();
    }

    private static void deposit(String username) throws Exception {
        System.out.print("Deposit Money: ");
        int money = sc.nextInt();
        sc.nextLine();
        if (money <= 0) {
            System.out.println("Cannot deposit non-positive amount.");
            return;
        }

        try {
            con.setAutoCommit(false);

            String query = String.format("UPDATE USERS SET UserMoney = UserMoney + %d WHERE UserID = '%s'",
                    money, username);
            Statement stmt = con.createStatement();
            stmt.executeUpdate(query);
            stmt.close();

            stmt = con.createStatement();
            query = String.format("INSERT INTO LOGS VALUES (DATE'%s', '%s', 'DEPOSIT', NULL, %d, 0)",
                    dateFormat.format(new Date()), username, money);
            stmt.executeUpdate(query);
            stmt.close();
            con.commit();

            System.out.println("\n" + separator);
            System.out.println(username + "'s total amount: " + getBalance(username));
            System.out.println(separator);
        } catch (Exception e) {
            con.rollback();
        }
    }

    private static void withdraw(String username) throws Exception {
        System.out.print("Withdraw Money: ");
        int money = sc.nextInt();
        sc.nextLine();
        if (money <= 0) {
            System.out.println("Cannot withdraw non-positive amount.");
            return;
        }

        try {
            con.setAutoCommit(false);

            String query = String.format("UPDATE USERS SET UserMoney = UserMoney - %d WHERE UserID = '%s'",
                    money, username);
            Statement stmt = con.createStatement();
            stmt.executeUpdate(query);
            stmt.close();

            int balance = getBalance(username);
            if (balance < 0) {
                System.out.println("Out of Money!!!");
                throw new Exception();
            }

            stmt = con.createStatement();
            query = String.format("INSERT INTO LOGS VALUES (DATE'%s', '%s', 'WITHDRAW', NULL, 0, %d)",
                    dateFormat.format(new Date()), username, money);;
            stmt.executeUpdate(query);
            stmt.close();
            con.commit();

            System.out.println("\n" + separator);
            System.out.println(username + "'s total amount: " + balance);
            System.out.println(separator);
        } catch (Exception e) {
            con.rollback();
        }
    }

    private static void send(String username) throws Exception {
        System.out.print("Enter a user for sending: ");
        String userto = sc.nextLine();
        if (!existUser(userto)) {
            System.out.println("No user");
            return;
        }

        System.out.print("Send Money: ");
        int money = sc.nextInt();
        sc.nextLine();
        if (money <= 0) {
            System.out.println("Cannot send non-positive amount.");
            return;
        }

        try {
            con.setAutoCommit(false);

            String query = String.format("UPDATE USERS SET UserMoney = UserMoney - %d WHERE UserID = '%s'",
                    money, username);
            Statement stmt = con.createStatement();
            stmt.executeUpdate(query);
            stmt.close();

            int balance = getBalance(username);
            if (balance < 0) {
                System.out.println("Out of Money!!!");
                throw new Exception();
            }

            query = String.format("UPDATE USERS SET UserMoney = UserMoney + %d WHERE UserID = '%s'",
                    money, userto);
            stmt = con.createStatement();
            stmt.executeUpdate(query);
            stmt.close();

            stmt = con.createStatement();
            query = String.format("INSERT INTO LOGS VALUES (DATE'%s', '%s', 'SEND', '%s', 0, %d)",
                    dateFormat.format(new Date()), username, userto, money);;
            stmt.executeUpdate(query);
            stmt.close();

            stmt = con.createStatement();
            query = String.format("INSERT INTO LOGS VALUES (DATE'%s', '%s', 'RECEIVE', '%s', %d, 0)",
                    dateFormat.format(new Date()), userto, username, money);;
            stmt.executeUpdate(query);
            stmt.close();
            con.commit();

            System.out.println("\n" + separator);
            System.out.println(username + "'s total amount: " + balance);
            System.out.println(separator);
        } catch (Exception e) {
            con.rollback();
        }
    }

    public static void main(String[] args)  {
        sc = new Scanner(System.in);

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");

            con = DriverManager.getConnection( "jdbc:oracle:thin:@censored:orcl", DBID, DBPW);
            System.out.println("Connection created!");

            String username = init();
            String command;

            while (true) {
                System.out.print("command: ");
                command = sc.nextLine();
                if (command.equals("q")) break;
                else if (command.equals("l")) list(username);
                else if (command.equals("d")) deposit(username);
                else if (command.equals("w")) withdraw(username);
                else if (command.equals("s")) send(username);
                else System.out.println("Unknown command!");
            }
            System.out.println("Bye!");
        } catch (Exception e) {
        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception e) { }
        }
    }
}
