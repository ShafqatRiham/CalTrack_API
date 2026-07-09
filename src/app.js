const express = require('express');
console.log('1. express loaded');

require('dotenv').config();
console.log('2. dotenv loaded');

const app = express();
console.log('3. app created');

app.use(express.json());

const authRouter = require('./routes/auth');
console.log('4. auth router loaded');

const foodsRouter = require('./routes/foods');
app.use('/api/foods', foodsRouter);

const mealsRouter = require('./routes/meals');
app.use('/api/meals', mealsRouter);

const activityRouter = require('./routes/activity');
app.use('/api/activity', activityRouter);

const leaderboardRouter = require('./routes/leaderboard');
app.use('/api/leaderboard', leaderboardRouter);

const goalsRouter = require('./routes/goals');
app.use('/api/goals', goalsRouter);

app.use('/api/auth', authRouter);

app.get('/', (req, res) => {
    res.json({ message: 'CalTrack API is running' });
});

const PORT = process.env.PORT || 3000;
console.log('5. PORT is:', PORT);

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running on port ${PORT}`);
});

console.log('6. listen called');