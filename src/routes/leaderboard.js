const express = require('express');
const router = express.Router();
const db = require('../db');

// GET /api/leaderboard - get top users by streak
router.get('/', async (req, res) => {
    try {
        const [rows] = await db.query(
            `SELECT 
                user_id,
                username,
                streak,
                last_log_date
            FROM users
            WHERE streak > 0
            ORDER BY streak DESC
            LIMIT 50`
        );

        // Add rank to each user
        const leaderboard = rows.map((user, index) => ({
            rank: index + 1,
            user_id: user.user_id,
            username: user.username,
            streak: user.streak,
            last_log_date: user.last_log_date
        }));

        res.json({ leaderboard });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error while fetching leaderboard' });
    }
});

module.exports = router;