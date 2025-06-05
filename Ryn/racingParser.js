// Simple racing data parser
const RacingParser = {
    async loadData() {
        try {
            // Fetch the text file
            const response = await fetch('wikipedia.txt');
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            // Get the text content
            const text = await response.text();
            console.log('Raw text content:', text.substring(0, 100) + '...'); // Log first 100 chars
            
            // Parse the text data (assuming it's formatted as valid JSON inside the text file)
            const data = this.parseRacingData(text);
            console.log('Parsed data structure:', Object.keys(data));
            
            return data;
        } catch (error) {
            console.error('Error loading racing data:', error);
            console.error('Error details:', error.message);
            return null;
        }
    },

    parseRacingData(text) {
        try {
            // Clean the text and wrap it in proper JSON structure
            let cleanText = text.trim();
            
            // If the text doesn't start with {, wrap it in a JSON object
            if (!cleanText.startsWith('{')) {
                cleanText = `{${cleanText}}`;
            }
            
            // Parse the JSON
            const parsedData = JSON.parse(cleanText);
            
            return parsedData;
        } catch (error) {
            console.error('Error parsing racing data:', error);
            throw new Error('Invalid racing data format');
        }
    }
};