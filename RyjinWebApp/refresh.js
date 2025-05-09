// refresh.js - Handle page-specific refresh functionality

// Tracking refresh state
let isRefreshing = false;

// Initialize refresh buttons on all pages
function initRefreshButtons() {
    // Create and add refresh buttons to each container
    addRefreshButton('authContainer', refreshAuthPage);
    addRefreshButton('dashboardContainer', refreshDashboardPage);
    addRefreshButton('chatContainer', refreshChatPage);
}

// Create and append a refresh button to the specified container
function addRefreshButton(containerId, refreshFunction) {
    const container = document.getElementById(containerId);
    if (!container) return;
    
    // Check if button already exists
    if (container.querySelector('.refresh-btn')) return;
    
    // Create button
    const refreshBtn = document.createElement('button');
    refreshBtn.className = 'refresh-btn';
    refreshBtn.setAttribute('aria-label', 'Refresh this page');
    refreshBtn.innerHTML = `
        <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M21.5 2v6h-6M2.5 22v-6h6M2 11.5a10 10 0 0 1 18.8-4.3M22 12.5a10 10 0 0 1-18.8 4.2"/>
        </svg>
    `;
    
    // Find the appropriate place to insert the button
    if (containerId === 'authContainer') {
        const authBox = container.querySelector('.auth-box');
        if (authBox) {
            refreshBtn.classList.add('auth-refresh');
            authBox.insertBefore(refreshBtn, authBox.firstChild);
        }
    } else if (containerId === 'dashboardContainer') {
        const userInfo = container.querySelector('.user-info');
        if (userInfo) {
            refreshBtn.classList.add('dashboard-refresh');
            userInfo.insertBefore(refreshBtn, userInfo.querySelector('#logoutBtn'));
        }
    } else if (containerId === 'chatContainer') {
        const header = container.querySelector('.chat-header');
        if (header) {
            refreshBtn.classList.add('chat-refresh');
            header.insertBefore(refreshBtn, header.querySelector('#showUsersBtn'));
        }
    }
    
    // Add event listener
    refreshBtn.addEventListener('click', () => {
        if (!isRefreshing) {
            refreshFunction();
        }
    });
}

// Refresh animation
function startRefreshAnimation(containerId) {
    isRefreshing = true;
    const button = document.querySelector(`#${containerId} .refresh-btn`);
    if (button) {
        button.classList.add('refreshing');
    }
}

function stopRefreshAnimation(containerId) {
    const button = document.querySelector(`#${containerId} .refresh-btn`);
    if (button) {
        button.classList.remove('refreshing');
    }
    isRefreshing = false;
}

// Page-specific refresh functions
function refreshAuthPage() {
    startRefreshAnimation('authContainer');
    
    // Clear form fields
    const loginForm = document.getElementById('loginForm');
    const registerForm = document.getElementById('registerForm');
    
    if (loginForm) loginForm.reset();
    if (registerForm) registerForm.reset();
    
    setTimeout(() => {
        stopRefreshAnimation('authContainer');
    }, 500);
}

function refreshDashboardPage() {
    startRefreshAnimation('dashboardContainer');
    
    // Re-fetch rooms list
    if (socket && socket.readyState === WebSocket.OPEN) {
        socket.send('3'); // List rooms command
    }
    
    // Reset room list display
    const roomsList = document.getElementById('roomsList');
    if (roomsList) {
        roomsList.innerHTML = '<div class="loading-rooms">Loading rooms...</div>';
    }
    
    setTimeout(() => {
        stopRefreshAnimation('dashboardContainer');
    }, 1000);
}

function refreshChatPage() {
    startRefreshAnimation('chatContainer');
    
    // Clear messages container
    const messagesContainer = document.getElementById('messagesContainer');
    if (messagesContainer && currentRoom) {
        // Keep scroll position
        const scrollPos = messagesContainer.scrollTop;
        const wasAtBottom = messagesContainer.scrollHeight - messagesContainer.scrollTop <= messagesContainer.clientHeight + 50;
        
        messagesContainer.innerHTML = '<div class="message system">Refreshing chat history...</div>';
        
        // Re-join current room to get fresh messages
        if (socket && socket.readyState === WebSocket.OPEN) {
            socket.send(`join:${currentRoom.name}`);
        }
        
        // Restore scroll position
        setTimeout(() => {
            if (wasAtBottom) {
                messagesContainer.scrollTop = messagesContainer.scrollHeight;
            } else {
                messagesContainer.scrollTop = scrollPos;
            }
            stopRefreshAnimation('chatContainer');
        }, 1000);
    }
}

// Prevent Ctrl+R refresh
document.addEventListener('keydown', (e) => {
    if ((e.ctrlKey || e.metaKey) && e.key === 'r') {
        e.preventDefault();
        const visibleContainer = document.querySelector('.container:not(.hidden)');
        if (visibleContainer) {
            const refreshBtn = visibleContainer.querySelector('.refresh-btn');
            if (refreshBtn) {
                refreshBtn.click();
            }
        }
    }
});

// Initialize on page load
document.addEventListener('DOMContentLoaded', initRefreshButtons);

// Export for use in other modules
window.refreshPage = {
    auth: refreshAuthPage,
    dashboard: refreshDashboardPage,
    chat: refreshChatPage,
    stopAnimation: stopRefreshAnimation
};