# import numpy as np 
# import cv2
import random

# img_file = "bg_1.jpg"

# img = cv2.imread(img_file)
# print(img)

# B, G, R = cv2.split(img)
# print(B)
# cv2.imshow("Fondo", img)
# # cv2.imshow("Azul", B)
# # cv2.imshow("Verde", G)
# # cv2.imshow("Rojo", R)
# print(img.shape)
# print(B.shape)

# zeros =  np.zeros(img.shape[:2], dtype="uint8")
# lienzo = cv2.merge([zeros, zeros, zeros])
# ch, cw, _ = img.shape
# lienzo2 = cv2.merge([zeros, zeros, zeros])

# print(zeros)
# # cv2.imshow("Conjuncion zeros rojos", cv2.merge([zeros, zeros, R]))
# # cv2.imshow("Conjuncion zeros azules", cv2.merge([zeros, B, zeros]))
# # cv2.imshow("Conjuncion zeros verdes", cv2.merge([G, R, B]))
# cv2.imshow("lienzo", lienzo)
# circle = cv2.circle(lienzo, ( int(cw/2), int(ch/2)), 200, (255, 0, 0), -1)
# cv2.imshow("circle", circle)
# rect = cv2.rectangle(lienzo2, (int(cw/2), int(ch/2)), (int(3*cw/4), int(3*ch/4)), (255, 255, 0), -1)
# cv2.imshow("rect", rect)

# cv2.imshow("and", cv2.bitwise_and(circle, rect))
# cv2.imshow("or", cv2.bitwise_or(rect, circle))
# cv2.imshow("xor", cv2.bitwise_xor(rect, circle))
# cv2.imshow("not", cv2.bitwise_not(circle))

# video = cv2.VideoCapture(0)
# video.set(3, 1280)
# video.set(4, 720)

# color_texto = "/NN"

# while True:
#     _, frame = video.read()

#     gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
#     #cv2.imshow("gray", gray)

#     hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
#     cv2.imshow("hsv", hsv)

#     key = cv2.waitKey(1)

#     cx = int(frame.shape[1]/2)
#     cy = int(frame.shape[0]/2)

#     PIXEL_CENTER = hsv[cy, cx]


#     print(PIXEL_CENTER[0])
#     cv2.circle(frame, (cx, cy), 10, (255, 0, 0), 2)
#     cv2.putText(frame, color_texto, (100, 100), cv2.FONT_ITALIC, 1, (frame[cy,cx]),2 )
#     cv2.imshow("video", frame)

#     if key == 27:
#         break

# video.release()
# # cv2.waitKey(-500)
# cv2.destroyAllWindows()