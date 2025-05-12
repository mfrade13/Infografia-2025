import React from 'react';

function ResultsDisplay({ detection }) {
  if (!detection) {
    return (
      <div className="results">
        <p>No detection results yet. Upload an image or start the camera.</p>
      </div>
    );
  }

  return (
    <div className="results">
      <h3>Detection Results</h3>
      
      <div className="result-container">
        {detection.type === 'image' ? (
          <>
            <div className="image-column">
              <h4>Original Image</h4>
              <img 
                src={`http://localhost:5000${detection.original}`} 
                alt="Original" 
                className="result-image"
              />
            </div>
            <div className="image-column">
              <h4>Processed Image</h4>
              <img 
                src={`http://localhost:5000${detection.processed}`} 
                alt="Processed" 
                className="result-image"
              />
            </div>
          </>
        ) : (
          <div className="video-frame">
            <h4>Live Detection</h4>
            <img 
              src={detection.frame} 
              alt="Live Detection" 
              className="result-image"
            />
          </div>
        )}
      </div>
      
      {detection.results && detection.results.length > 0 ? (
        <div className="detection-results">
          <h4>Detected Objects:</h4>
          <ul>
            {detection.results.map((obj, index) => (
              <li key={index}>
                <strong>{obj.label}</strong> - Confidence: {(obj.confidence * 100).toFixed(2)}%
                <div className="box-info">
                  Position: ({obj.box[0]}, {obj.box[1]}) to ({obj.box[2]}, {obj.box[3]})
                </div>
              </li>
            ))}
          </ul>
        </div>
      ) : (
        <p>No objects detected in this frame.</p>
      )}
    </div>
  );
}

export default ResultsDisplay;