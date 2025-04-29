import cv2
import numpy as np



# dibujar un cuadrado
square = np.zeros((500, 500), np.uint8)
# cv2.imshow("square_zeros", square)
square = cv2.cvtColor(square, cv2.COLOR_GRAY2RGB)
cv2.rectangle(square, (50, 50), (450, 450), (255,0,0), -2)
cv2.imshow("square", square)

#dibujar una elipse
ellipse = np.zeros((500, 500), np.uint8)
ellipse = cv2.cvtColor(ellipse, cv2.COLOR_GRAY2RGB)
cv2.ellipse(ellipse, (250, 250), (150, 250), 30, 0, 250, (255,0,0), -1)
cv2.imshow("elipse", ellipse)

and_img = cv2.bitwise_and(square, ellipse)
cv2.imshow("and_bitwise", and_img)

and_elipse_square = cv2.bitwise_and(ellipse, square)
#cv2.imshow("and", and_elipse_square)

or_img = cv2.bitwise_or(square, ellipse)
cv2.imshow("Or_img", or_img)

not_img_sqr = cv2.bitwise_not(square)
cv2.imshow("not_Sqr", not_img_sqr)
not_img_elipse = cv2.bitwise_not(ellipse)
cv2.imshow("not_Elipse", not_img_elipse)

xor_img = cv2.bitwise_xor(ellipse, square)
cv2.imshow("XOR", xor_img)


cv2.waitKey()

