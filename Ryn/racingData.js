// Racing Data Service
const RacingDataService = {
    // Cache for the parsed data
    _data: null,

    // Initialize the service
    async init() {
        try {
            const response = await fetch('wikipedia.txt');
            const text = await response.text();
            this._data = JSON.parse(text);
            console.log('Racing data loaded successfully');
            return true;
        } catch (error) {
            console.error('Error loading racing data:', error);
            return false;
        }
    },

    // Get all racing movies
    getMovies() {
        if (!this._data) throw new Error('Data not initialized');
        return this._data.racing_movies;
    },

    // Get all racing news
    getNews() {
        if (!this._data) throw new Error('Data not initialized');
        return this._data.racing_news;
    },

    // Get all racing circuits
    getCircuits() {
        if (!this._data) throw new Error('Data not initialized');
        return this._data.racing_circuits;
    },

    // Get a specific movie by ID
    getMovieById(id) {
        if (!this._data) throw new Error('Data not initialized');
        return this._data.racing_movies.find(movie => movie.id === id);
    },

    // Get a specific news item by ID
    getNewsById(id) {
        if (!this._data) throw new Error('Data not initialized');
        return this._data.racing_news.find(news => news.id === id);
    },

    // Get a specific circuit by ID
    getCircuitById(id) {
        if (!this._data) throw new Error('Data not initialized');
        return this._data.racing_circuits.find(circuit => circuit.id === id);
    }
};

// Initialize the service when the script loads
RacingDataService.init().then(() => {
    console.log('Racing Data Service initialized');
}).catch(error => {
    console.error('Failed to initialize Racing Data Service:', error);
}); 