import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.Base64;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class WebSocketServer {
    private static final int PORT = 12345;

    public static void main(String[] args) {
        // Test database connection
        try {
            DatabaseManager.getConnection();
            System.out.println("Database connection established successfully.");
        } catch (SQLException e) {
            System.err.println("Failed to connect to database: " + e.getMessage());
            return;
        }

        try (ServerSocket serverSocket = new ServerSocket(PORT)) {
            System.out.println("WebSocket Server is listening on port " + PORT);

            while (true) {
                Socket socket = serverSocket.accept();
                System.out.println("New client connected from: " + socket.getInetAddress());

                // Create a new thread for each client
                new Thread(new ClientHandler(socket)).start();
            }
        } catch (IOException e) {
            System.err.println("Server exception: " + e.getMessage());
        }
    }

    
    // WebSocket utility class
    public static class WebSocketUtils {
        private static final String WEBSOCKET_GUID = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11";

        // Parse WebSocket handshake request to get Sec-WebSocket-Key
        public static String parseWebSocketKey(String handshakeRequest) {
            Pattern pattern = Pattern.compile("Sec-WebSocket-Key: (.*)");
            Matcher matcher = pattern.matcher(handshakeRequest);
            if (matcher.find()) {
                return matcher.group(1).trim();
            }
            return null;
        }

        // Generate WebSocket accept key for handshake response
        public static String generateAcceptKey(String webSocketKey) {
            try {
                String concatenated = webSocketKey + WEBSOCKET_GUID;
                MessageDigest sha1 = MessageDigest.getInstance("SHA-1");
                byte[] hash = sha1.digest(concatenated.getBytes());
                return Base64.getEncoder().encodeToString(hash);
            } catch (NoSuchAlgorithmException e) {
                throw new RuntimeException("Error generating WebSocket accept key", e);
            }
        }

        // Create handshake response
        public static String createHandshakeResponse(String webSocketKey) {
            String acceptKey = generateAcceptKey(webSocketKey);
            return "HTTP/1.1 101 Switching Protocols\r\n" +
                    "Upgrade: websocket\r\n" +
                    "Connection: Upgrade\r\n" +
                    "Sec-WebSocket-Accept: " + acceptKey + "\r\n\r\n";
        }

        // Decode a WebSocket frame
        public static String decodeWebSocketFrame(byte[] buffer, int len) {
            if (len < 2) return "";

            byte[] decoded = new byte[len - 6];  // Adjust based on mask size
            byte[] mask = new byte[4];

            int payloadStart = 2;
            int payloadLength = buffer[1] & 0x7F;  // Get 7 bits for payload length

            if (payloadLength == 126) {
                payloadStart = 4;  // Extended payload length (16 bits)
            } else if (payloadLength == 127) {
                payloadStart = 10;  // Extended payload length (64 bits)
            }

            System.arraycopy(buffer, payloadStart, mask, 0, 4);
            payloadStart += 4;

            int dataLength = len - payloadStart;
            for (int i = 0; i < dataLength && i < decoded.length; i++) {
                decoded[i] = (byte) (buffer[payloadStart + i] ^ mask[i % 4]);
            }

            return new String(decoded, 0, Math.min(dataLength, decoded.length));
        }

        // Encode a message as WebSocket frame
        public static byte[] encodeWebSocketFrame(String message) {
            byte[] payload = message.getBytes();
            int payloadLength = payload.length;

            ByteArrayOutputStream frame = new ByteArrayOutputStream();

            // FIN bit set, opcode = 1 (text frame)
            frame.write(0x81);

            // Payload length
            if (payloadLength <= 125) {
                frame.write(payloadLength);
            } else if (payloadLength <= 65535) {
                frame.write(126);
                frame.write((payloadLength >> 8) & 0xFF);
                frame.write(payloadLength & 0xFF);
            } else {
                frame.write(127);
                frame.write(0); // We're not supporting 64-bit lengths properly
                frame.write(0);
                frame.write(0);
                frame.write(0);
                frame.write((payloadLength >> 24) & 0xFF);
                frame.write((payloadLength >> 16) & 0xFF);
                frame.write((payloadLength >> 8) & 0xFF);
                frame.write(payloadLength & 0xFF);
            }

            // Write payload
            try {
                frame.write(payload);
            } catch (IOException e) {
                e.printStackTrace();
            }

            return frame.toByteArray();
        }
    }
}