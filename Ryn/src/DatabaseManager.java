import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseManager {
    private static final String URL = "jdbc:mysql://localhost:3306/gtr_chat";
    private static final String USER = "root"; // Change to your MySQL username
    private static final String PASSWORD = "mohidrich6"; // Change to your MySQL password

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Failed to load MySQL JDBC driver", e);
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}