/**
* GTR R35 Themed Speedometers
* Creates and controls dynamic speedometer gauges for displaying stats
*/

// Default settings for speedometers
const SPEEDOMETER_DEFAULTS = {
 minValue: 0,
 maxValue: 100,
 animationDuration: 1500,
 redline: 85, // % where redline begins
 ticksCount: 11,
 majorTicksCount: 6
};

/**
* Create speedometer display for user counts and rooms
*/
function createSpeedometers() {
 // Create speedometer container if it doesn't exist
 if (!document.querySelector('.speedometer-container')) {
   const dashboardContainer = document.getElementById('dashboardContainer');
   if (!dashboardContainer) return;

   const roomsSection = document.querySelector('.rooms-section');
   if (!roomsSection) return;

   const container = document.createElement('div');
   container.className = 'speedometer-container';

   // Create rooms speedometer
   const roomsGauge = document.createElement('div');
   roomsGauge.className = 'gauge-wrapper rooms-gauge';

   const roomsLabel = document.createElement('div');
   roomsLabel.className = 'gauge-label';
   roomsLabel.innerHTML = '<span></span>';

   const roomsSpeedometer = createSpeedometerElement('rooms-speedo', 12, 50, 'blue');
   roomsGauge.appendChild(roomsLabel);
   roomsGauge.appendChild(roomsSpeedometer);

   // Create users speedometer
   const usersGauge = document.createElement('div');
   usersGauge.className = 'gauge-wrapper users-gauge';

   const usersLabel = document.createElement('div');
   usersLabel.className = 'gauge-label';
   usersLabel.innerHTML = '<span></span>';

   const usersSpeedometer = createSpeedometerElement('users-speedo', 27, 100, 'red');
   usersGauge.appendChild(usersLabel);
   usersGauge.appendChild(usersSpeedometer);

   // Add to container
   container.appendChild(roomsGauge);
   container.appendChild(usersGauge);

   // Insert before the rooms-section
   dashboardContainer.insertBefore(container, roomsSection);
 }

 // Animate them initially
 updateSpeedometers();
}

/**
* Creates an individual speedometer element
*/
function createSpeedometerElement(id, value, maxValue, theme = 'red') {
 const wrapper = document.createElement('div');
 wrapper.className = `speedometer-element ${theme}-theme`;
 wrapper.id = id;
 wrapper.dataset.value = value;
 wrapper.dataset.max = maxValue;

 // Main speedo face
 const face = document.createElement('div');
 face.className = 'speedo-face';

 // Ticks
 const ticks = document.createElement('div');
 ticks.className = 'speedo-ticks';

 // Create tick marks
 for (let i = 0; i < SPEEDOMETER_DEFAULTS.ticksCount; i++) {
   const tick = document.createElement('div');
   const isMajor = i % (SPEEDOMETER_DEFAULTS.ticksCount / SPEEDOMETER_DEFAULTS.majorTicksCount) === 0;
   tick.className = `tick ${isMajor ? 'major' : 'minor'}`;

   // Calculate angle (-120 to 120 degrees range, -120 is min value, 120 is max)
   const angle = -120 + (i / (SPEEDOMETER_DEFAULTS.ticksCount - 1)) * 240;
   tick.style.transform = `rotate(${angle}deg)`;

//    if (isMajor) {
//      const label = document.createElement('span');
//      label.className = 'tick-label';
//      label.textContent = Math.round(maxValue * (i / (SPEEDOMETER_DEFAULTS.ticksCount - 1)));
//      label.style.transform = `rotate(${-angle}deg)`;
//      tick.appendChild(label);
//    }

   ticks.appendChild(tick);
 }

 // Needle
 const needle = document.createElement('div');
 needle.className = 'needle';

 // Needle center cap
 const cap = document.createElement('div');
 cap.className = 'needle-cap';

 // Digital value
 const digital = document.createElement('div');
 digital.className = 'digital-value';
 
 // Add components to face
 face.appendChild(ticks);
 face.appendChild(needle);
 face.appendChild(cap);

 // Add face and digital value to wrapper
 wrapper.appendChild(face);
 wrapper.appendChild(digital);

 return wrapper;
}

/**
* Updates all speedometers with current values
*/
function updateSpeedometers() {
 const speedometers = document.querySelectorAll('.speedometer-element');

 speedometers.forEach(speedo => {
   const value = parseInt(speedo.dataset.value || 0);
   const max = parseInt(speedo.dataset.max || 100);

   // Get the needle and digital value elements
   const needle = speedo.querySelector('.needle');
   const digital = speedo.querySelector('.digital-value');

   if (!needle || !digital) return;

   // Calculate angle (-120 is min, 120 is max)
   const angle = -120 + (value / max) * 240;

   // Animate needle with easing
   needle.style.transition = `transform ${SPEEDOMETER_DEFAULTS.animationDuration}ms cubic-bezier(0.17, 0.67, 0.83, 0.67)`;
   needle.style.transform = `rotate(${angle}deg)`;

   // Update digital value
//    digital.textContent = value;

   // Add redline effect if approaching max
   if (value >= max * (SPEEDOMETER_DEFAULTS.redline / 100)) {
     speedo.classList.add('redline');
   } else {
     speedo.classList.remove('redline');
   }
 });
}

/**
* Simulates data for demo purposes - replace with real data
*/
function simulateDataChange() {
 // In a real app, you would replace this with actual data from the server
 setInterval(() => {
   const roomsSpeedo = document.getElementById('rooms-speedo');
   const usersSpeedo = document.getElementById('users-speedo');

   if (roomsSpeedo && usersSpeedo) {
     // Random fluctuations for demo
     const newRooms = Math.max(1, Math.min(50, currentRooms + (Math.random() * 1.5 - 0.75)));
    const newUsers = Math.max(1, Math.min(100, currentUsers + (Math.random() * 2 - 1)));

     roomsSpeedo.dataset.value = newRooms;
     usersSpeedo.dataset.value = newUsers;

     updateSpeedometers();
   }
 }, 1000);
}

// Initialize speedometers when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
 createSpeedometers();
 simulateDataChange();
});

