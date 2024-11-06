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

// PATCH endpoint to update the auction's current price
app.patch('/api/auctions/:auctionId', async (req, res) => {
    const { auctionId } = req.params;
    const { currentPrice } = req.body;

    // Validate input
    if (!auctionId || currentPrice === undefined) {
        return res.status(400).json({ error: 'Missing required fields: auctionId and/or currentPrice' });
    }

    try {
        // Use parameterized query to avoid SQL injection
        const result = await sql.query`
            UPDATE Auctions
            SET currentPrice = ${currentPrice}
            WHERE id = ${auctionId}
        `;

        // Check if the auction was successfully updated
        if (result.rowsAffected[0] > 0) {
            res.status(200).json({ message: 'Auction current price updated successfully' });
        } else {
            res.status(404).json({ error: 'Auction not found' });
        }
    } catch (error) {
        console.error('Error updating auction:', error.message);
        res.status(500).json({ error: 'Error updating auction current price', details: error.message });
    }
});

const { v4: uuidv4 } = require('uuid');

app.post('/api/auctions', async (req, res) => {
    const { id, title, description, sellerID, startDate, endDate, auctionType, initialPrice, currentPrice, auctionItem } = req.body;

    // Validate main auction fields
    if (!id || !title || !description || !sellerID || !startDate || !endDate || !auctionItem || !auctionType || !initialPrice) {
        return res.status(400).json({ error: 'Missing required fields' });
    }

    // Validate auctionItem fields
    const { id: auctionItemID, title: itemTitle, description: itemDescription, imageUrl: itemImageUrl = null, category: itemCategory } = auctionItem;
    if (!auctionItemID || !itemTitle || !itemDescription || !itemCategory) {
        return res.status(400).json({ error: 'Missing required fields for auction item' });
    }

    // Create a transaction object
    const transaction = new sql.Transaction();

    try {
        // Begin the transaction
        await transaction.begin();

        // Use the transaction's request object for queries
        const request = transaction.request();

        // Insert the auction item with the client-provided UUID
        await request.input('auctionItemID', sql.VarChar(36), auctionItemID)
                     .input('itemTitle', sql.VarChar(255), itemTitle)
                     .input('itemDescription', sql.Text, itemDescription)
                     .input('itemImageUrl', sql.VarChar(255), itemImageUrl)
                     .input('itemCategory', sql.VarChar(50), itemCategory);

        await request.query(`
            INSERT INTO AuctionItems (id, title, description, imageUrl, category) 
            VALUES (@auctionItemID, @itemTitle, @itemDescription, @itemImageUrl, @itemCategory)
        `);

        // Insert the auction with the client-provided UUID and reference to the auction item
        await request.input('auctionID', sql.VarChar(36), id)
                     .input('auctionTitle', sql.VarChar(255), title)
                     .input('auctionDescription', sql.Text, description)
                     .input('sellerID', sql.VarChar(36), sellerID)
                     .input('startDate', sql.DateTime, startDate)
                     .input('endDate', sql.DateTime, endDate)
                     .input('auctionItemRefID', sql.VarChar(36), auctionItemID)
                     .input('auctionType', sql.VarChar(50), auctionType)
                     .input('initialPrice', sql.Decimal(18, 2), initialPrice)
                     .input('currentPrice', sql.Decimal(18, 2), currentPrice);

        await request.query(`
            INSERT INTO Auctions (id, title, description, sellerID, startDate, endDate, auctionItemID, auctionType, initialPrice, currentPrice) 
            VALUES (@auctionID, @auctionTitle, @auctionDescription, @sellerID, @startDate, @endDate, @auctionItemRefID, @auctionType, @initialPrice, @currentPrice)
        `);

        // Commit the transaction
        await transaction.commit();
        res.status(201).json({ message: 'Auction created successfully', auctionID: id });

    } catch (error) {
        // Rollback transaction in case of error
        await transaction.rollback();
        res.status(500).json({ error: 'Error creating auction', details: error.message });
    }
});

// Bids Routes
app.post('/api/auctions/:id/bids', async (req, res) => {
    const { id } = req.params;
    const { bidderID, amount, timestamp } = req.body;

    // Validate required fields
    if (!id || !bidderID || !amount || !timestamp) {
        console.error('Missing Fields:', {
            auctionID: id,
            bidderID,
            amount,
            timestamp
        });
        return res.status(400).json({ error: 'Missing required fields' });
    }

    try {
        await sql.query`INSERT INTO Bid (auctionID, bidderID, amount, timestamp) 
                        VALUES (${id}, ${bidderID}, ${amount}, ${timestamp})`;
        res.status(201).json({ message: 'Bid placed successfully' });
    } catch (error) {
        console.error('Error placing bid:', error.message);
        res.status(500).json({ error: 'Error placing bid', details: error.message });
    }
});

app.get('/api/auctions/:id/bids', async (req, res) => {
    const { id } = req.params;
    try {
        const result = await sql.query`SELECT * FROM Bid WHERE auctionID = ${id}`;
        res.json(result.recordset);
    } catch (error) {
        res.status(500).json({ error: 'Error fetching bids', details: error.message });
    }
});

app.get('/api/auctions/:auctionId/bids', async (req, res) => {
    const { auctionId } = req.params;

    // Validate that auctionId is provided
    if (!auctionId) {
        return res.status(400).json({ error: 'Missing required parameter: auctionId' });
    }

    try {
        // SQL query to get all bids for the specified auction
        const request = new sql.Request();
        request.input('auctionId', sql.VarChar, auctionId);

        const query = `
            SELECT id, auctionID, bidderID, amount, timestamp 
            FROM Bid 
            WHERE auctionID = @auctionId
            ORDER BY timestamp DESC
        `;

        const result = await request.query(query);
        
        // If no bids are found, return an empty array
        if (!result.recordset.length) {
            return res.status(200).json([]);
        }

        // Return the list of bids
        res.status(200).json(result.recordset);
    } catch (error) {
        console.error('Error fetching bids:', error.message);
        res.status(500).json({ error: 'Error fetching bids', details: error.message });
    }
});

// Check if this endpoint is defined properly
app.get('/api/bids', async (req, res) => {
  const { userId } = req.query;

  // Validate that userId is provided
  if (!userId) {
    return res.status(400).json({ error: 'Missing required parameter: userId' });
  }

  try {
    // Use a parameterized query to safely get the user's active bids
    const result = await sql.query`
      SELECT 
          b.*
      FROM 
          [dbo].[Bid] b
      JOIN 
          [dbo].[Auctions] a ON b.auctionID = a.id
      WHERE 
          b.bidderID = ${userId}
      ORDER BY 
          b.timestamp DESC
    `;

    // Return the bids found, or an appropriate message if none found
    if (result.recordset.length > 0) {
      res.status(200).json(result.recordset);
    } else {
      res.status(404).json({ message: 'No active bids found for the user.' });
    }
  } catch (error) {
    console.error('Error fetching user bids:', error.message);
    res.status(500).json({ error: 'Error fetching user bids', details: error.message });
  }
});

// New endpoint to retrieve user data by userID
app.get('/api/user/id/:userID', async (req, res) => {
    const { userID } = req.params;

    try {
        // Query to fetch user data by userID
        const result = await sql.query`SELECT * FROM Users WHERE id = ${userID}`;

        // Check if user data is found
        if (result.recordset.length > 0) {
            res.json(result.recordset[0]); // Send user data as JSON
        } else {
            res.status(404).json({ error: 'User not found' });
        }
    } catch (error) {
        console.error("Error fetching user data:", error.message);
        res.status(500).json({ error: 'Error fetching user', details: error.message });
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

app.patch('/api/user/:userId', async (req, res) => {
    const { userId } = req.params;
    const updates = req.body;

    // Check if userId is provided
    if (!userId) {
        return res.status(400).json({ error: 'Missing required parameter: userId' });
    }

    // Check if updates are provided
    if (Object.keys(updates).length === 0) {
        return res.status(400).json({ error: 'No fields provided for update' });
    }

    // Build the dynamic SET part of the query
    const keys = Object.keys(updates);
    let setStatements = [];
    for (let key of keys) {
        setStatements.push(`${key} = @${key}`);
    }
    const setString = setStatements.join(", ");

    try {
        const request = new sql.Request();
        keys.forEach(key => {
            request.input(key, updates[key]);
        });
        request.input('userId', sql.VarChar, userId);

        const query = `UPDATE Users SET ${setString} WHERE id = @userId`;
        await request.query(query);

        res.status(200).json({ message: 'User updated successfully' });
    } catch (error) {
        console.error('Error updating user:', error.message);
        res.status(500).json({ error: 'Error updating user data', details: error.message });
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
