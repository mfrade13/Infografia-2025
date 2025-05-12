from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
import os
from datetime import datetime
import threading
import time
import socketio
import uuid
from ultralytics import YOLO
import cv2
import base64

UPLOAD_FOLDER = 'uploads'
PROCESSED_FOLDER = 'static'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(PROCESSED_FOLDER, exist_ok=True)

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['PROCESSED_FOLDER'] = PROCESSED_FOLDER
CORS(app)

sio = socketio.Server(cors_allowed_origins='*', async_mode='threading')
app.wsgi_app = socketio.WSGIApp(sio, app.wsgi_app)

model = YOLO("models/yolov8x.pt")
classes = model.names

class VideoProcessor:
    def __init__(self, model, classes):
        self.model = model
        self.classes = classes
        self.cap = None
        self.processing = False
        self.fps = 10
        self.last_frame_time = 0
        self.lock = threading.Lock()
        self.frame_counter = 0
        self.start_time = time.time()

    def start_capture(self):
        if self.cap is None or not self.cap.isOpened():
            self.cap = cv2.VideoCapture(0)
            if not self.cap.isOpened():
                for i in range(3):
                    self.cap = cv2.VideoCapture(i)
                    if self.cap.isOpened():
                        break
                else:
                    raise RuntimeError("No se pudo abrir ninguna cámara")
            
            self.cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
            self.cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)
            self.cap.set(cv2.CAP_PROP_FPS, self.fps)
        
        self.processing = True
        self.start_time = time.time()
        self.frame_counter = 0

    def stop_capture(self):
        self.processing = False
        if self.cap and self.cap.isOpened():
            self.cap.release()
        self.cap = None

    def set_fps(self, fps):
        self.fps = max(1, min(30, fps))
        if self.cap and self.cap.isOpened():
            self.cap.set(cv2.CAP_PROP_FPS, self.fps)

    def get_frames(self):
        while self.processing and self.cap and self.cap.isOpened():
            try:
                current_time = time.time()
                elapsed = current_time - self.last_frame_time
                
                if elapsed < 1.0 / self.fps:
                    time.sleep(0.001)
                    continue
                
                ret, frame = self.cap.read()
                if not ret:
                    print("Error al leer el frame de la cámara")
                    time.sleep(0.1)
                    continue
                
                self.frame_counter += 1
                self.last_frame_time = current_time
                
                results = self.model(frame)
                
                detections = []
                for result in results:
                    for box in result.boxes:
                        x1, y1, x2, y2 = map(int, box.xyxy[0])
                        conf = float(box.conf[0])
                        cls = int(box.cls[0])
                        
                        detections.append({
                            "label": self.classes[cls],
                            "confidence": conf,
                            "box": [x1, y1, x2, y2]
                        })
                        

                        cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 255, 0), 2)
                        label = f"{self.classes[cls]} {conf:.2f}"
                        (text_width, text_height), _ = cv2.getTextSize(
                            label, cv2.FONT_HERSHEY_SIMPLEX, 0.6, 1)
                        cv2.rectangle(
                            frame, 
                            (x1, y1 - text_height - 10), 
                            (x1 + text_width, y1), 
                            (0, 255, 0), -1)
                        cv2.putText(
                            frame, label, (x1, y1 - 5), 
                            cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 0, 0), 1)
                
                ret, jpeg = cv2.imencode('.jpg', frame, [
                    int(cv2.IMWRITE_JPEG_QUALITY), 85])
                if not ret:
                    continue
                
                frame_base64 = base64.b64encode(jpeg.tobytes()).decode('utf-8')
                real_fps = self.frame_counter / (time.time() - self.start_time)
                
                yield (frame_base64, detections, real_fps)
                
            except Exception as e:
                print(f"Error en get_frames: {e}")
                time.sleep(0.1)
                continue
        
        self.stop_capture()


video_processor = VideoProcessor(model, classes)

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return jsonify({"error": "No file provided"}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({"error": "No file selected"}), 400
    

    original_filename = file.filename
    ext = original_filename.split('.')[-1]
    unique_filename = f"{datetime.now().strftime('%Y%m%d_%H%M%S')}_{uuid.uuid4().hex}.{ext}"
    

    original_path = os.path.join(app.config['UPLOAD_FOLDER'], unique_filename)
    file.save(original_path)
    

    processed_filename = f"processed_{unique_filename}"
    processed_path = os.path.join(app.config['PROCESSED_FOLDER'], processed_filename)
    

    img = cv2.imread(original_path)
    if img is None:
        return jsonify({"error": "Could not read image"}), 400
    
    results = model(img)
    detections = []
    
    for result in results:
        for box in result.boxes:
            x1, y1, x2, y2 = map(int, box.xyxy[0])
            conf = float(box.conf[0])
            cls = int(box.cls[0])
            
            detections.append({
                "label": classes[cls],
                "confidence": conf,
                "box": [x1, y1, x2, y2]
            })
            

            cv2.rectangle(img, (x1, y1), (x2, y2), (0, 255, 0), 2)
            label = f"{classes[cls]} {conf:.2f}"
            (text_width, text_height), _ = cv2.getTextSize(
                label, cv2.FONT_HERSHEY_SIMPLEX, 0.6, 1)
            cv2.rectangle(
                img, 
                (x1, y1 - text_height - 10), 
                (x1 + text_width, y1), 
                (0, 255, 0), -1)
            cv2.putText(
                img, label, (x1, y1 - 5), 
                cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 0, 0), 1)
    
    cv2.imwrite(processed_path, img)
    
    return jsonify({
        "status": "success",
        "original_image": f"/uploads/{unique_filename}",
        "processed_image": f"/static/{processed_filename}",
        "results": detections
    })


@app.route('/uploads/<filename>')
def uploaded_file(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'], filename)


@app.route('/static/<filename>')
def processed_file(filename):
    return send_from_directory(app.config['PROCESSED_FOLDER'], filename)


@sio.on('connect')
def handle_connect(sid, environ):
    print('Client connected', sid)


@sio.on('start_video')
def handle_start_video(sid, data):
    try:
        fps = data.get('fps', 10)
        video_processor.set_fps(fps)
        video_processor.start_capture()
        
        def video_thread():
            try:
                for frame_bytes, results, real_fps in video_processor.get_frames():
                    frame_data = {
                        'frame': frame_bytes,
                        'results': results,
                        'timestamp': time.time(),
                        'fps': real_fps
                    }
                    sio.emit('video_frame', frame_data, room=sid)
            except Exception as e:
                print(f"Error en video_thread: {e}")
                sio.emit('video_error', {'message': str(e)}, room=sid)
            finally:
                video_processor.stop_capture()
        
        thread = threading.Thread(target=video_thread, daemon=True)
        thread.start()
    except Exception as e:
        print(f"Error al iniciar video: {e}")
        sio.emit('video_error', {'message': str(e)}, room=sid)


@sio.on('stop_video')
def handle_stop_video(sid):
    video_processor.stop_capture()


@sio.on('disconnect')
def handle_disconnect(sid):
    video_processor.stop_capture()
    print('Client disconnected', sid)

if __name__ == '__main__':
    app.run(debug=True, port=5000, threaded=True)