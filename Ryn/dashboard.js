// WebSocket connection
let socket = null;
let currentUser = null;
let currentRoom = null;

// DOM Elements
const dashboardContainer = document.getElementById('dashboardContainer');
const usernameDisplay = document.getElementById('username');
const roomsList = document.getElementById('roomsList');
const createRoomModal = document.getElementById('createRoomModal');
const createRoomForm = document.getElementById('createRoomForm');
const cancelCreateRoomBtn = document.getElementById('cancelCreateRoom');
const createRoomBtn = document.getElementById('createRoomBtn');
const logoutBtn = document.getElementById('logoutBtn');

// Initialize WebSocket connection
function connectWebSocket() {
    const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
    socket = new WebSocket(`${protocol}//${window.location.hostname}:12345`);

    socket.onopen = () => {
        console.log('Connected to server');
        // Request available rooms
        socket.send('3');
    };

    socket.onmessage = (event) => {
        const message = event.data;
        console.log('Received:', message);

        if (message.includes('Available rooms:')) {
            const rooms = [];
            const lines = message.split('\n');
            for (let i = 1; i < lines.length; i++) {
                const line = lines[i];
                if (line.startsWith('-')) {
                    const match = line.match(/- (.+) \(created by user ID: (\d+)\)/);
                    if (match) {
                        rooms.push({ name: match[1], createdBy: match[2] });
                    }
                }
            }
            displayRooms(rooms);
        }
    };

    socket.onclose = () => {
        console.log('Disconnected from server');
        setTimeout(connectWebSocket, 3000);
    };
}

// Room Management
function displayRooms(rooms) {
    roomsList.innerHTML = rooms.map((room, index) => `
        <div class="room-card" onclick="joinRoom(${index + 1})">
            <h3>${room.name}</h3>
        </div>
    `).join('');
}

function joinRoom(roomNumber) {
    socket.send(`join:${roomNumber}`);
    // Redirect to chat room
    window.location.href = `index.html?room=${roomNumber}`;
}

// Modal Management
function showCreateRoomModal() {
    createRoomModal.classList.add('active');
    document.getElementById('roomNameInput').focus();
}

function hideCreateRoomModal() {
    createRoomModal.classList.remove('active');
    document.getElementById('roomNameInput').value = '';
}

// Event Listeners
createRoomBtn.addEventListener('click', showCreateRoomModal);
cancelCreateRoomBtn.addEventListener('click', hideCreateRoomModal);
document.querySelector('.modal-overlay').addEventListener('click', hideCreateRoomModal);

createRoomForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const roomNameInput = document.getElementById('roomNameInput');
    const newRoomName = roomNameInput.value.trim();

    if (newRoomName) {
        const submitBtn = createRoomForm.querySelector('button[type="submit"]');
        submitBtn.disabled = true;
        submitBtn.textContent = 'Creating...';
        
        socket.send(`create:${newRoomName}`);
        
        setTimeout(() => {
            if (submitBtn.textContent === 'Creating...') {
                alert('Room creation timed out');
                submitBtn.disabled = false;
                submitBtn.textContent = 'Create Room';
            }
        }, 5000);
    }
});

logoutBtn.addEventListener('click', () => {
    socket.close();
    window.location.href = 'index.html';
});

// Initialize
document.addEventListener('DOMContentLoaded', function() {
    // Get username from URL parameters
    const urlParams = new URLSearchParams(window.location.search);
    const username = urlParams.get('username');
    
    if (username) {
        currentUser = { username: username };
        usernameDisplay.textContent = username;
        connectWebSocket();
    } else {
        // Redirect to login if no username
        window.location.href = 'index.html';
    }
});

// Make joinRoom global
window.joinRoom = joinRoom;