import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Message {
    private int id;
    private int roomId;
    private int senderId;
    private String content;
    private Timestamp sentAt;

    public Message(int id, int roomId, int senderId, String content, Timestamp sentAt) {
        this.id = id;
        this.roomId = roomId;
        this.senderId = senderId;
        this.content = content;
        this.sentAt = sentAt;
    }

    // Getters
    public int getId() { return id; }
    public int getRoomId() { return roomId; }
    public int getSenderId() { return senderId; }
    public String getContent() { return content; }
    public Timestamp getSentAt() { return sentAt; }

    // DAO methods
    public static Message create(int roomId, int senderId, String content) throws SQLException {
        String sql = "INSERT INTO messages (room_id, sender_id, content) VALUES (?, ?, ?)";
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, roomId);
            stmt.setInt(2, senderId);
            stmt.setString(3, content);
            stmt.executeUpdate();

            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    int id = rs.getInt(1);
                    return new Message(id, roomId, senderId, content, null);
                }
            }
        }
        throw new SQLException("Creating message failed, no ID obtained.");
    }

    public static List<Message> getMessagesForRoom(int roomId) throws SQLException {
        List<Message> messages = new ArrayList<>();
        String sql = "SELECT * FROM messages WHERE room_id = ? ORDER BY sent_at ASC";
        try (Connection conn = DatabaseManager.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, roomId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    messages.add(new Message(
                            rs.getInt("id"),
                            rs.getInt("room_id"),
                            rs.getInt("sender_id"),
                            rs.getString("content"),
                            rs.getTimestamp("sent_at")
                    ));
                }
            }
        }
        return messages;
    }
}