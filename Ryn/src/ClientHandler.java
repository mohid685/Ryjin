import java.io.*;
import java.net.Socket;
import java.sql.*;
import java.util.List;

public class ClientHandler implements Runnable {
    private Socket clientSocket;
    private InputStream in;
    private OutputStream out;
    private User currentUser;
    private Room currentRoom;
    private boolean handshakeComplete = false;

    public ClientHandler(Socket socket) {
        this.clientSocket = socket;
        try {
            in = clientSocket.getInputStream();
            out = clientSocket.getOutputStream();
        } catch (IOException e) {
            System.err.println("Error setting up streams: " + e.getMessage());
        }
    }

    @Override
    public void run() {
        try {
            // First, handle WebSocket handshake
            completeHandshake();

            // After handshake, handle client requests
            handleClient();
        } catch (IOException e) {
            System.err.println("Client disconnected: " + e.getMessage());
        } finally {
            try {
                clientSocket.close();
            } catch (IOException e) {
                System.err.println("Error closing socket: " + e.getMessage());
            }
        }
    }

    private void completeHandshake() throws IOException {
        // Read the handshake request
        byte[] buffer = new byte[8192];
        int bytesRead = in.read(buffer);
        String handshakeRequest = new String(buffer, 0, bytesRead);
        System.out.println("Received handshake:\n" + handshakeRequest);

        // Parse the WebSocket key
        String webSocketKey = WebSocketServer.WebSocketUtils.parseWebSocketKey(handshakeRequest);
        if (webSocketKey == null) {
            System.err.println("Invalid WebSocket handshake");
            return;
        }

        // Generate and send handshake response
        String handshakeResponse = WebSocketServer.WebSocketUtils.createHandshakeResponse(webSocketKey);
        out.write(handshakeResponse.getBytes());
        out.flush();

        handshakeComplete = true;
        System.out.println("WebSocket handshake completed");
    }

    public int getUserId() {
        return currentUser != null ? currentUser.getId() : -1;
    }

    public void sendMessage(String message) {
        try {
            byte[] encodedMessage = WebSocketServer.WebSocketUtils.encodeWebSocketFrame(message);
            out.write(encodedMessage);
            out.flush();
        } catch (IOException e) {
            System.err.println("Error sending message: " + e.getMessage());
        }
    }

    private void handleClient() throws IOException {
        sendMessage("Welcome to GTR Chat Server!");

        boolean authenticated = false;
        boolean running = true;
        byte[] buffer = new byte[8192];

        while (running) {
            try {
                int bytesRead = in.read(buffer);
                if (bytesRead == -1) {
                    // Client disconnected
                    break;
                }

                String message = WebSocketServer.WebSocketUtils.decodeWebSocketFrame(buffer, bytesRead);
                System.out.println("Received: " + message);

                if (!authenticated) {
                    // Handle authentication
                    if (message.equals("1")) {
                        sendMessage("Enter username:");
                    } else if (message.equals("2")) {
                        sendMessage("Enter new username:");
                    } else if (message.startsWith("1.")) {
                        // Login format: "1.username.password"
                        String[] parts = message.split("\\.", 3);
                        if (parts.length == 3) {
                            authenticated = handleLogin(parts[1], parts[2]);
                        }
                    } else if (message.startsWith("2.")) {
                        // Register format: "2.username.password"
                        String[] parts = message.split("\\.", 3);
                        if (parts.length == 3) {
                            handleRegister(parts[1], parts[2]);
                        }
                    } else {
                        // Regular login flow
                        if (authenticated == false) {
                            authenticated = handleLoginFlow(message);
                        }
                    }
                } else {
                    // Main menu and chat logic
                    handleAuthenticated(message);
                }
            } catch (IOException e) {
                System.err.println("Error reading client message: " + e.getMessage());
                break;
            }
        }

        // Handle cleanup when client disconnects
        if (currentRoom != null) {
            try {
                RoomManager.getInstance().leaveRoom(currentRoom.getId(), this);
            } catch (Exception e) {
                System.err.println("Error leaving room: " + e.getMessage());
            }
        }
    }

    // Our login state machine
    private boolean loginState = false;
    private String loginUsername = null;

    private boolean handleLoginFlow(String message) {
        try {
            if (loginState && loginUsername != null) {
                // This is the password entry
                String password = message;

                User user = User.findByUsername(loginUsername);
                if (user != null && user.getPassword().equals(password)) {
                    currentUser = user;
                    sendMessage("Login successful! Welcome, " + loginUsername);
                    loginState = false;
                    loginUsername = null;
                    return true;
                } else {
                    sendMessage("Invalid username or password");
                    loginState = false;
                    loginUsername = null;
                    return false;
                }
            } else if ("1".equals(message)) {
                // User selected login
                sendMessage("Enter username:");
                loginState = true;
                return false;
            } else if (loginState) {
                // This is the username entry
                loginUsername = message;
                sendMessage("Enter password:");
                return false;
            }
        } catch (SQLException e) {
            sendMessage("Database error: " + e.getMessage());
        }
        return false;
    }

    private boolean handleLogin(String username, String password) {
        try {
            User user = User.findByUsername(username);
            if (user != null && user.getPassword().equals(password)) {
                currentUser = user;
                sendMessage("Login successful! Welcome, " + username);
                return true;
            } else {
                sendMessage("Invalid username or password");
                return false;
            }
        } catch (SQLException e) {
            sendMessage("Database error: " + e.getMessage());
            return false;
        }
    }

    private void handleRegister(String username, String password) {
        try {
            if (User.findByUsername(username) != null) {
                sendMessage("Username already exists");
                return;
            }

            User user = User.create(username, password);
            sendMessage("Registration successful! You can now login.");
        } catch (SQLException e) {
            sendMessage("Registration failed: " + e.getMessage());
        }
    }

    private void handleAuthenticated(String message) {
        try {
            if (currentRoom == null) {
                // Main menu
                switch (message) {
                    case "1":
                        sendMessage("Enter room name:");
                        break;
                    case "2":
                        handleListRoomsForJoining();
                        break;
                    case "3":
                        handleListRooms();
                        break;
                    case "4":
                        sendMessage("Goodbye!");
                        clientSocket.close();
                        break;
                    default:
                        if (message.startsWith("create:")) {
                            String roomName = message.substring(7);
                            handleCreateRoom(roomName);
                        } else if (message.startsWith("join:")) {
                            int roomNumber = Integer.parseInt(message.substring(5));
                            handleJoinRoomByNumber(roomNumber);
                        } else {
                            // This might be a room name for creation
                            handleCreateRoom(message);
                        }
                }
            } else {
                // Chat room logic
                if ("/exit".equalsIgnoreCase(message)) {
                    RoomManager.getInstance().leaveRoom(currentRoom.getId(), this);
                    currentRoom = null;
                    sendMessage("\nMain Menu:\n1. Create Room\n2. Join Room\n3. List Rooms\n4. Exit\nChoose option:");
                } else if ("/users".equalsIgnoreCase(message)) {
                    listRoomParticipants();
                } else {
                    // Regular chat message
                    RoomManager.getInstance().broadcastMessage(
                            currentRoom.getId(),
                            currentUser.getId(),
                            message
                    );
                    // Echo back to sender
                    sendMessage("[" + new Timestamp(System.currentTimeMillis()) + "] You: " + message);
                }
            }
        } catch (Exception e) {
            sendMessage("Error processing request: " + e.getMessage());
        }
    }
    private void handleCreateRoom(String roomName) {
    try {
        if (Room.findByName(roomName) != null) {
            sendMessage("ERROR: Room name already exists");
            return;
        }

        Room room = Room.create(roomName, currentUser.getId());
        Room.addParticipant(room.getId(), currentUser.getId());
        currentRoom = room;
        
        // Send success message in consistent format
        sendMessage("ROOM_CREATED:" + room.getId() + ":" + room.getName());
        
        // Join through RoomManager
        RoomManager.getInstance().joinRoom(room.getId(), room.getName(), this);
        
        // Send room info
        sendMessage("\n=== Chat Room: " + room.getName() + " ===");
        sendMessage("You joined at: " + new Timestamp(System.currentTimeMillis()));
        sendMessage("Type '/exit' to leave the room");
        sendMessage("Type '/users' to list participants");

        // Send history
        ChatRoom chatRoom = RoomManager.getInstance()
                .getOrCreateRoom(room.getId(), room.getName());
        chatRoom.sendHistory(this);
    } catch (SQLException e) {
        sendMessage("ERROR: " + e.getMessage());
    }
}

    private void handleListRoomsForJoining() {
        try {
            List<Room> rooms = Room.getAllRooms();
            if (rooms.isEmpty()) {
                sendMessage("No rooms available");
                return;
            }

            StringBuilder response = new StringBuilder("Available rooms:\n");
            for (int i = 0; i < rooms.size(); i++) {
                response.append((i + 1)).append(". ").append(rooms.get(i).getName()).append("\n");
            }
            response.append("Enter room number to join:");
            sendMessage(response.toString());
        } catch (SQLException e) {
            sendMessage("Error listing rooms: " + e.getMessage());
        }
    }

    private void handleJoinRoomByNumber(int roomNumber) {
        try {
            List<Room> rooms = Room.getAllRooms();
            if (roomNumber < 1 || roomNumber > rooms.size()) {
                sendMessage("Invalid room number");
                return;
            }

            Room room = rooms.get(roomNumber - 1);
            Room.addParticipant(room.getId(), currentUser.getId());
            currentRoom = room;
            sendMessage("Joined room: " + room.getName());

            // Join the room through RoomManager
            RoomManager.getInstance().joinRoom(
                    currentRoom.getId(),
                    currentRoom.getName(),
                    this
            );

            // Send join notification and history
            sendMessage("\n=== Chat Room: " + currentRoom.getName() + " ===");
            sendMessage("You joined at: " + new Timestamp(System.currentTimeMillis()));
            sendMessage("Type '/exit' to leave the room");
            sendMessage("Type '/users' to list participants");

            // Get the ChatRoom instance
            ChatRoom chatRoom = RoomManager.getInstance()
                    .getOrCreateRoom(currentRoom.getId(), currentRoom.getName());
            chatRoom.sendHistory(this);
        } catch (SQLException e) {
            sendMessage("Error joining room: " + e.getMessage());
        }
    }

    private void handleListRooms() {
        try {
            List<Room> rooms = Room.getAllRooms();
            if (rooms.isEmpty()) {
                sendMessage("No rooms available");
                return;
            }

            StringBuilder response = new StringBuilder("Available rooms:\n");
            for (Room room : rooms) {
                response.append("- ").append(room.getName())
                        .append(" (created by user ID: ").append(room.getCreatedBy()).append(")\n");
            }
            sendMessage(response.toString());
        } catch (SQLException e) {
            sendMessage("Error listing rooms: " + e.getMessage());
        }
    }

    private void listRoomParticipants() {
        try {
            List<User> participants = Room.getParticipants(currentRoom.getId());
            StringBuilder response = new StringBuilder("Room participants:\n");
            for (User user : participants) {
                response.append("- ").append(user.getUsername()).append("\n");
            }
            sendMessage(response.toString());
        } catch (SQLException e) {
            sendMessage("Error listing participants: " + e.getMessage());
        }
    }

    public String getUsername() {
        return currentUser != null ? currentUser.getUsername() : "anonymous";
    }
}