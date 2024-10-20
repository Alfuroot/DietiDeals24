// auctionController.js

require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const sql = require('mssql');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// SQL Server Configuration
const sqlConfig = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    server: process.env.DB_SERVER,
    database: process.env.DB_DATABASE,
    options: {
        encrypt: true, // Use this if you're on Azure
        trustServerCertificate: true, // Change to false for production
    },
};

// Connect to Azure SQL Database
const connectToDatabase = async () => {
    try {
        await sql.connect(sqlConfig);
        console.log('Connected to Azure SQL Database');
    } catch (error) {
        console.error('Database connection failed:', error);
    }
};

// Auction Routes
app.get('/api/auctions', async (req, res) => {
    try {
        const result = await sql.query('SELECT * FROM Auctions');
        res.json(result.recordset);
    } catch (error) {
        res.status(500).json({ error: 'Error fetching auctions', details: error.message });
    }
});

app.get('/api/auctions/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const result = await sql.query`SELECT * FROM Auctions WHERE id = ${id}`;
        if (result.recordset.length > 0) {
            res.json(result.recordset[0]);
        } else {
            res.status(404).json({ error: 'Auction not found' });
        }
    } catch (error) {
        res.status(500).json({ error: 'Error fetching auction', details: error.message });
    }
});

app.post('/api/auctions', async (req, res) => {
    const { title, description, sellerID, startDate, endDate } = req.body;
    try {
        await sql.query`INSERT INTO Auctions (title, description, sellerID, startDate, endDate) VALUES (${title}, ${description}, ${sellerID}, ${startDate}, ${endDate})`;
        res.status(201).json({ message: 'Auction created successfully' });
    } catch (error) {
        res.status(400).json({ error: 'Error creating auction', details: error.message });
    }
});

// Bids Routes
app.post('/api/auctions/:id/bids', async (req, res) => {
    const { id } = req.params;
    const { userID, amount } = req.body;
    try {
        await sql.query`INSERT INTO Bids (auctionID, userID, amount, date) VALUES (${id}, ${userID}, ${amount}, GETDATE())`;
        res.status(201).json({ message: 'Bid placed successfully' });
    } catch (error) {
        res.status(400).json({ error: 'Error placing bid', details: error.message });
    }
});

app.get('/api/auctions/:id/bids', async (req, res) => {
    const { id } = req.params;
    try {
        const result = await sql.query`SELECT * FROM Bids WHERE auctionID = ${id}`;
        res.json(result.recordset);
    } catch (error) {
        res.status(500).json({ error: 'Error fetching bids', details: error.message });
    }
});

// User Routes
app.get('/api/user/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const result = await sql.query`SELECT * FROM Users WHERE id = ${id}`;
        if (result.recordset.length > 0) {
            res.json(result.recordset[0]);
        } else {
            res.status(404).json({ error: 'User not found' });
        }
    } catch (error) {
        res.status(500).json({ error: 'Error fetching user', details: error.message });
    }
});

// Create or update user
app.post('/api/user', async (req, res) => {
    const { id, name, iban } = req.body;
    try {
        const result = await sql.query`MERGE INTO Users AS target
            USING (SELECT ${id} AS id) AS source
            ON target.id = source.id
            WHEN MATCHED THEN
                UPDATE SET name = ${name}, iban = ${iban}
            WHEN NOT MATCHED THEN
                INSERT (id, name, iban) VALUES (${id}, ${name}, ${iban});`;
        res.json({ message: 'User data saved successfully' });
    } catch (error) {
        res.status(400).json({ error: 'Error saving user data', details: error.message });
    }
});

// Start Server
const PORT = process.env.PORT || 5000;

connectToDatabase().then(() => {
    app.listen(PORT, () => {
        console.log(`Server is running on port ${PORT}`);
    });
});
