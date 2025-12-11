import React, { useState } from 'react';
import axios from 'axios';

function App() {
  const [url, setUrl] = useState('');
  const [shortUrl, setShortUrl] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    // Backend servisine istek at (Docker içinde 'localhost' çalışmaz, tarayıcıdan attığımız için çalışır)
    const res = await axios.post('http://localhost:5000/shorten', { originalUrl: url });
    setShortUrl(res.data.shortUrl);
  };

  return (
    <div style={{ textAlign: 'center', marginTop: '50px', fontFamily: 'Arial' }}>
      <h1>🚀 DevOps Link Kısaltıcı</h1>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          placeholder="Uzun linki yapıştır..."
          value={url}
          onChange={(e) => setUrl(e.target.value)}
          style={{ padding: '10px', width: '300px' }}
        />
        <button type="submit" style={{ padding: '10px', marginLeft: '10px', cursor: 'pointer' }}>
          Kısalt
        </button>
      </form>

      {shortUrl && (
        <div style={{ marginTop: '20px' }}>
          <p>Kısa Linkin Hazır:</p>
          <a href={`http://localhost:5000/${shortUrl}`} target="_blank" rel="noreferrer">
            http://localhost:5000/{shortUrl}
          </a>
        </div>
      )}
    </div>
  );
}

export default App;