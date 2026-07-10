const express = require('express');
const router = express.Router();
const db = require('../db');

// Calorie estimation using steps, weight and height
// Note: this is an approximation — accuracy varies per individual
// Verify against a reliable health/fitness source before presenting as medically accurate
function estimateCalories(steps, weight_kg, height_cm) {
    if (weight_kg && height_cm) {
        // Estimate stride length from height
        // Approximate: stride length ≈ height × 0.414
        const stride_length_m = (height_cm * 0.414) / 100;
        const distance_km = (steps * stride_length_m) / 1000;
        // MET-based approximation for walking at average pace (5km/h)
        // calories ≈ MET × weight_kg × duration_hours
        const duration_hours = distance_km / 5;
        const calories = 3.5 * weight_kg * duration_hours;
        return Math.round(calories * 10) / 10;
    } else if (weight_kg) {
        // Weight only fallback
        return Math.round(steps * 0.0005 * weight_kg * 10) / 10;
    }
    // No body data fallback
    return Math.round(steps * 0.04 * 10) / 10;
}

// POST /api/activity/log - log steps for a day
router.post('/log', async (req, res) => {
    const { user_id, steps, log_date } = req.body;

    if (!user_id || steps === undefined || !log_date) {
        return res.status(400).json({ message: 'user_id, steps and log_date are required' });
    }

    try {
        // Get user's weight and height for more accurate calorie calculation
        const [users] = await db.query(
            'SELECT weight, weight_unit, height, height_unit FROM users WHERE user_id = ?',
            [user_id]
        );

        let weight_kg = null;
        let height_cm = null;

        if (users.length > 0) {
            const user = users[0];

            if (user.weight) {
                weight_kg = user.weight_unit === 'lbs'
                    ? user.weight * 0.453592
                    : user.weight;
            }

            if (user.height) {
                height_cm = user.height_unit === 'ft'
                    ? user.height * 30.48
                    : user.height;
            }
        }

        const calories_burned = estimateCalories(steps, weight_kg, height_cm);

        // Check if an entry already exists for this user and date
        const [existing] = await db.query(
            'SELECT activity_id FROM activity_logs WHERE user_id = ? AND log_date = ?',
            [user_id, log_date]
        );

        if (existing.length > 0) {
            // Update existing entry
            await db.query(
                'UPDATE activity_logs SET steps = ?, calories_burned = ? WHERE user_id = ? AND log_date = ?',
                [steps, calories_burned, user_id, log_date]
            );
        } else {
            // Insert new entry
            await db.query(
                'INSERT INTO activity_logs (user_id, log_date, steps, calories_burned) VALUES (?, ?, ?, ?)',
                [user_id, log_date, steps, calories_burned]
            );
        }

        res.status(201).json({
            message: 'Activity logged successfully',
            steps,
            calories_burned,
            note: 'Calorie estimate is approximate and varies based on individual factors'
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error while logging activity' });
    }
});

// GET /api/activity?user_id=1&date=2026-07-08 - get activity for a specific date
router.get('/', async (req, res) => {
    const { user_id, date } = req.query;

    if (!user_id || !date) {
        return res.status(400).json({ message: 'user_id and date are required' });
    }

    try {
        const [rows] = await db.query(
            'SELECT * FROM activity_logs WHERE user_id = ? AND log_date = ?',
            [user_id, date]
        );

        if (rows.length === 0) {
            return res.json({
                date,
                steps: 0,
                calories_burned: 0
            });
        }

        res.json({
            date,
            steps: rows[0].steps,
            calories_burned: rows[0].calories_burned
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error while fetching activity' });
    }
});

module.exports = router;