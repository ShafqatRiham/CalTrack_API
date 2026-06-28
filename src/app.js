const express = require('express');
console.log('1. express loaded');

require('dotenv').config();
console.log('2. dotenv loaded');

const app = express();
console.log('3. app created');

app.use(express.json());

const authRouter = require('./routes/auth');
console.log('4. auth router loaded');

app.use('/api/auth', authRouter);

app.get('/', (req, res) => {
    res.json({ message: 'CalTrack API is running' });
});

const PORT = process.env.PORT || 3000;
console.log('5. PORT is:', PORT);

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

console.log('6. listen called');