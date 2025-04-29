import cv2
import numpy as np


lower = np.array([170,20,20])
upper = np.array([180,255,255])

video = cv2.VideoCapture(0)

while True:

    _, img = video.read()
    hsv_image = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    # rango con limite inferio y superior
    mask = cv2.inRange(hsv_image, lower, upper)
    cv2.imshow("mask", mask)
    masked_frame = cv2.bitwise_and(img, img, mask=mask)
    # inverted_frame = cv2.bitwise_xor(img,img, mask=mask)
    countours, hierachy = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    if countours != 0:
        for contorno in countours:
            if cv2.contourArea(contorno) > 500:
                x,y,width,height = cv2.boundingRect(contorno)
                cv2.rectangle(img,  (x, y), (x+width, y+height), (0,0,255), 3 )

    cv2.imshow("mask_bitwise", masked_frame)
    cv2.imshow("cam", img)
    # cv2.imshow("cam", inverted_frame)
    key = cv2.waitKey(1)
    if key == 27:
        break

video.release()
cv2.destroyAllWindows()    
