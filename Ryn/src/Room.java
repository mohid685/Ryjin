import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Room {
    private int id;
    private String name;
    private int createdBy;
    private Timestamp createdAt;

    public Room(int id, String name, int createdBy, Timestamp createdAt) {
        this.id = id;
        this.name = name;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
    }

    // Getters
    public int getId() { return id; }
    public String getName() { return name; }
    public int getCreatedBy() { return createdBy; }
    public Timestamp getCreatedAt() { return createdAt; }

    // DAO Methods

    public static Room create(String name, int createdBy) throws SQLException {
        String sql = "INSERT INTO rooms (name, created_by) VALUES (?, ?)";
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, name);
            stmt.setInt(2, createdBy);
            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    int id = rs.getInt(1);
                    return new Room(id, name, createdBy, null);
                }
            }
        }
        throw new SQLException("Creating room failed, no ID obtained.");
    }

    public static Room findByName(String name) throws SQLException {
        String sql = "SELECT * FROM rooms WHERE name = ?";
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, name);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new Room(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getInt("created_by"),
                            rs.getTimestamp("created_at")
                    );
                }
            }
        }
        return null;
    }

    public static List<Room> getAllRooms() throws SQLException {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms";
        try (Connection conn = DatabaseManager.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                rooms.add(new Room(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getInt("created_by"),
                        rs.getTimestamp("created_at")
                ));
            }
        }
        return rooms;
    }

    public static void addParticipant(int roomId, int userId) throws SQLException {
        // First check if user is already in the room
        String checkSql = "SELECT 1 FROM room_participants WHERE room_id = ? AND user_id = ?";
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {

            checkStmt.setInt(1, roomId);
            checkStmt.setInt(2, userId);
            try (ResultSet rs = checkStmt.executeQuery()) {
                if (rs.next()) {
                    return; // User already in room
                }
            }
        }

        // Add user to room
        String sql = "INSERT INTO room_participants (room_id, user_id) VALUES (?, ?)";
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, roomId);
            stmt.setInt(2, userId);
            stmt.executeUpdate();
        }
    }

    public static List<User> getParticipants(int roomId) throws SQLException {
        List<User> participants = new ArrayList<>();
        String sql = "SELECT u.* FROM users u JOIN room_participants rp ON u.id = rp.user_id WHERE rp.room_id = ?";
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, roomId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    participants.add(new User(
                            rs.getInt("id"),
                            rs.getString("username"),
                            rs.getString("password"),
                            rs.getTimestamp("created_at")
                    ));
                }
            }
        }
        return participants;
    }
}
