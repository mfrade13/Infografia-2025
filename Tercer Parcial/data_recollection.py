import os
import cv2
import mediapipe as mp
import numpy as np
import pandas as pd

mp_hands = mp.solutions.hands
hands = mp_hands.Hands(static_image_mode=True)
mp_drawing = mp.solutions.drawing_utils

data = []
labels = []

DATASET_PATH = 'dataset'
total_processed = 0

for label in os.listdir(DATASET_PATH):
    label_path = os.path.join(DATASET_PATH, label)
    print(f"Processing label: {label}")
    label_processed = 0
    for img_name in os.listdir(label_path):
        img_path = os.path.join(label_path, img_name)
        img = cv2.imread(img_path)
        img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        results = hands.process(img_rgb)

        if results.multi_hand_landmarks:
            landmarks = results.multi_hand_landmarks[0]
            row = []
            for lm in landmarks.landmark:
                row.extend([lm.x, lm.y, lm.z])
            data.append(row)
            labels.append(label)
            label_processed += 1
            total_processed += 1
    print(f"Images processed for {label}: {label_processed}")

hands.close()

print(f"Total images processed: {total_processed}")

# Guardar en CSV
df = pd.DataFrame(data)
df['label'] = labels
df.to_csv('sign_data.csv', index=False)
