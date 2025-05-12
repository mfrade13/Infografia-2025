import React, { useState } from 'react';
import ImageUploader from './components/ImageUploader';
import WebcamDetector from './components/WebcamDetector';
import ResultsDisplay from './components/ResultsDisplay';
import './App.css';

function App() {
  const [detection, setDetection] = useState(null);

  return (
    <div className="App">
      <header className="App-header">
        <h1>Object Detection App</h1>
        <p>All processing happens in Python backend</p>
      </header>
      <main>
        <div className="detection-methods">
          <ImageUploader onDetection={setDetection} />
          <WebcamDetector onDetection={setDetection} />
        </div>
        <ResultsDisplay detection={detection} />
      </main>
    </div>
  );
}

export default App;