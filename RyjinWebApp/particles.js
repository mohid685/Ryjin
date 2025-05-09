/**
 * particles.js - Particle effects for background
 */

const Particles = {
    particlesContainer: null,

    /**
     * Initialize particle effects
     */
    init() {
        // Create particles container
        this.particlesContainer = document.createElement('div');
        this.particlesContainer.id = 'particles';
        document.body.appendChild(this.particlesContainer);

        // Create particles
        this.createParticles();
    },

    /**
     * Create particles
     */
    createParticles() {
        for (let i = 0; i < 30; i++) {
            const particle = document.createElement('div');
            particle.className = 'particle';

            // Size between 20px and 100px
            const size = Math.random() * 80 + 20;

            // Random positions
            const posX = Math.random() * window.innerWidth;
            const posY = Math.random() * window.innerHeight;

            // Apply styling
            particle.style.width = `${size}px`;
            particle.style.height = `${size}px`;
            particle.style.left = `${posX}px`;
            particle.style.top = `${posY}px`;

            // Random color between blue and red (GT-R theme)
            const color = Math.random() > 0.7 ? '213,0,0' : '15,76,129';
            const opacity = Math.random() * 0.2 + 0.05;
            particle.style.background = `radial-gradient(circle, rgba(${color},${opacity}) 0%, rgba(${color},0) 70%)`;

            // Add to particles container
            this.particlesContainer.appendChild(particle);

            // Animate particles
            this.animateParticle(particle);
        }
    },

    /**
     * Animate a single particle
     * @param {HTMLElement} particle - Particle element to animate
     */
    animateParticle(particle) {
        // Random movement range
        const moveX = (Math.random() - 0.5) * 100;
        const moveY = (Math.random() - 0.5) * 100;

        // Animation duration between 10 and 25 seconds
        const duration = Math.random() * 15000 + 10000;

        // Set CSS animation
        particle.style.transition = `transform ${duration}ms ease-in-out`;
        particle.style.transform = `translate(${moveX}px, ${moveY}px)`;

        // Reset position after animation completes
        setTimeout(() => {
            particle.style.transition = 'none';
            particle.style.transform = 'translate(0, 0)';

            // Start a new animation after a small delay
            setTimeout(() => this.animateParticle(particle), 50);
        }, duration);
    }
};

// Initialize particles on DOMContentLoaded
document.addEventListener('DOMContentLoaded', () => {
    Particles.init();
});