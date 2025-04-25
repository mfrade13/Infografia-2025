import numpy as np 
import cv2

img_file = "bg_1.jpg"

img = cv2.imread(img_file)
print(img)

B, G, R = cv2.split(img)
print(B)
cv2.imshow("Fondo", img)
cv2.imshow("Azul", B)
cv2.imshow("Verde", G)
cv2.imshow("Rojo", R)
print(img.shape)
print(B.shape)

zeros =  np.zeros(img.shape[:2], dtype="uint8")
print(zeros)
cv2.imshow("Conjuncion zeros rojos", cv2.merge([zeros, zeros, R]))
cv2.imshow("Conjuncion zeros azules", cv2.merge([zeros, B, zeros]))
cv2.imshow("Conjuncion zeros verdes", cv2.merge([G, R, B]))

cv2.waitKey(-500)
cv2.destroyAllWindows()