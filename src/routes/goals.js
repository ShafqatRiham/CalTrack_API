const express = require('express');
const router = express.Router();
const db = require('../db');

// POST /api/goals - set or update calorie goal for a date
router.post('/', async (req, res) => {
    const { user_id, goal_date, calorie_goal } = req.body;

    if (!user_id || !goal_date || !calorie_goal) {
        return res.status(400).json({ message: 'user_id, goal_date and calorie_goal are required' });
    }

    if (calorie_goal <= 0) {
        return res.status(400).json({ message: 'Calorie goal must be greater than 0' });
    }

    try {
        // Insert or update if already exists for this date
        await db.query(
            `INSERT INTO daily_goals (user_id, goal_date, calorie_goal)
            VALUES (?, ?, ?)
            ON DUPLICATE KEY UPDATE calorie_goal = ?`,
            [user_id, goal_date, calorie_goal, calorie_goal]
        );

        res.status(201).json({
            message: 'Calorie goal set successfully',
            goal_date,
            calorie_goal
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error while setting goal' });
    }
});

// GET /api/goals?user_id=1&date=2026-07-10 - get goal for a specific date
router.get('/', async (req, res) => {
    const { user_id, date } = req.query;

    if (!user_id || !date) {
        return res.status(400).json({ message: 'user_id and date are required' });
    }

    try {
        const [rows] = await db.query(
            'SELECT calorie_goal FROM daily_goals WHERE user_id = ? AND goal_date = ?',
            [user_id, date]
        );

        if (rows.length === 0) {
            return res.json({ calorie_goal: null });
        }

        res.json({ calorie_goal: rows[0].calorie_goal });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error while fetching goal' });
    }
});

module.exports = router;