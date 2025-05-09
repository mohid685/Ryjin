import java.sql.*;
import java.util.*;
import java.util.concurrent.*;

public class ChatRoom {
    private final int roomId;
    private final String roomName;
    private final Set<ClientHandler> participants = ConcurrentHashMap.newKeySet();
    private final ExecutorService messageExecutor = Executors.newSingleThreadExecutor();

    public ChatRoom(int roomId, String roomName) {
        this.roomId = roomId;
        this.roomName = roomName;
    }

    public synchronized void addParticipant(ClientHandler client) {
        participants.add(client);
        broadcastSystemMessage(client.getUsername() + " has joined the room");
    }

    public synchronized void removeParticipant(ClientHandler client) {
        participants.remove(client);
        broadcastSystemMessage(client.getUsername() + " has left the room");
    }

    // Add this new method
    public synchronized int getParticipantCount() {
        return participants.size();
    }

    public void broadcastMessage(int senderId, String message) {
        messageExecutor.submit(() -> {
            try {
                // Save to database first
                Message.create(roomId, senderId, message);

                // Format message with timestamp
                String formatted = String.format("[%s] %s: %s",
                        new Timestamp(System.currentTimeMillis()),
                        User.findById(senderId).getUsername(),
                        message);

                // Broadcast to all participants
                synchronized (this) {
                    for (ClientHandler participant : participants) {
                        if (participant.getUserId() != senderId) {
                            participant.sendMessage(formatted);
                        }
                    }
                }
            } catch (SQLException e) {
                System.err.println("Error broadcasting message: " + e.getMessage());
            }
        });
    }

    public void broadcastSystemMessage(String message) {
        String formatted = "[SYSTEM] " + message;
        synchronized (this) {
            for (ClientHandler participant : participants) {
                participant.sendMessage(formatted);
            }
        }
    }

    public void sendHistory(ClientHandler client) throws SQLException {
        List<Message> messages = Message.getMessagesForRoom(roomId);
        client.sendMessage("\n--- Chat History for " + roomName + " ---");
        for (Message msg : messages) {
            User sender = User.findById(msg.getSenderId());
            client.sendMessage(String.format("[%s] %s: %s",
                    msg.getSentAt(),
                    sender.getUsername(),
                    msg.getContent()));
        }
        client.sendMessage("--- End of History ---\n");
    }

    public int getRoomId() { return roomId; }
    public String getRoomName() { return roomName; }
}