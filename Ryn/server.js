const express = require('express');
const path = require('path');
const cors = require('cors');
const pool = require('./db');

const app = express();
app.use(cors());
app.use(express.json());

// Serve static files (HTML, JS, CSS, images)
app.use(express.static(path.join(__dirname)));

// Endpoint to save suggestion
app.post('/api/suggestions', async (req, res) => {
    try {
        const { suggestion } = req.body;
        
        if (!suggestion) {
            return res.status(400).json({ error: 'Suggestion is required' });
        }

        const [result] = await pool.execute(
            'INSERT INTO suggestions (suggestion) VALUES (?)',
            [suggestion]
        );

        res.json({ 
            success: true, 
            message: 'Suggestion saved successfully',
            id: result.insertId 
        });
    } catch (error) {
        console.error('Error saving suggestion:', error);
        res.status(500).json({ error: 'Failed to save suggestion' });
    }
});

// Fallback: serve index.html for all other routes
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
