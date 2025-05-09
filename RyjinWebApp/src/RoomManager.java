import java.util.concurrent.*;

public class RoomManager {
    private static RoomManager instance;
    private final ConcurrentMap<Integer, ChatRoom> activeRooms = new ConcurrentHashMap<>();
    private final ExecutorService roomExecutor = Executors.newCachedThreadPool();

    private RoomManager() {}

    public static synchronized RoomManager getInstance() {
        if (instance == null) {
            instance = new RoomManager();
        }
        return instance;
    }

    public ChatRoom getOrCreateRoom(int roomId, String roomName) {
        return activeRooms.computeIfAbsent(roomId,
                id -> new ChatRoom(id, roomName));
    }

    public void joinRoom(int roomId, String roomName, ClientHandler client) {
        roomExecutor.submit(() -> {
            ChatRoom room = getOrCreateRoom(roomId, roomName);
            room.addParticipant(client);
        });
    }

    public void leaveRoom(int roomId, ClientHandler client) {
        roomExecutor.submit(() -> {
            ChatRoom room = activeRooms.get(roomId);
            if (room != null) {
                room.removeParticipant(client);
                if (room.getParticipantCount() == 0) {  // Now this will work
                    activeRooms.remove(roomId);
                }
            }
        });
    }

    public void broadcastMessage(int roomId, int senderId, String message) {
        ChatRoom room = activeRooms.get(roomId);
        if (room != null) {
            room.broadcastMessage(senderId, message);
        }
    }
}