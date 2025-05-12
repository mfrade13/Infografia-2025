import cv2
import os
from datetime import datetime
from ultralytics import YOLO
import numpy as np 

# Configuración
video_path = "video_seguridad.mp4"
log_file = "detecciones.txt"
output_dir = "segments"
os.makedirs(output_dir, exist_ok=True)

# Cargar modelo YOLOv8 (rápido)
model = YOLO("yolov8n.pt")

# Video
cap = cv2.VideoCapture(video_path)
fps = cap.get(cv2.CAP_PROP_FPS)
frame_delay = int(1000 / fps)

# Variables 
recording = False
writer = None
person_detected = False
last_logged_time = ""
show_gray = False
detect_mode = False

# Creacion ventana de interfaz
def draw_interface(detect_mode, show_gray, recording):
    interfaz = 255 * np.ones((190, 500, 3), dtype=np.uint8)
    cv2.rectangle(interfaz, (0, 0), (500, 200), (0, 0, 0), -1)

    status_text = f"Detectar personas (tecla D): {'Si' if detect_mode else 'No'}"
    gray_text = f"Escala gris (Tecla G): {'Si' if show_gray else 'No'}"
    recording_text = f"Grabar segmento (Tecla S): {'Si' if recording else 'No'}"

    cv2.putText(interfaz, status_text, (10, 40), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 255, 0), 2)
    cv2.putText(interfaz, gray_text, (10, 70), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (138, 135, 135), 2)
    cv2.putText(interfaz, recording_text, (10, 100), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (255, 39, 0), 2)
    cv2.putText(interfaz, "Rebobinar (Tecla R)", (10, 130), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 108, 255), 2)
    cv2.putText(interfaz, "Salir (Tecla Q)", (10, 160), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 0, 255), 2)

    return interfaz

# Registrar deteccion de personas
def log_detection(minuto_segundo):
    global last_logged_time
    if minuto_segundo != last_logged_time:
        with open(log_file, "a") as f:
            f.write(f'"persona detectada" minuto {minuto_segundo}\n')
        last_logged_time = minuto_segundo

# Creacion ventanas
cv2.namedWindow("Video")
cv2.namedWindow("Interfaz")

while True:
    ret, frame = cap.read()
    if not ret:
        break

    timestamp = cap.get(cv2.CAP_PROP_POS_MSEC) / 1000
    min_seg = f"{int(timestamp//60)}:{int(timestamp%60):02d}"

    original_frame = frame.copy()

    # Cambiar video a modo gris
    if show_gray:
        frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        frame = cv2.cvtColor(frame, cv2.COLOR_GRAY2BGR)

    # Detección de personas con yolo
    if detect_mode:
        results = model(original_frame, verbose=False)[0]
        person_detected_in_frame = False
        for box in results.boxes:
            if int(box.cls[0]) == 0:
                x1, y1, x2, y2 = map(int, box.xyxy[0])
                cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 255, 0), 2)
                cv2.putText(frame, "Persona", (x1, y1 - 10),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 0), 2)
                person_detected_in_frame = True
        if person_detected_in_frame and not person_detected:
            log_detection(min_seg)
        person_detected = person_detected_in_frame
    else:
        person_detected = False

    cv2.imshow("Video", frame)
    interfaz = draw_interface(detect_mode, show_gray, recording)
    cv2.imshow("Interfaz", interfaz)

    # Interfaz con entradas de teclado
    key = cv2.waitKey(frame_delay) & 0xFF
    if key == ord('q'):
        break
    elif key == ord('g'):
        show_gray = not show_gray
    elif key == ord('d'):
        detect_mode = not detect_mode
    elif key == ord('s'):
        if not recording:
            now = datetime.now().strftime("%Y%m%d_%H%M%S")
            filename = f"{os.path.splitext(os.path.basename(video_path))[0]}_{now}.mp4"
            path = os.path.join(output_dir, filename)
            fourcc = cv2.VideoWriter_fourcc(*'mp4v')
            writer = cv2.VideoWriter(path, fourcc, fps,
                                     (original_frame.shape[1], original_frame.shape[0]))
            recording = True
        else:
            writer.release()
            recording = False
    elif key == ord('r'):
        cap.set(cv2.CAP_PROP_POS_MSEC, max(0, cap.get(cv2.CAP_PROP_POS_MSEC) - 5000))

    # Grabar segmento de video
    if recording and writer:
        writer.write(original_frame)

cap.release()
if writer:
    writer.release()
cv2.destroyAllWindows()
