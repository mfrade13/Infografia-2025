import cv2
import time
import base64
from ultralytics import YOLO
import threading

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