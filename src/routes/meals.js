const express = require('express');
const router = express.Router();
const db = require('../db');

// POST /api/meals/log - create a new meal log with items
router.post('/log', async (req, res) => {
    const { user_id, meal_type, log_date, log_time, items } = req.body;

    if (!user_id || !meal_type || !log_date || !items || items.length === 0) {
        return res.status(400).json({ message: 'user_id, meal_type, log_date and items are required' });
    }

    try {
        // Create the meal log entry first
        const [logResult] = await db.query(
            'INSERT INTO meal_logs (user_id, meal_type, log_date, log_time) VALUES (?, ?, ?, ?)',
            [user_id, meal_type, log_date, log_time || null]
        );

        const log_id = logResult.insertId;

        // Insert each food item linked to that log
        for (const item of items) {
            await db.query(
                `INSERT INTO meal_log_items 
                (log_id, food_id, quantity, unit, calories, protein, carbs, fat) 
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
                [
                    log_id,
                    item.food_id,
                    item.quantity || 1,
                    item.unit || '100g',
                    item.calories,
                    item.protein || 0,
                    item.carbs || 0,
                    item.fat || 0
                ]
            );
        }

        res.status(201).json({
            message: 'Meal logged successfully',
            log_id
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error while logging meal' });
    }
});

// GET /api/meals?user_id=1&date=2026-07-01 - get all meals for a user on a date
router.get('/', async (req, res) => {
    const { user_id, date } = req.query;

    if (!user_id || !date) {
        return res.status(400).json({ message: 'user_id and date are required' });
    }

    try {
        const [logs] = await db.query(
            `SELECT 
                ml.log_id,
                ml.meal_type,
                ml.log_date,
                ml.log_time,
                mli.item_id,
                mli.food_id,
                mli.quantity,
                mli.unit,
                mli.calories,
                mli.protein,
                mli.carbs,
                mli.fat,
                f.name AS food_name
            FROM meal_logs ml
            JOIN meal_log_items mli ON ml.log_id = mli.log_id
            JOIN foods f ON mli.food_id = f.food_id
            WHERE ml.user_id = ? AND ml.log_date = ?
            ORDER BY ml.meal_type, ml.log_time`,
            [user_id, date]
        );

        // Group items under their meal log
        const grouped = {};
        for (const row of logs) {
            if (!grouped[row.log_id]) {
                grouped[row.log_id] = {
                    log_id: row.log_id,
                    meal_type: row.meal_type,
                    log_date: row.log_date,
                    log_time: row.log_time,
                    items: []
                };
            }
            grouped[row.log_id].items.push({
                item_id: row.item_id,
                food_id: row.food_id,
                food_name: row.food_name,
                quantity: row.quantity,
                unit: row.unit,
                calories: row.calories,
                protein: row.protein,
                carbs: row.carbs,
                fat: row.fat
            });
        }

        // Calculate daily totals
        let totalCalories = 0;
        let totalProtein = 0;
        let totalCarbs = 0;
        let totalFat = 0;

        for (const row of logs) {
            totalCalories += parseFloat(row.calories) || 0;
            totalProtein += parseFloat(row.protein) || 0;
            totalCarbs += parseFloat(row.carbs) || 0;
            totalFat += parseFloat(row.fat) || 0;
        }

        res.json({
            date,
            meals: Object.values(grouped),
            daily_totals: {
                calories: Math.round(totalCalories * 10) / 10,
                protein: Math.round(totalProtein * 10) / 10,
                carbs: Math.round(totalCarbs * 10) / 10,
                fat: Math.round(totalFat * 10) / 10
            }
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error while fetching meals' });
    }
});

// DELETE /api/meals/item/:item_id - remove a single food from a meal
router.delete('/item/:item_id', async (req, res) => {
    const { item_id } = req.params;

    try {
        await db.query('DELETE FROM meal_log_items WHERE item_id = ?', [item_id]);
        res.json({ message: 'Item removed successfully' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error while removing item' });
    }
});

module.exports = router;