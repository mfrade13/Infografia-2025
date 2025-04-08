const express = require('express');
const app = express();
const port = 3000;

// Random word storage
const words = {
    en: {
    
      1: [
        'apple', 'grape', 'pearl', 'stone', 'chair',
        'house', 'table', 'light', 'plant', 'smile'
      ],
      2: [
        'planet', 'rocket', 'bridge', 'forest', 'castle',
        'flower', 'desert', 'animal', 'island', 'coffee'
      ],
      3: [
        'elephant', 'mountain', 'computer', 'umbrella', 'dinosaur',
        'holiday', 'fiction', 'cottage', 'journey', 'monster'
      ]
    },
    es: {
      1: [
        'perro', 'gallo', 'cielo', 'flota', 'plaza',
        'libro', 'silla', 'arena', 'llave', 'roble'
      ],
      2: [
        'camino', 'puente', 'bosque', 'ciudad', 'sombra',
        'amigos', 'duende', 'flanco', 'planta', 'manana'
      ],
      3: [
        'elefante', 'montaña', 'paraguas', 'avioneta', 'arbolito',
        'muralla', 'manzana', 'campeon', 'sueños', 'amplio'
      ]
    },
    bo: {
      1: [
        'cholo', 'camba', 'farra', 'chupa', 'chela',
        'piola', 'plata', 'chato', 'pucha', 'facha'
      ],
      2: [
        'pajero', 'llajua', 'carnal', 'fresco', 'rumbao',
        'fresco', 'chamba', 'jailon', 'jallpa', 'guagua'
      ],
      3: [
        'chapaco', 'vacilon', 'jaranero', 'pachanga', 'charrear',
        'chalita', 'fritanga', 'parranda', 'chambear', 'rumbear'
      ]
    }
  };
  

// API endpoint
app.get('/word/:language/:difficulty', (req, res) => {
  const { language, difficulty } = req.params;

  // Validate language and difficulty
  if (!['en', 'es', 'bo'].includes(language)) {
    return res.status(400).send({ error: 'Invalid language. Use "en" or "es".' });
  }
  if (!['1', '2', '3'].includes(difficulty)) {
    return res.status(400).send({ error: 'Invalid difficulty. Use 1, 2, or 3.' });
  }

  // Get random word
  const wordList = words[language][difficulty];
  const randomWord = wordList[Math.floor(Math.random() * wordList.length)];

  res.send({ word: randomWord, length:  randomWord.length });
});

// Start the server
app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});