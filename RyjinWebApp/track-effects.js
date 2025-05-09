/**
 * GTR R35 Track Visualization
 * Creates a dynamic race track visualization in the background
 */

// Track configuration
const TRACK_CONFIG = {
  lineCount: 20,      // Number of track lines
  segmentCount: 5,    // Segments per line for variation
  baseSpeed: 5,       // Base animation speed (seconds)
  speedVariation: 2,  // Random variation in speed
  minLength: 20,      // Minimum line length (vh units)
  maxLength: 60,      // Maximum line length (vh units)
  spacing: 5,         // Spacing between lines (vw units)
  glowIntensity: 0.4  // Glow intensity (0-1)
};

/**
 * Creates the track visualization effect
 */
function createTrackEffect() {
  // Check if track container already exists
  if (document.getElementById('gtr-track-container')) return;

  // Create track container
  const trackContainer = document.createElement('div');
  trackContainer.id = 'gtr-track-container';

  // Create track lines
  for (let i = 0; i < TRACK_CONFIG.lineCount; i++) {
    // For each track line, create segments
    createTrackLine(i, trackContainer);
  }

  // Add to document
  document.body.appendChild(trackContainer);
}

/**
 * Creates a single track line with multiple segments
 */
function createTrackLine(index, container) {
  const trackLine = document.createElement('div');
  trackLine.className = 'track-line';

  // Position based on index
  const position = index * TRACK_CONFIG.spacing;
  trackLine.style.left = `${position}vw`;

  // Create segments for this line
  for (let j = 0; j < TRACK_CONFIG.segmentCount; j++) {
    createTrackSegment(j, trackLine);
  }

  container.appendChild(trackLine);
}

/**
 * Creates a segment within a track line
 */
function createTrackSegment(index, lineElement) {
  const segment = document.createElement('div');
  segment.className = 'track-segment';

  // Randomize length
  const length = TRACK_CONFIG.minLength +
                Math.random() * (TRACK_CONFIG.maxLength - TRACK_CONFIG.minLength);
  segment.style.height = `${length}vh`;

  // Randomize animation properties
  const delay = Math.random() * -8; // Negative for already in-progress feel
  const duration = TRACK_CONFIG.baseSpeed + Math.random() * TRACK_CONFIG.speedVariation;

  // Set animation properties
  segment.style.animationDuration = `${duration}s`;
  segment.style.animationDelay = `${delay}s`;

  // Randomize between red and blue for GTR theme
  const isBlue = Math.random() > 0.7; // 30% chance of blue segments
  if (isBlue) {
    segment.classList.add('blue-track');
  }

  // Randomize brightness
  const brightness = 0.7 + Math.random() * 0.3;
  segment.style.opacity = brightness;

  lineElement.appendChild(segment);
}

/**
 * Updates the track effect properties based on user activity
 * Higher activity = faster track lines
 */
function updateTrackSpeed(activityLevel = 1) {
  // activityLevel: 0 (low) to 2 (high)
  const trackSegments = document.querySelectorAll('.track-segment');

  trackSegments.forEach(segment => {
    const baseDuration = parseFloat(segment.style.animationDuration);
    const newDuration = TRACK_CONFIG.baseSpeed / (activityLevel * 0.5 + 0.75);
    segment.style.animationDuration = `${newDuration}s`;
  });
}

// Initialize track visualization
document.addEventListener('DOMContentLoaded', () => {
  createTrackEffect();

  // Demo: Speed up track occasionally
  setInterval(() => {
    const activityLevel = Math.random() * 2; // 0-2 range for activity
    updateTrackSpeed(activityLevel);
  }, 10000);
});