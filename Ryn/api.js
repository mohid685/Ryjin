// // api.js - REST API implementation for parsing wikipedia.txt

// const fs = require('fs');
// const path = require('path');
// const http = require('http');

// // Configuration
// const PORT = 3000;
// const DATA_FILE = 'wikipedia.txt';

// // Helper function to parse the text file
// function parseDataFile() {
//     try {
//         const filePath = path.join(__dirname, DATA_FILE);
//         const fileContent = fs.readFileSync(filePath, 'utf8');

//         // Simple parsing of the text file (this assumes proper JSON format)
//         const data = JSON.parse(fileContent);

//         // Print entire parsed contents
//         console.log('Parsed data:', JSON.stringify(data, null, 2));

//         return data;
//     } catch (error) {
//         console.error(`Error parsing data file: ${error.message}`);
//         return null;
//     }
// }

// // Create HTTP server
// const server = http.createServer(async (req, res) => {
//     // CORS headers
//     res.setHeader('Access-Control-Allow-Origin', '*');
//     res.setHeader('Access-Control-Allow-Methods', 'GET');
//     res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

//     // Handle preflight requests
//     if (req.method === 'OPTIONS') {
//         res.writeHead(200);
//         res.end();
//         return;
//     }

//     // Log incoming request
//     console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);

//     // Route handling
//     try {
//         if (req.method === 'GET') {
//             if (req.url === '/api/movies') {
//                 const data = parseDataFile();
//                 if (!data) {
//                     throw new Error('Failed to parse data file');
//                 }

//                 console.log('Sending movies data:', {
//                     racing_movies: data.racing_movies,
//                     count: data.racing_movies.length
//                 });

//                 res.writeHead(200, { 'Content-Type': 'application/json' });
//                 res.end(JSON.stringify({ racing_movies: data.racing_movies }));
//             }
//             else if (req.url === '/api/circuits') {
//                 const data = parseDataFile();
//                 if (!data) {
//                     throw new Error('Failed to parse data file');
//                 }

//                 console.log('Sending circuits data:', {
//                     racing_circuits: data.racing_circuits,
//                     count: data.racing_circuits.length
//                 });

//                 res.writeHead(200, { 'Content-Type': 'application/json' });
//                 res.end(JSON.stringify({ racing_circuits: data.racing_circuits }));
//             }
//             else {
//                 res.writeHead(404, { 'Content-Type': 'application/json' });
//                 res.end(JSON.stringify({ error: 'Endpoint not found' }));
//             }
//         }
//         else {
//             res.writeHead(405, { 'Content-Type': 'application/json' });
//             res.end(JSON.stringify({ error: 'Method not allowed' }));
//         }
//     } catch (error) {
//         console.error(`Error handling request: ${error.message}`);
//         res.writeHead(500, { 'Content-Type': 'application/json' });
//         res.end(JSON.stringify({
//             error: 'Internal server error',
//             message: error.message
//         }));
//     }
// });

// // Start the server
// server.listen(PORT, () => {
//     console.log(`Server running on port ${PORT}`);
//     console.log(`Serving data from ${DATA_FILE}`);

//     // Test parsing the file on startup
//     const testData = parseDataFile();
//     if (testData) {
//         console.log('Data file parsed successfully:');
//         console.log(`- Found ${testData.racing_movies?.length || 0} movies`);
//         console.log(`- Found ${testData.racing_circuits?.length || 0} circuits`);
//     }
// });

// api.js - REST API implementation for parsing wikipedia.txt

const fs = require('fs');
const path = require('path');
const http = require('http');

// Configuration
const PORT = 3000;
const DATA_FILE = 'wikipedia.txt';

// Helper function to parse the text file
function parseDataFile() {
    try {
        const filePath = path.join(__dirname, DATA_FILE);
        const fileContent = fs.readFileSync(filePath, 'utf8');

        // Simple parsing of the text file (this assumes proper JSON format)
        const data = JSON.parse(fileContent);

        // Print entire parsed contents
        console.log('Parsed data:', JSON.stringify(data, null, 2));

        return data;
    } catch (error) {
        console.error(`Error parsing data file: ${error.message}`);
        return null;
    }
}

// Create HTTP server
const server = http.createServer(async (req, res) => {
    // CORS headers
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

    // Handle preflight requests
    if (req.method === 'OPTIONS') {
        res.writeHead(200);
        res.end();
        return;
    }

    // Log incoming request
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.url}`);

    // Route handling
    try {
        if (req.method === 'GET') {
            if (req.url === '/api/movies') {
                const data = parseDataFile();
                if (!data) {
                    throw new Error('Failed to parse data file');
                }

                console.log(`Returning ${data.racing_movies.length} movies`);
                res.writeHead(200, { 'Content-Type': 'application/json' });
                // Return movies array directly
                res.end(JSON.stringify(data.racing_movies));
            }
            else if (req.url === '/api/circuits') {
                const data = parseDataFile();
                if (!data) {
                    throw new Error('Failed to parse data file');
                }

                console.log(`Returning ${data.racing_circuits.length} circuits`);
                res.writeHead(200, { 'Content-Type': 'application/json' });
                // Return circuits array directly
                res.end(JSON.stringify(data.racing_circuits));
            }
            else {
                res.writeHead(404, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ error: 'Endpoint not found' }));
            }
        } else {
            res.writeHead(405, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({ error: 'Method not allowed' }));
        }
    } catch (error) {
        console.error(`Error handling request: ${error.message}`);
        res.writeHead(500, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
            error: 'Internal server error',
            message: error.message
        }));
    }
});

// Start the server
server.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
    console.log(`Serving data from ${DATA_FILE}`);

    const testData = parseDataFile();
    if (testData) {
        console.log('Data file parsed successfully:');
        console.log(`- Found ${testData.racing_movies?.length || 0} movies`);
        console.log(`- Found ${testData.racing_circuits?.length || 0} circuits`);
    }
});
