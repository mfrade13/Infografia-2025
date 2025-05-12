import React, { useState, useEffect, useRef } from 'react';
import io from 'socket.io-client';
import '../App.css';

const WebcamDetector = ({ onDetection }) => {
  const [isDetecting, setIsDetecting] = useState(false);
  const [fps, setFps] = useState(10);
  const [realFps, setRealFps] = useState(0);
  const [error, setError] = useState(null);
  const videoRef = useRef(null);
  const socketRef = useRef(null);
  const animationRef = useRef(null);
  const lastFrameTimeRef = useRef(0);
  const frameQueueRef = useRef([]);
  const frameCountRef = useRef(0);
  const lastFpsUpdateRef = useRef(0);

  useEffect(() => {
    socketRef.current = io('http://localhost:5000', {
      transports: ['websocket'],
      reconnection: true,
      reconnectionAttempts: 5,
      reconnectionDelay: 1000,
    });

    socketRef.current.on('connect', () => {
      console.log('Conectado al servidor WebSocket');
      setError(null);
    });

    socketRef.current.on('connect_error', (err) => {
      console.error('Error de conexión:', err);
      setError('No se pudo conectar al servidor. Intente recargar la página.');
      setIsDetecting(false);
    });

    socketRef.current.on('video_frame', (data) => {
      const now = performance.now();
      
      if (frameQueueRef.current.length < 2) {
        frameQueueRef.current.push(data);
      }
      
      if (data.fps) {
        setRealFps(Math.round(data.fps));
      }
    });

    socketRef.current.on('video_error', (data) => {
      setError(data.message || 'Error en la transmisión de video');
      setIsDetecting(false);
    });

    return () => {
      if (socketRef.current) {
        socketRef.current.disconnect();
      }
    };
  }, []);

  useEffect(() => {
    const processFrame = () => {
      const now = performance.now();
      const minFrameInterval = 1000 / fps;

      if (now - lastFpsUpdateRef.current >= 1000) {
        lastFpsUpdateRef.current = now;
        frameCountRef.current = 0;
      }

      if (frameQueueRef.current.length > 0 && now - lastFrameTimeRef.current >= minFrameInterval) {
        const frameData = frameQueueRef.current.shift();
        frameCountRef.current++;

        try {
          if (videoRef.current) {

            const byteString = atob(frameData.frame);
            const byteArray = new Uint8Array(byteString.length);
            for (let i = 0; i < byteString.length; i++) {
              byteArray[i] = byteString.charCodeAt(i);
            }
            const blob = new Blob([byteArray], { type: 'image/jpeg' });
            const imageUrl = URL.createObjectURL(blob);
            
            videoRef.current.src = imageUrl;
            videoRef.current.onload = () => {
              URL.revokeObjectURL(imageUrl);
            };
          }

          if (onDetection) {
            onDetection({
              type: 'video',
              frame: `data:image/jpeg;base64,${frameData.frame}`,
              results: frameData.results,
              timestamp: frameData.timestamp
            });
          }

          lastFrameTimeRef.current = now;
        } catch (err) {
          console.error('Error al procesar frame:', err);
        }
      }

      animationRef.current = requestAnimationFrame(processFrame);
    };

    animationRef.current = requestAnimationFrame(processFrame);

    return () => {
      if (animationRef.current) {
        cancelAnimationFrame(animationRef.current);
      }
    };
  }, [fps, onDetection]);

  const toggleDetection = () => {
    if (!socketRef.current.connected) {
      setError('No hay conexión con el servidor. Intente recargar la página.');
      return;
    }

    const newState = !isDetecting;
    setIsDetecting(newState);

    if (newState) {
      frameQueueRef.current = [];
      frameCountRef.current = 0;
      lastFpsUpdateRef.current = performance.now();
      socketRef.current.emit('start_video', { fps });
    } else {
      socketRef.current.emit('stop_video');
    }
  };

  return (
    <div className="webcam-detector">
      <h2>Detección en Tiempo Real</h2>
      
      {error && (
        <div className="error-message">
          {error}
          <button onClick={() => window.location.reload()}>Recargar</button>
        </div>
      )}

      <div className="video-container">
        <img
          ref={videoRef}
          alt="Transmisión de cámara"
          style={{
            display: 'block',
            maxWidth: '100%',
            maxHeight: '480px',
            backgroundColor: '#000',
            margin: '0 auto'
          }}
        />
        {isDetecting && (
          <div className="video-stats">
            FPS Objetivo: {fps} | FPS Real: {realFps}
          </div>
        )}
      </div>

      <div className="controls">
        <button
          onClick={toggleDetection}
          className={`detect-button ${isDetecting ? 'active' : ''}`}
          disabled={!!error}
        >
          {isDetecting ? (
            <>
              <span className="recording-dot"></span> Detener Detección
            </>
          ) : (
            'Iniciar Detección'
          )}
        </button>

        <div className="fps-control">
          <label>FPS:</label>
          <input
            type="range"
            min="1"
            max="30"
            value={fps}
            onChange={(e) => setFps(parseInt(e.target.value))}
            disabled={isDetecting || !!error}
          />
          <span>{fps}</span>
        </div>
      </div>
    </div>
  );
};

export default WebcamDetector;