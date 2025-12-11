const express = require('express');
const redis = require('redis');
const shortid = require('shortid');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
app.use(cors());
app.use(bodyParser.json());

// Redis Bağlantısı (Environment Variable ile alacağız)
const redisHost = process.env.REDIS_HOST || 'localhost';
const redisPort = process.env.REDIS_PORT || 6379;

const redisClient = redis.createClient({
    url: `redis://${redisHost}:${redisPort}`
});

redisClient.on('error', (err) => console.log('Redis Client Error', err));
redisClient.connect();

// 1. Endpoint: URL Kısaltma (POST)
app.post('/shorten', async (req, res) => {
    const { originalUrl } = req.body;
    const id = shortid.generate(); // Rastgele kısa ID oluştur (örn: aX9z)
    
    // Redis'e kaydet: ID -> Uzun URL
    await redisClient.set(id, originalUrl);
    
    res.json({ shortUrl: id });
});

// 2. Endpoint: Yönlendirme (GET)
app.get('/:id', async (req, res) => {
    const { id } = req.params;
    
    // Redis'ten uzun URL'yi bul
    const originalUrl = await redisClient.get(id);
    
    if (originalUrl) {
        res.redirect(originalUrl);
    } else {
        res.status(404).send('Link bulunamadı!');
    }
});

const PORT = 5000;
app.listen(PORT, () => {
    console.log(`Backend API çalışıyor: Port ${PORT}`);
});