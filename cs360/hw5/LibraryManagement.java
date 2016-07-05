import java.sql.*;
import java.util.Scanner;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.concurrent.Callable;

public class LibraryManagement {
    private static final String DBID = "censored";
    private static final String DBPW = "censored";

    private static final String separator = "---------------------------------------------------------------------";

    private static SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    private static Scanner sc;
    private static Connection con;

    private static void searchBooks() {
        System.out.print("title: ");
        String book = sc.nextLine();

        PreparedStatement stmt = null;
        try {
            String query = "SELECT * FROM BookLoanInfo WHERE UPPER(title) LIKE ? ORDER BY bid";

            stmt = con.prepareStatement(query);
            stmt.setString(1, "%" + book.toUpperCase() + "%");
            ResultSet rs = stmt.executeQuery();

            System.out.printf("%3s\t%40s\t%-20s\n", "bid", "title", "status");
            System.out.println(separator);
            while (rs.next()) {
                String status = "Available";
                Date t = rs.getDate(3);
                if (t != null)
                    status = "Loaned until " + dateFormat.format(t);
                System.out.printf("%3d\t%40s\t%-20s\n", rs.getInt(1), rs.getString(2), status);
            }

        } catch (Exception e) {
            System.out.print(e.getMessage());
        } finally {
            try {
                if (stmt != null) stmt.close();
            } catch (Exception e) {}
        }
    }

    private static void loanBook() {
        System.out.print("enter member id: ");
        int mid = sc.nextInt(); sc.nextLine();
        System.out.print("enter book id: ");
        int bid = sc.nextInt(); sc.nextLine();

        CallableStatement cs = null;
        try {
            cs = con.prepareCall("{call loan_book(?, ?)}");
            cs.setInt(1, mid);
            cs.setInt(2, bid);
            cs.execute();

            System.out.println("Loan is successfully processed");
        } catch (Exception e) {
            System.out.print(e.getMessage());
        }
    }

    private static void returnBook() {
        System.out.print("enter book id: ");
        int bid = sc.nextInt(); sc.nextLine();

        CallableStatement cs = null;
        try {
            cs = con.prepareCall("{? = call return_book(?)}");
            cs.registerOutParameter(1, Types.NUMERIC);
            cs.setInt(2, bid);
            cs.execute();

            System.out.println("Book is successfully returned");
            System.out.println("A late fee of the book is " + cs.getInt(1) + " Won.");
        } catch (Exception e) {
            System.out.print(e.getMessage());
        }
    }

    private static void getLateFee() {
        System.out.print("enter book id: ");
        int bid = sc.nextInt(); sc.nextLine();

        CallableStatement cs = null;
        try {
            cs = con.prepareCall("{? = call get_late_fee(?)}");
            cs.registerOutParameter(1, Types.NUMERIC);
            cs.setInt(2, bid);
            cs.execute();

            System.out.println("A late fee of the book is " + cs.getInt(1) + " Won.");
        } catch (Exception e) {
            System.out.print(e.getMessage());
        }
    }

    private static void extendDueDate() {
        System.out.print("enter member id: ");
        int mid = sc.nextInt(); sc.nextLine();
        System.out.print("enter book id: ");
        int bid = sc.nextInt(); sc.nextLine();

        CallableStatement cs = null;
        try {
            cs = con.prepareCall("{call extend_due(?, ?)}");
            cs.setInt(1, mid);
            cs.setInt(2, bid);
            cs.execute();

            System.out.println("Due is successfully extended");
        } catch (Exception e) {
            System.out.print(e.getMessage());
        }
    }

    public static void main(String[] args)  {
        sc = new Scanner(System.in);

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            con = DriverManager.getConnection( "jdbc:oracle:thin:@censored:orcl", DBID, DBPW);

            String command;
            while (true) {
                System.out.println("[Library Loan Management System]");
                System.out.println(separator);
                System.out.println("[0] Quit\t[1] Search by a book title\t[2] Loan");
                System.out.println("[3] Return\t[4] Estimate late fee\t[5] Extend due date");
                System.out.print("Menu > ");
                command = sc.nextLine();

                if (command.equals("0"))
                    break;
                else if (command.equals("1"))
                    searchBooks();
                else if (command.equals("2"))
                    loanBook();
                else if (command.equals("3"))
                    returnBook();
                else if (command.equals("4"))
                    getLateFee();
                else if (command.equals("5"))
                    extendDueDate();
                else
                    System.out.println("Unknown command!");
                System.out.println();
            }
        } catch (Exception e) {
        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception e) { }
        }
    }
}
