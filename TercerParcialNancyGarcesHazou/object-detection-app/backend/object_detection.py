# Importaciones para YOLOv8
from ultralytics import YOLO
import cv2
import numpy as np

def load_model():
    # Cargar modelo YOLOv8 (usando yolov8x.pt)
    model = YOLO("models/yolov8x.pt")
    return model, model.names

def process_image(input_path, output_path, model, classes):
    img = cv2.imread(input_path)
    if img is None:
        return []
    
    # Realizar detección con YOLOv8
    results = model(img)
    
    # Procesar resultados
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
            
            # Dibujar rectángulo y etiqueta
            cv2.rectangle(img, (x1, y1), (x2, y2), (0, 255, 0), 2)
            label = f"{classes[cls]} {conf:.2f}"
            (text_width, text_height), _ = cv2.getTextSize(label, cv2.FONT_HERSHEY_SIMPLEX, 0.5, 1)
            cv2.rectangle(img, (x1, y1 - text_height - 10), (x1 + text_width, y1), (0, 255, 0), -1)
            cv2.putText(img, label, (x1, y1 - 5), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 0, 0), 1)
    
    cv2.imwrite(output_path, img)
    return detections