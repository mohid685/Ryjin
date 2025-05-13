// API Configuration
const API_CONFIG = {
    f1: {
        baseUrl: 'http://ergast.com/api/f1',
        currentSeason: new Date().getFullYear()
    },
    nascar: {
        baseUrl: 'https://api.nascar.com/api/v1',
        currentSeason: new Date().getFullYear()
    }
};

// Series Colors for Visual Distinction
const SERIES_COLORS = {
    f1: '#ff1e1e',
    nascar: '#0095ff',
    indycar: '#ffd700',
    wec: '#00ff00',
    imsa: '#ff00ff'
};

// Fallback Data
const FALLBACK_DATA = {
    f1: {
        standings: [
            { Driver: { givenName: 'Max', familyName: 'Verstappen' }, points: '454' },
            { Driver: { givenName: 'Sergio', familyName: 'Perez' }, points: '305' },
            { Driver: { givenName: 'Lewis', familyName: 'Hamilton' }, points: '234' },
            { Driver: { givenName: 'Carlos', familyName: 'Sainz' }, points: '200' },
            { Driver: { givenName: 'Fernando', familyName: 'Alonso' }, points: '183' }
        ],
        nextRace: {
            raceName: 'Monaco Grand Prix',
            date: '2024-05-26'
        }
    },
    nascar: {
        standings: [
            { driver_name: 'Kyle Larson', points: '1234' },
            { driver_name: 'Chase Elliott', points: '1189' },
            { driver_name: 'William Byron', points: '1156' },
            { driver_name: 'Denny Hamlin', points: '1123' },
            { driver_name: 'Martin Truex Jr.', points: '1098' }
        ],
        nextRace: {
            name: 'Coca-Cola 600',
            date: '2024-05-26'
        }
    }
};

// Message Queue System
let messageQueue = [];
let isProcessingQueue = false;
const MESSAGE_DISPLAY_TIME = 5000; // 5 seconds per message

// Process Message Queue
async function processMessageQueue() {
    if (isProcessingQueue || messageQueue.length === 0) return;
    
    isProcessingQueue = true;
    const message = messageQueue.shift();
    
    const feedContent = document.querySelector('.feed-content');
    if (feedContent) {
        const feedItem = document.createElement('div');
        feedItem.className = `feed-item ${message.type}`;
        feedItem.innerHTML = `
            <div class="series-indicator" style="background-color: ${SERIES_COLORS[message.series]}"></div>
            <span class="timestamp">${message.timestamp}</span>
            <span class="content">${message.content}</span>
            <span class="user-badge">${message.series.toUpperCase()}</span>
        `;
        
        // Add new message at the top
        feedContent.insertBefore(feedItem, feedContent.firstChild);
        
        // Remove oldest message if more than 20 items
        while (feedContent.children.length > 20) {
            feedContent.removeChild(feedContent.lastChild);
        }
    }
    
    // Wait for display time before processing next message
    await new Promise(resolve => setTimeout(resolve, MESSAGE_DISPLAY_TIME));
    isProcessingQueue = false;
    processMessageQueue();
}

// Fetch F1 Data
async function fetchF1Data() {
    try {
        // Get current standings
        const standingsResponse = await fetch(`${API_CONFIG.f1.baseUrl}/${API_CONFIG.f1.currentSeason}/driverStandings.json`);
        const standingsData = await standingsResponse.json();
        
        // Get next race
        const nextRaceResponse = await fetch(`${API_CONFIG.f1.baseUrl}/${API_CONFIG.f1.currentSeason}/next.json`);
        const nextRaceData = await nextRaceResponse.json();

        return {
            standings: standingsData.MRData.StandingsTable.StandingsLists[0]?.DriverStandings || FALLBACK_DATA.f1.standings,
            nextRace: nextRaceData.MRData.RaceTable.Races[0] || FALLBACK_DATA.f1.nextRace
        };
    } catch (error) {
        console.error('Error fetching F1 data:', error);
        return FALLBACK_DATA.f1;
    }
}

// Fetch NASCAR Data
async function fetchNascarData() {
    try {
        // Get current standings
        const standingsResponse = await fetch(`${API_CONFIG.nascar.baseUrl}/standings/points?season=${API_CONFIG.nascar.currentSeason}`);
        const standingsData = await standingsResponse.json();
        
        // Get next race
        const scheduleResponse = await fetch(`${API_CONFIG.nascar.baseUrl}/schedule?season=${API_CONFIG.nascar.currentSeason}`);
        const scheduleData = await scheduleResponse.json();

        return {
            standings: standingsData.standings || FALLBACK_DATA.nascar.standings,
            nextRace: scheduleData.schedule?.find(race => new Date(race.date) > new Date()) || FALLBACK_DATA.nascar.nextRace
        };
    } catch (error) {
        console.error('Error fetching NASCAR data:', error);
        return FALLBACK_DATA.nascar;
    }
}

// Format F1 Message
function formatF1Message(data) {
    if (!data) return null;

    const messages = [];
    
    // Add standings messages for top 5
    data.standings.slice(0, 5).forEach((driver, index) => {
        messages.push({
            type: 'alert',
            series: 'f1',
            content: `F1 STANDINGS #${index + 1}: ${driver.Driver.givenName} ${driver.Driver.familyName} (${driver.points} pts)`,
            timestamp: new Date().toLocaleTimeString()
        });
    });

    // Add next race message
    if (data.nextRace) {
        messages.push({
            type: 'system',
            series: 'f1',
            content: `NEXT F1 GRAND PRIX: ${data.nextRace.raceName} - ${new Date(data.nextRace.date).toLocaleDateString()}`,
            timestamp: new Date().toLocaleTimeString()
        });
    }

    return messages;
}

// Format NASCAR Message
function formatNascarMessage(data) {
    if (!data) return null;

    const messages = [];
    
    // Add standings messages for top 5
    data.standings.slice(0, 5).forEach((driver, index) => {
        messages.push({
            type: 'alert',
            series: 'nascar',
            content: `NASCAR STANDINGS #${index + 1}: ${driver.driver_name} (${driver.points} pts)`,
            timestamp: new Date().toLocaleTimeString()
        });
    });

    // Add next race message
    if (data.nextRace) {
        messages.push({
            type: 'system',
            series: 'nascar',
            content: `NEXT NASCAR RACE: ${data.nextRace.name} - ${new Date(data.nextRace.date).toLocaleDateString()}`,
            timestamp: new Date().toLocaleTimeString()
        });
    }

    return messages;
}

// Update Live Feed with Racing Data
async function updateRacingFeed() {
    try {
        // Fetch data from both APIs
        const [f1Data, nascarData] = await Promise.all([
            fetchF1Data(),
            fetchNascarData()
        ]);

        // Format messages
        const f1Messages = formatF1Message(f1Data);
        const nascarMessages = formatNascarMessage(nascarData);

        // Combine and sort messages by timestamp
        const allMessages = [...(f1Messages || []), ...(nascarMessages || [])]
            .sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp));

        // Add messages to queue
        messageQueue.push(...allMessages);
        
        // Start processing queue if not already processing
        if (!isProcessingQueue) {
            processMessageQueue();
        }
    } catch (error) {
        console.error('Error updating racing feed:', error);
    }
}

// Initialize Racing Feed
function initRacingFeed() {
    // Initial update
    updateRacingFeed();

    // Update every 30 seconds
    setInterval(updateRacingFeed, 30000);
}

// Export functions
window.initRacingFeed = initRacingFeed;
window.updateRacingFeed = updateRacingFeed; 