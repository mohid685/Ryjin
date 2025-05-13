/**
 * GTR R35 Headlight Effects
 * Creates a dramatic headlight effect in the background
 */

// Configuration for headlight effects
const HEADLIGHT_CONFIG = {
  pulseInterval: 4000,    // Time between pulses (ms)
  beamCount: 2,           // Number of headlight beams
  beamWidth: 40,          // Width of each beam (vw)
  beamSpacing: 20,        // Space between beams (vw)
  minOpacity: 0.05,       // Minimum opacity of beams
  maxOpacity: 0.15,       // Maximum opacity of beams
  glowSize: '100px',      // Size of the glow effect
  glowColor: '#ff0033',   // Primary glow color (GTR red)
  blueGlowColor: '#0F4C81' // Secondary glow color (GTR blue)
};

/**
 * Creates the headlight effect elements
 */
function createHeadlightEffect() {
  // Check if headlights container already exists
  if (document.getElementById('gtr-headlights')) return;

  // Create headlights container
  const headlightsContainer = document.createElement('div');
  headlightsContainer.id = 'gtr-headlights';

  // Create left and right headlight beams
  const leftBeam = createHeadlightBeam('left');
  const rightBeam = createHeadlightBeam('right');

  headlightsContainer.appendChild(leftBeam);
  headlightsContainer.appendChild(rightBeam);

  // Create the central GTR logo effect
  const gtrLogo = createGTRLogo();
  headlightsContainer.appendChild(gtrLogo);

  // Add to document
  document.body.appendChild(headlightsContainer);

  // Start animation
  animateHeadlights();
}

/**
 * Creates an individual headlight beam
 */
function createHeadlightBeam(position) {
  const beam = document.createElement('div');
  beam.className = `headlight-beam ${position}-beam`;

  // Position beam based on configuration
  const offset = position === 'left' ?
                -(HEADLIGHT_CONFIG.beamWidth + HEADLIGHT_CONFIG.beamSpacing/2) :
                (HEADLIGHT_CONFIG.beamSpacing/2);

  beam.style.width = `${HEADLIGHT_CONFIG.beamWidth}vw`;
  beam.style.left = `calc(50% + ${offset}vw)`;

  // Create inner glow effect
  const glow = document.createElement('div');
  glow.className = 'headlight-glow';

  // Create light source
  const source = document.createElement('div');
  source.className = 'headlight-source';

  // Assemble beam
  beam.appendChild(glow);
  beam.appendChild(source);

  return beam;
}

/**
 * Creates the GTR logo effect between headlights
 */
function createGTRLogo() {
  const logoContainer = document.createElement('div');
  logoContainer.className = 'gtr-logo-effect';

  // Create pulsing elements
  const outerRing = document.createElement('div');
  outerRing.className = 'logo-ring outer-ring';

  const middleRing = document.createElement('div');
  middleRing.className = 'logo-ring middle-ring';

  const innerRing = document.createElement('div');
  innerRing.className = 'logo-ring inner-ring';

  // Add text
  const logoText = document.createElement('div');
  logoText.className = 'logo-text';
  logoText.textContent = 'GTR';

  // Assemble logo
  logoContainer.appendChild(outerRing);
  logoContainer.appendChild(middleRing);
  logoContainer.appendChild(innerRing);
  logoContainer.appendChild(logoText);

  return logoContainer;
}

/**
 * Animates the headlight beams
 */
function animateHeadlights() {
  const beams = document.querySelectorAll('.headlight-beam');
  const glows = document.querySelectorAll('.headlight-glow');

  // Set up pulsing animation
  setInterval(() => {
    // Pulse the beams
    beams.forEach((beam, index) => {
      // Alternate colors between red and blue
      const isBlue = index % 2 === 1;
      const color = isBlue ? HEADLIGHT_CONFIG.blueGlowColor : HEADLIGHT_CONFIG.glowColor;

      // Create the pulse effect
      beam.style.animation = 'none';
      beam.offsetHeight; // Trigger reflow
      beam.style.animation = 'headlightPulse 2s ease-in-out';

      // Update glow color
      const glow = beam.querySelector('.headlight-glow');
      if (glow) {
        glow.style.boxShadow = `0 0 ${HEADLIGHT_CONFIG.glowSize} ${color}`;
      }
    });

    // Pulse the GTR logo
    const logoRings = document.querySelectorAll('.logo-ring');
    logoRings.forEach((ring, index) => {
      ring.style.animation = 'none';
      ring.offsetHeight; // Trigger reflow
      ring.style.animation = `logoRingPulse ${1 + index * 0.2}s ease-in-out`;
    });

  }, HEADLIGHT_CONFIG.pulseInterval);
}

/**
 * Responds to user activity by increasing headlight intensity
 */
function intensifyHeadlights(intensity = 1) {
  // intensity: 0 (dim) to 2 (bright)
  const beams = document.querySelectorAll('.headlight-beam');

  beams.forEach(beam => {
    // Calculate opacity based on intensity
    const opacity = HEADLIGHT_CONFIG.minOpacity +
                   (HEADLIGHT_CONFIG.maxOpacity - HEADLIGHT_CONFIG.minOpacity) * intensity;

    beam.style.opacity = opacity;
  });
}

// Initialize headlight effects
document.addEventListener('DOMContentLoaded', () => {
  createHeadlightEffect();

  // Demo: Change intensity occasionally
  setInterval(() => {
    const intensity = 0.5 + Math.random() * 1.5;
    intensifyHeadlights(intensity);
  }, 5000);
});