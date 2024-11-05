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
    const { title, description, sellerID, startDate, endDate, auctionItem } = req.body;

    // Validate input data
    if (!title || !description || !sellerID || !startDate || !endDate || !auctionItem) {
        return res.status(400).json({ error: 'Missing required fields' });
    }

    const { itemTitle, itemDescription, itemImageUrl, itemCategory } = auctionItem;

    // Validate auction item data
    if (!itemTitle || !itemDescription || !itemCategory) {
        return res.status(400).json({ error: 'Missing required fields for auction item' });
    }

    try {
        // Start a transaction
        await sql.begin();
        
        // Insert the auction item first
        const auctionItemResult = await sql.query`INSERT INTO AuctionItems (title, description, imageUrl, category) VALUES (${itemTitle}, ${itemDescription}, ${itemImageUrl}, ${itemCategory})`;
        const auctionItemID = auctionItemResult.recordset[0].id; // Get the newly created auction item's ID

        // Insert the auction with the reference to the auction item
        await sql.query`INSERT INTO Auctions (title, description, sellerID, startDate, endDate, auctionItemID) VALUES (${title}, ${description}, ${sellerID}, ${startDate}, ${endDate}, ${auctionItemID})`;

        // Commit the transaction
        await sql.commit();
        
        res.status(201).json({ message: 'Auction created successfully', auctionItemID });
    } catch (error) {
        // Rollback transaction in case of error
        await sql.rollback();
        res.status(500).json({ error: 'Error creating auction', details: error.message });
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
app.get('/api/user/email/:email', async (req, res) => {
    const { email } = req.params;
    try {
        const result = await sql.query`SELECT * FROM Users WHERE email = ${email}`;
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
    const { id, username, password, codicefisc, email, address, bio, notificationsEnabled } = req.body;

    console.log("Received data:", req.body); // Log incoming request data

    try {
        const result = await sql.query`
            MERGE INTO Users AS target
            USING (SELECT ${id} AS id) AS source
            ON target.id = source.id
            WHEN MATCHED THEN
                UPDATE SET 
                    username = ${username}, 
                    codicefisc = ${codicefisc}, 
                    password = ${password}, 
                    email = ${email}, 
                    address = ${address}, 
                    bio = ${bio}, 
                    notificationsEnabled = ${notificationsEnabled}
            WHEN NOT MATCHED THEN
                INSERT (id, username, codicefisc, password, email, address, bio, notificationsEnabled) 
                VALUES (${id}, ${username}, ${codicefisc}, ${password}, ${email}, ${address}, ${bio}, ${notificationsEnabled});
        `;

        console.log("SQL query executed successfully:", result); // Log the result of the query
        res.json({ message: 'User data saved successfully' });
    } catch (error) {
        console.error("Error saving user data:", error); // Log error details
        res.status(400).json({ error: 'Error saving user data', details: error.message });
    }
});

app.get('/api/auctions-with-items', async (req, res) => {
    try {
        // First, get all auctions
        const auctionsResult = await sql.query('SELECT * FROM Auctions');
        const auctions = auctionsResult.recordset;

        // Extract auctionItemIDs from the auctions
        const auctionItemIDs = auctions.map(auction => auction.auctionItemID);

        // Check if there are auctionItemIDs to fetch
        if (auctionItemIDs.length === 0) {
            return res.json(auctions); // Return auctions with no associated items if none exist
        }

        // Prepare the SQL query to fetch auction items
        const auctionItemsQuery = `
            SELECT * 
            FROM AuctionItems 
            WHERE id IN (${auctionItemIDs.map(id => `'${id}'`).join(', ')})
        `;

        // Fetch all auction items for those auctionItemIDs
        const auctionItemsResult = await sql.query(auctionItemsQuery);
        const auctionItems = auctionItemsResult.recordset;

        // Create a map for easy lookup of auction items by ID
        const auctionItemsMap = auctionItems.reduce((acc, item) => {
            acc[item.id] = item;
            return acc;
        }, {});

        // Enrich auctions with their corresponding auction items
        const enrichedAuctions = auctions.map(auction => ({
            ...auction,
            auctionItem: auctionItemsMap[auction.auctionItemID] // Attach the auctionItem
        }));

        res.json(enrichedAuctions);
    } catch (error) {
        console.error("Error fetching auctions with items", error);
        res.status(500).json({ error: 'Error fetching auctions with items', details: error.message });
    }
});


// Start Server
const PORT = process.env.PORT || 5000;

connectToDatabase().then(() => {
    app.listen(PORT, () => {
        console.log(`Server is running on port ${PORT}`);
    });
});
