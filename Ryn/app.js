// WebSocket connection
let socket = null;
let currentUser = null;
let currentRoom = null;

// Storage keys
const STORAGE_KEYS = {
    USER_PREFERENCES: 'userPreferences',
    LAST_ROOM: 'lastRoom',
    THEME: 'theme',
    CHAT_HISTORY: 'chatHistory'
};

// Storage management functions
function saveUserPreferences(preferences) {
    if (currentUser) {
        localStorage.setItem(
            `${STORAGE_KEYS.USER_PREFERENCES}_${currentUser.username}`,
            JSON.stringify(preferences)
        );
    }
}

function loadUserPreferences() {
    if (currentUser) {
        const preferences = localStorage.getItem(
            `${STORAGE_KEYS.USER_PREFERENCES}_${currentUser.username}`
        );
        if (preferences) {
            return JSON.parse(preferences);
        }
    }
    return {
        theme: 'dark',
        notifications: true,
        soundEnabled: true
    };
}

function saveLastRoom(room) {
    sessionStorage.setItem(STORAGE_KEYS.LAST_ROOM, JSON.stringify(room));
}

function clearSessionData() {
    sessionStorage.removeItem(STORAGE_KEYS.LAST_ROOM);
    sessionStorage.removeItem(STORAGE_KEYS.CHAT_HISTORY);
}

// Initialize session on page load
document.addEventListener('DOMContentLoaded', function() {
    // Check for existing session
    const username = getCookie('username');
    if (username) {
        // User is already logged in
        currentUser = { username: username };
        
        // Load user preferences from localStorage
        loadUserPreferences();
        
        // Restore last room if exists
        const lastRoom = sessionStorage.getItem(STORAGE_KEYS.LAST_ROOM);
        if (lastRoom) {
            currentRoom = JSON.parse(lastRoom);
            showChatRoom(currentRoom.name);
        } else {
            showDashboard();
        }
        
        connectWebSocket();
    } else {
        // No active session, show login
        showLoginTab();
        connectWebSocket();
    }
});

// DOM Elements
const authContainer = document.getElementById('authContainer');
const dashboardContainer = document.getElementById('dashboardContainer');
const chatContainer = document.getElementById('chatContainer');
const usernameDisplay = document.getElementById('username');
const roomsList = document.getElementById('roomsList');
const messagesContainer = document.getElementById('messagesContainer');
const messageForm = document.getElementById('messageForm');
const messageInput = document.getElementById('messageInput');
const roomName = document.getElementById('roomName');
const participantCount = document.getElementById('participantCount');
const createRoomModal = document.getElementById('createRoomModal');
const createRoomForm = document.getElementById('createRoomForm');
const cancelCreateRoomBtn = document.getElementById('cancelCreateRoom');
const createRoomBtn = document.getElementById('createRoomBtn');
const logoutBtn = document.getElementById('logoutBtn');
const leaveRoomBtn = document.getElementById('leaveRoomBtn');

// Auth Forms
const loginForm = document.getElementById('loginForm');
const registerForm = document.getElementById('registerForm');
const tabBtns = document.querySelectorAll('.tab-btn');


// Initialize WebSocket connection
function connectWebSocket() {
  const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
  socket = new WebSocket(`${protocol}//${window.location.hostname}:12345`);

  socket.onopen = () => {
      console.log('Connected to server');
  };

  
  
socket.onmessage = (event) => {
    const message = event.data;
    console.log('Received:', message);

    if (message.includes('Login successful')) {
        const username = document.getElementById('loginUsername').value;
        currentUser = { username: username };
        // Store user info in cookie
        setCookie('username', username, 1); // Expires in 1 day
        showDashboard();
    } else if (message.includes('Registration successful')) {
        alert('Registration successful! Please login.');
        showLoginTab();
    } else if (message.includes('Available rooms:')) {
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
    else if (message.startsWith('ROOM_CREATED:')) {
        // Handle successful room creation
        const parts = message.split(':');
        const roomId = parts[1];
        const roomName = parts.slice(2).join(':').split('\n')[0]; // Get room name before any newlines
        
        console.log('Room created:', roomId, roomName);
        
        // Hide modal and reset form
        hideCreateRoomModal();
        document.getElementById('roomNameInput').value = '';
        
        // Reset button state
        const submitBtn = createRoomForm.querySelector('button[type="submit"]');
        submitBtn.disabled = false;
        submitBtn.textContent = 'Create Room';
        
        // Update state and show room
        currentRoom = { id: roomId, name: roomName };
        showChatRoom(roomName);
    } else if (message.startsWith('ERROR:')) {
        // Handle errors
        alert(message);
        const submitBtn = createRoomForm.querySelector('button[type="submit"]');
        submitBtn.disabled = false;
        submitBtn.textContent = 'Create Room';
    } else if (message.includes('=== Chat Room:')) {
        const roomNameMatch = message.match(/=== Chat Room: (.+) ===/);
        if (roomNameMatch) {
            currentRoom = { name: roomNameMatch[1] };
            showChatRoom(currentRoom.name);
        }
        addMessage(message);
    } else {
        addMessage(message);
    }
};


  socket.onclose = () => {
      console.log('Disconnected from server');
      setTimeout(connectWebSocket, 3000);
  };
}

// Auth functions
loginForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const username = document.getElementById('loginUsername').value;
    const password = document.getElementById('loginPassword').value;
    
    try {
        // Try REST API login first
        const response = await AuthAPI.login(username, password);
        
        // If REST API login successful
        if (response.success) {
            // Store user info in cookie
            setCookie('username', username, 1);
            
            // Also send WebSocket login (for backward compatibility)
            socket.send(`1.${username}.${password}`);
            
            // Load user preferences
            const preferences = await UserAPI.getPreferences();
            saveUserPreferences(preferences);
            
            // Show dashboard
            currentUser = { username: username };
            showDashboard();
        }
    } catch (error) {
        console.error('Login failed:', error);
        // Fallback to WebSocket-only login
        socket.send(`1.${username}.${password}`);
    }
});

registerForm.addEventListener('submit', (e) => {
  e.preventDefault();
  const username = document.getElementById('registerUsername').value;
  const password = document.getElementById('registerPassword').value;
  socket.send(`2.${username}.${password}`);
});

// Modal control functions
function showCreateRoomModal() {
  const modal = document.getElementById('createRoomModal');
  modal.classList.add('active');
  document.getElementById('roomNameInput').focus();
}

function hideCreateRoomModal() {
  const modal = document.getElementById('createRoomModal');
  modal.classList.remove('active');
  document.getElementById('roomNameInput').value = '';
}

// Event listeners
document.getElementById('createRoomBtn').addEventListener('click', showCreateRoomModal);
document.getElementById('cancelCreateRoom').addEventListener('click', hideCreateRoomModal);

// Close modal when clicking outside content
document.querySelector('.modal-overlay').addEventListener('click', hideCreateRoomModal);

// Remove duplicate event listener - this was causing conflicts
// The createRoomForm already has a submit handler below
// document.getElementById('createRoomForm').addEventListener('submit', function(e) {
//   ...
// });

createRoomForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const roomNameInput = document.getElementById('roomNameInput');
    const newRoomName = roomNameInput.value.trim();

    if (newRoomName) {
        // Show loading state
        const submitBtn = createRoomForm.querySelector('button[type="submit"]');
        submitBtn.disabled = true;
        submitBtn.textContent = 'Creating...';
        
        socket.send(`create:${newRoomName}`);
        
        // Add timeout in case server doesn't respond
        setTimeout(() => {
            if (submitBtn.textContent === 'Creating...') {
                alert('Room creation timed out');
                submitBtn.disabled = false;
                submitBtn.textContent = 'Create Room';
            }
        }, 5000);
    }
});
// Navigation
logoutBtn.addEventListener('click', () => {
    // Clear cookies
    deleteCookie('username');
    deleteCookie('JSESSIONID');
    
    // Clear session storage
    clearSessionData();
    
    socket.close();
    currentUser = null;
    currentRoom = null;
    showLoginTab();
    authContainer.classList.remove('hidden');
    dashboardContainer.classList.add('hidden');
    chatContainer.classList.add('hidden');
    connectWebSocket();
});

leaveRoomBtn.addEventListener('click', () => {
  socket.send('/exit');
  currentRoom = null;
  showDashboard();
});

// Tab switching
tabBtns.forEach(btn => {
  btn.addEventListener('click', () => {
      const tab = btn.dataset.tab;
      tabBtns.forEach(b => b.classList.remove('active'));
      btn.classList.add('active');

      if (tab === 'login') {
          loginForm.classList.remove('hidden');
          registerForm.classList.add('hidden');
      } else {
          loginForm.classList.add('hidden');
          registerForm.classList.remove('hidden');
      }
  });
});

function displayRooms(rooms) {
  roomsList.innerHTML = rooms.map((room, index) => `
      <div class="room-card" onclick="joinRoom(${index + 1})">
          <h3>${room.name}</h3>
      </div>
  `).join('');
}

function joinRoom(roomNumber) {
  socket.send(`join:${roomNumber}`);
}

// Message handling
messageForm.addEventListener('submit', (e) => {
  e.preventDefault();
  const message = messageInput.value.trim();

  if (message) {
      socket.send(message);
      messageInput.value = '';
  }
});

function addMessage(message) {
    if (message.includes('Welcome to GTR Chat Server!') ||
        message.includes('Joined room:') ||
        message.includes('=== Chat Room:') ||
        message.includes('You joined at:') ||
        message.includes('Type \'/exit\' to leave the room') ||
        message.includes('--- Chat History') ||
        message.startsWith('[SYSTEM]')) {
        return;
    }

    if (!message.includes(':')) {
        return;
    }

    const messageElement = document.createElement('div');
    messageElement.className = 'message other';

    let cleanMessage = message
        .replace(/\[\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d+\]/g, '')
        .replace(/[^\x20-\x7E]/g, '')
        .trim();

    if (cleanMessage) {
        const messageWrapper = document.createElement('div');
        messageWrapper.className = 'message-wrapper';

        const personAvatar = document.createElement('div');
        personAvatar.className = 'person-avatar';

        const messageContent = document.createElement('div');
        messageContent.className = 'message-content';
        messageContent.textContent = cleanMessage;

        messageWrapper.appendChild(personAvatar);
        messageWrapper.appendChild(messageContent);
        messageElement.appendChild(messageWrapper);

        messagesContainer.appendChild(messageElement);
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }

    // Store message in session storage
    if (currentRoom) {
        const chatHistory = JSON.parse(
            sessionStorage.getItem(`${STORAGE_KEYS.CHAT_HISTORY}_${currentRoom.name}`) || '[]'
        );
        chatHistory.push({
            message,
            timestamp: new Date().toISOString()
        });
        sessionStorage.setItem(
            `${STORAGE_KEYS.CHAT_HISTORY}_${currentRoom.name}`,
            JSON.stringify(chatHistory)
        );
    }
}

// UI functions
function showDashboard() {
  authContainer.classList.add('hidden');
  dashboardContainer.classList.remove('hidden');
  chatContainer.classList.add('hidden');
  usernameDisplay.textContent = currentUser.username;
  socket.send('3');
  loadUserTodos();

  const dashboardHeader = document.querySelector('.dashboard-header');
  if (!document.querySelector('.race-data-btn')) {
      const raceDataBtn = document.createElement('button');
      raceDataBtn.className = 'btn btn-outline race-data-btn';
      raceDataBtn.textContent = 'VIEW RACE DATA';
      raceDataBtn.onclick = function() {
          console.log('Dashboard race data button clicked'); // Debug log
          showRaceData();
      };
      dashboardHeader.appendChild(raceDataBtn);
  }
}

function showLoginTab() {
  tabBtns[0].click();
}

function showChatRoom(roomName) {
    // Save current room to session storage
    const room = { name: roomName };
    saveLastRoom(room);
    
    // Show chat container and hide others
    document.getElementById('authContainer').classList.add('hidden');
    document.getElementById('dashboardContainer').classList.add('hidden');
    document.getElementById('chatContainer').classList.remove('hidden');
    
    // Update room name display
    document.getElementById('roomName').textContent = roomName;
    
    // Initialize chat room
    initializeChatRoom(roomName);
}

// Todo List Functionality
let todos = [];
const todoPanel = document.createElement('div');
todoPanel.className = 'todo-panel';
document.body.appendChild(todoPanel);

function initTodoList() {
    todoPanel.innerHTML = `
        <div class="todo-header">
            <h2>Track Day Checklist</h2>
            <button class="close-btn" onclick="toggleTodoPanel()">×</button>
        </div>
        <form class="todo-form" onsubmit="addTodo(event)">
            <input type="text" class="todo-input" placeholder="Add race preparation task...">
            <button type="submit" class="suggestion-btn">Add</button>
        </form>
        <div class="todo-list"></div>
    `;
    loadUserTodos();
}

function loadUserTodos() {
    if (currentUser) {
        const userTodos = JSON.parse(localStorage.getItem(`racingTodos_${currentUser.username}`) || '[]');
        todos = userTodos;
        renderTodos();
    }
}

window.toggleTodoPanel = function() {
    todoPanel.classList.toggle('active');
};

window.addTodo = function(event) {
    event.preventDefault();
    const input = event.target.querySelector('.todo-input');
    const text = input.value.trim();

    if (text && currentUser) {
        todos.push({
            id: Date.now(),
            text,
            completed: false
        });
        localStorage.setItem(`racingTodos_${currentUser.username}`, JSON.stringify(todos));
        input.value = '';
        renderTodos();
    }
};

window.toggleTodo = function(id) {
    if (!currentUser) return;
    todos = todos.map(todo =>
        todo.id === id ? { ...todo, completed: !todo.completed } : todo
    );
    localStorage.setItem(`racingTodos_${currentUser.username}`, JSON.stringify(todos));
    renderTodos();
};

window.deleteTodo = function(id) {
    if (!currentUser) return;
    todos = todos.filter(todo => todo.id !== id);
    localStorage.setItem(`racingTodos_${currentUser.username}`, JSON.stringify(todos));
    renderTodos();
};

function renderTodos() {
    const todoList = todoPanel.querySelector('.todo-list');
    todoList.innerHTML = todos.map(todo => `
        <div class="todo-item">
            <div class="todo-checkbox ${todo.completed ? 'checked' : ''}"
                 onclick="toggleTodo(${todo.id})"></div>
            <span class="todo-text">${todo.text}</span>
            <button class="todo-delete" onclick="deleteTodo(${todo.id})">×</button>
        </div>
    `).join('');
}

// Make joinRoom global
window.joinRoom = joinRoom;

// Rest of your existing code...
// [Keep all your existing particle, speedometer, and other effects code]

// Update the CSS styles
const style = document.createElement('style');
style.textContent = `
    .message-wrapper {
        display: flex;
        align-items: flex-start;
        gap: 12px;
    }

    .person-avatar {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        background: #444;
        position: relative;
        flex-shrink: 0;
    }

    .person-avatar::before {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 16px;
        height: 16px;
        background: #666;
        border-radius: 50%;
    }

    .person-avatar::after {
        content: '';
        position: absolute;
        top: 65%;
        left: 50%;
        transform: translateX(-50%);
        width: 20px;
        height: 10px;
        background: #666;
        border-radius: 10px 10px 0 0;
    }

    .message-content {
        background: #2a2a2a;
        padding: 10px 15px;
        border-radius: 8px;
        color: #fff;
        font-size: 0.95rem;
        line-height: 1.4;
        max-width: 80%;
        word-wrap: break-word;
    }

    .message.system {
        text-align: center;
        color: #888;
        font-style: italic;
        margin: 10px 0;
        word-wrap: break-word;
    }

    .message.other {
        margin: 8px 0;
    }
`;
document.head.appendChild(style);

// Session and Cookie Management
function initializeSession() {
    // Check for existing session
    const sessionId = getCookie('JSESSIONID');
    if (!sessionId) {
        console.log('No active session found');
        return false;
    }
    return true;
}

function getCookie(name) {
    const nameEQ = name + "=";
    const ca = document.cookie.split(';');
    for(let i = 0; i < ca.length; i++) {
        let c = ca[i];
        while (c.charAt(0) === ' ') c = c.substring(1, c.length);
        if (c.indexOf(nameEQ) === 0) return c.substring(nameEQ.length, c.length);
    }
    return null;
}

function setCookie(name, value, days) {
    let expires = "";
    if (days) {
        const date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        expires = "; expires=" + date.toUTCString();
    }
    document.cookie = name + "=" + (value || "") + expires + "; path=/";
}

function deleteCookie(name) {
    document.cookie = name + '=; Max-Age=-99999999; path=/';
}

// Load chat history when entering a room
function initializeChatRoom(roomName) {
    const chatHistory = JSON.parse(
        sessionStorage.getItem(`${STORAGE_KEYS.CHAT_HISTORY}_${roomName}`) || '[]'
    );
    
    // Clear existing messages
    const messagesContainer = document.getElementById('messagesContainer');
    messagesContainer.innerHTML = '';
    
    // Load chat history
    chatHistory.forEach(item => {
        const messageElement = document.createElement('div');
        messageElement.textContent = item.message;
        messagesContainer.appendChild(messageElement);
    });
    
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
}

// Racing World button handler
document.getElementById('racingWorldBtn').addEventListener('click', () => {
    window.location.href = 'racingWorld.jsp';
});