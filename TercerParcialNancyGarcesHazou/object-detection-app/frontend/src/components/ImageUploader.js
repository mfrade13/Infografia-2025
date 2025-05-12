import React, { useState } from 'react';
import axios from 'axios';

function ImageUploader({ onDetection }) {

  const [file, setFile] = useState(null);
  const [previewUrl, setPreviewUrl] = useState(null);
  const [isLoading, setIsLoading] = useState(false);


  const handleFileChange = (e) => {
    const selectedFile = e.target.files[0];
    setFile(selectedFile);
    
    if (selectedFile) {
      const reader = new FileReader();
      reader.onloadend = () => { 
        setPreviewUrl(reader.result);
      };
      reader.readAsDataURL(selectedFile);
    } else {
      setPreviewUrl(null);
    }
  };


  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!file) return;

    setIsLoading(true);
    const formData = new FormData();
    formData.append('file', file);

    try {
      const response = await axios.post('http://localhost:5000/upload', formData, {
        headers: {
          'Content-Type': 'multipart/form-data'
        }
      });
      
      onDetection({
        type: 'image',
        original: response.data.original_image,
        processed: response.data.processed_image,
        results: response.data.results
      });
    } catch (error) {
      console.error('Error:', error);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="uploader">
      <h2>Upload Image</h2>
      <form onSubmit={handleSubmit}>
        <input type="file" onChange={handleFileChange} accept="image/*" />
        <button type="submit" disabled={!file || isLoading}>
          {isLoading ? 'Processing...' : 'Detect Objects'}
        </button>
      </form>
      
      {previewUrl && (
        <div className="preview-section">
          <h4>Image Preview:</h4>
          <img 
            src={previewUrl} 
            alt="Preview" 
            style={{ maxWidth: '100%', maxHeight: '200px' }} 
          />
        </div>
      )}
    </div>
  );
}

export default ImageUploader;