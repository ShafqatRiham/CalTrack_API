const express = require('express');
const router = express.Router();
const db = require('../db');

const OFF_BASE_URL = 'https://world.openfoodfacts.org/cgi/search.pl';
const USER_AGENT = 'CalTrack/1.0 (your-email@example.com)';

// GET /api/foods/search?query=banana
router.get('/search', async (req, res) => {
    const { query } = req.query;

    if (!query || query.trim() === '') {
        return res.status(400).json({ message: 'Search query is required' });
    }

    try {
        const url = `${OFF_BASE_URL}?search_terms=${encodeURIComponent(query)}&json=true&page_size=20`;

        const response = await fetch(url, {
            headers: {
                'User-Agent': USER_AGENT
            }
        });

        if (!response.ok) {
            return res.status(502).json({ message: 'Failed to reach food database' });
        }

        const data = await response.json();

        // Map Open Food Facts response into a clean shape for our app
        const results = (data.products || [])
            .filter(p => p.product_name && p.nutriments) // skip incomplete entries
            .map(p => ({
                external_api_id: p.code,
                name: p.product_name,
                brand: p.brands || null,
                calories: p.nutriments['energy-kcal_100g'] ?? null,
                protein: p.nutriments['proteins_100g'] ?? null,
                carbs: p.nutriments['carbohydrates_100g'] ?? null,
                fat: p.nutriments['fat_100g'] ?? null,
                fiber: p.nutriments['fiber_100g'] ?? null,
                sugar: p.nutriments['sugars_100g'] ?? null,
                sodium: p.nutriments['sodium_100g'] ?? null,
                serving_size: '100g',
                image_url: p.image_front_small_url || null
            }))
            .filter(f => f.calories !== null); // skip entries with no calorie data

        res.json({ results });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error while searching foods' });
    }
});

// POST /api/foods/save - save a selected API food into our own database
router.post('/save', async (req, res) => {
    const {
        name, calories, protein, carbs, fat, fiber, sugar, sodium,
        serving_size, external_api_id
    } = req.body;

    if (!name || calories === undefined) {
        return res.status(400).json({ message: 'Name and calories are required' });
    }

    try {
        // Avoid inserting duplicates if this food was already saved before
        if (external_api_id) {
            const [existing] = await db.query(
                'SELECT food_id FROM foods WHERE external_api_id = ?',
                [external_api_id]
            );
            if (existing.length > 0) {
                return res.json({ food_id: existing[0].food_id, message: 'Food already exists' });
            }
        }

        const [result] = await db.query(
            `INSERT INTO foods 
            (name, calories, protein, carbs, fat, fiber, sugar, sodium, serving_size, source, external_api_id) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'api', ?)`,
            [name, calories, protein || 0, carbs || 0, fat || 0, fiber || 0, sugar || 0, sodium || 0, serving_size || '100g', external_api_id || null]
        );

        res.status(201).json({ food_id: result.insertId, message: 'Food saved successfully' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error while saving food' });
    }
});

module.exports = router;