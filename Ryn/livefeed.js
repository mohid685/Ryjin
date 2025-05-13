/**
 * GTR R35 Live Feed/Bulletin
 * Creates a dynamic, scrolling feed of activities and announcements
 */

// Configuration for the live feed
const LIVEFEED_CONFIG = {
  maxItems: 5,           // Maximum items to show at once
  scrollInterval: 5000,  // Time between scrolls (ms)
  itemFadeIn: 800,       // Fade in duration (ms)
  itemDuration: 4000,    // How long each item stays visible (ms)
  itemFadeOut: 800,      // Fade out duration (ms)
  updateInterval: 30000  // How often to fetch new data (ms)
};

// Queue for feed items
let feedQueue = [];
let activeFeedItems = [];

// API Configuration
const API_CONFIG = {
  ergast: {
    baseUrl: 'http://ergast.com/api/f1',
    currentSeason: new Date().getFullYear()
  },
  nascar: {
    baseUrl: 'https://api.nascar.com/api/v1',
    currentSeason: new Date().getFullYear()
  },
  indycar: {
    baseUrl: 'https://api.indycar.com/api/v1',
    currentSeason: new Date().getFullYear()
  }
};

// Series colors for visual distinction
const SERIES_COLORS = {
  F1: '#E10600',
  NASCAR: '#FFD700',
  INDYCAR: '#002D62',
  WEC: '#1E90FF',
  IMSA: '#FF4500'
};

// Initial racing data for immediate display
const INITIAL_RACING_DATA = [
    {
        text: "F1 CHAMPIONSHIP STANDINGS: Max Verstappen leads with 314 points",
        type: "alert",
        user: "F1"
    },
    {
        text: "NEXT F1 GRAND PRIX: Singapore Grand Prix - September 17, 2024",
        type: "system",
        user: "F1"
    },
    {
        text: "NASCAR CUP SERIES: Kyle Larson leads with 2,145 points",
        type: "alert",
        user: "NASCAR"
    },
    {
        text: "NEXT NASCAR RACE: Bristol Motor Speedway - September 16, 2024",
        type: "system",
        user: "NASCAR"
    },
    {
        text: "INDYCAR CHAMPIONSHIP: Alex Palou leads with 517 points",
        type: "alert",
        user: "INDYCAR"
    }
];

/**
 * Fetches Formula 1 data from Ergast API
 */
async function fetchF1Data() {
  try {
    // Fetch current season standings
    const standingsResponse = await fetch(`${API_CONFIG.ergast.baseUrl}/${API_CONFIG.ergast.currentSeason}/driverStandings.json`);
    const standingsData = await standingsResponse.json();
    
    // Fetch next race
    const nextRaceResponse = await fetch(`${API_CONFIG.ergast.baseUrl}/${API_CONFIG.ergast.currentSeason}/next.json`);
    const nextRaceData = await nextRaceResponse.json();

    // Process and add F1 data to feed
    if (standingsData.MRData.StandingsTable.StandingsLists[0]) {
      const standings = standingsData.MRData.StandingsTable.StandingsLists[0].DriverStandings;
      const leader = standings[0];
      addFeedItem(
        `F1 CHAMPIONSHIP LEADER: ${leader.Driver.givenName} ${leader.Driver.familyName} (${leader.points} pts)`,
        'alert',
        'F1'
      );
    }

    if (nextRaceData.MRData.RaceTable.Races[0]) {
      const nextRace = nextRaceData.MRData.RaceTable.Races[0];
      addFeedItem(
        `NEXT F1 GRAND PRIX: ${nextRace.raceName} - ${new Date(nextRace.date).toLocaleDateString()}`,
        'system',
        'F1'
      );
    }
  } catch (error) {
    console.error('Error fetching F1 data:', error);
    addFeedItem('F1 data temporarily unavailable', 'system', 'SYSTEM');
  }
}

/**
 * Fetches NASCAR data
 */
async function fetchNascarData() {
  try {
    // Fetch current standings
    const standingsResponse = await fetch(`${API_CONFIG.nascar.baseUrl}/standings/points/${API_CONFIG.nascar.currentSeason}`);
    const standingsData = await standingsResponse.json();

    // Fetch next race
    const scheduleResponse = await fetch(`${API_CONFIG.nascar.baseUrl}/schedule/${API_CONFIG.nascar.currentSeason}`);
    const scheduleData = await scheduleResponse.json();

    // Process and add NASCAR data to feed
    if (standingsData && standingsData.standings) {
      const leader = standingsData.standings[0];
      addFeedItem(
        `NASCAR CUP SERIES LEADER: ${leader.driver_name} (${leader.points} pts)`,
        'alert',
        'NASCAR'
      );
    }

    if (scheduleData && scheduleData.schedule) {
      const nextRace = scheduleData.schedule.find(race => new Date(race.race_date) > new Date());
      if (nextRace) {
        addFeedItem(
          `NEXT NASCAR RACE: ${nextRace.race_name} - ${new Date(nextRace.race_date).toLocaleDateString()}`,
          'system',
          'NASCAR'
        );
      }
    }
  } catch (error) {
    console.error('Error fetching NASCAR data:', error);
    addFeedItem('NASCAR data temporarily unavailable', 'system', 'SYSTEM');
  }
}

/**
 * Creates the live feed element
 */
function createLiveFeed() {
  // Check if feed already exists
  if (document.getElementById('gtr-livefeed')) return;

  // Create container
  const feedContainer = document.createElement('div');
  feedContainer.id = 'gtr-livefeed';

  // Feed content
  const feedContent = document.createElement('div');
  feedContent.className = 'feed-content';

  // Add to container
  feedContainer.appendChild(feedContent);

  // Find the appropriate location to insert the feed
  let targetContainer;

  // Try different potential containers, in order of preference
  const containers = [
    document.getElementById('dashboardContainer'),
    document.querySelector('.rooms-section'),
    document.body
  ];

  for (const container of containers) {
    if (container) {
      targetContainer = container;
      break;
    }
  }

  if (targetContainer) {
    if (targetContainer === document.body) {
      // If adding to body, position it fixed
      feedContainer.style.position = 'fixed';
      feedContainer.style.top = '20px';
      feedContainer.style.right = '20px';
      feedContainer.style.zIndex = '1000';
    } else {
      // For other containers, try to find a good spot
      const firstChild = targetContainer.firstChild;
      if (firstChild) {
        targetContainer.insertBefore(feedContainer, firstChild);
      } else {
        targetContainer.appendChild(feedContainer);
      }
    }
  } else {
    // Fallback: append to body
    document.body.appendChild(feedContainer);
  }

  // Initialize with initial data
  INITIAL_RACING_DATA.forEach(item => {
    addFeedItem(item.text, item.type, item.user);
  });

  // Start the feed
  startLiveFeed();
}

/**
 * Starts the live feed animation and updates
 */
function startLiveFeed() {
  // Initial data fetch
  fetchF1Data();
  fetchNascarData();

  // Set up intervals for continuous updates
  setInterval(updateFeed, LIVEFEED_CONFIG.scrollInterval);
  setInterval(() => {
    fetchF1Data();
    fetchNascarData();
  }, LIVEFEED_CONFIG.updateInterval);

  // Initial feed update
  updateFeed();
}

/**
 * Updates the feed with new items
 */
function updateFeed() {
  const feedContent = document.querySelector('.feed-content');
  if (!feedContent) return;

  // Maintain fixed height
  feedContent.style.height = `${LIVEFEED_CONFIG.maxItems * 80}px`;

  if (feedQueue.length > 0) {
    const newItem = feedQueue.shift();
    feedQueue.push(newItem);

    const feedItem = createFeedItem(newItem);
    feedContent.insertBefore(feedItem, feedContent.firstChild);

    // Remove oldest if we exceed max
    if (feedContent.children.length > LIVEFEED_CONFIG.maxItems) {
      feedContent.removeChild(feedContent.lastChild);
    }
  }
}

/**
 * Creates a single feed item element
 */
function createFeedItem(item) {
  const feedItem = document.createElement('div');
  feedItem.className = `feed-item ${item.type}`;

  // Series indicator
  if (item.user && SERIES_COLORS[item.user]) {
    const seriesIndicator = document.createElement('div');
    seriesIndicator.className = 'series-indicator';
    seriesIndicator.style.backgroundColor = SERIES_COLORS[item.user];
    feedItem.appendChild(seriesIndicator);
  }

  // Timestamp
  const timestamp = document.createElement('span');
  timestamp.className = 'timestamp';
  const now = new Date();
  timestamp.textContent = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

  // Content
  const content = document.createElement('span');
  content.className = 'content';
  content.textContent = item.text;

  // User badge (if applicable)
  if (item.user) {
    const userBadge = document.createElement('span');
    userBadge.className = 'user-badge';
    userBadge.textContent = item.user;
    feedItem.appendChild(userBadge);
  }

  feedItem.appendChild(timestamp);
  feedItem.appendChild(content);

  return feedItem;
}

/**
 * Adds a new item to the feed
 */
function addFeedItem(text, type = 'system', user = null) {
  // Create new feed item
  const newItem = { type, text, user };

  // Add to queue
  feedQueue.unshift(newItem);

  // Cap queue size
  if (feedQueue.length > 20) {
    feedQueue.pop();
  }

  // Force an update
  updateFeed();
}

// Initialize live feed
document.addEventListener('DOMContentLoaded', () => {
  createLiveFeed();
});