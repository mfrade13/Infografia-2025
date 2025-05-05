import cv2
import sys


# Create the haar cascade
face_classifier = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')
eye_classifier = cv2.CascadeClassifier('haarcascade_eye.xml')

# imagen = cv2.imread("friends_img.jpeg")

# gray_image = cv2.cvtColor(imagen, cv2.COLOR_BGR2GRAY)
# cv2.imshow("gray image", gray_image)

# # Detect faces in the image
# faces = face_classifier.detectMultiScale(
#     gray_image,
#     scaleFactor=1.1,
#     minNeighbors=5,
#     minSize=(25, 25)
#     #flags = cv2.CV_HAAR_SCALE_IMAGE
# )
# print(faces)
# for (x,y,w,h) in faces:
#     cv2.rectangle(imagen, (x,y), (x+w, y+h), (255,0,0), 2 )
# cv2.imshow("frends image", imagen)


# cv2.waitKey(0)

camara = cv2.VideoCapture(0)
while True:
    _, frame = camara.read()
    # Read the image

    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

    # Detect faces in the image
    faces = face_classifier.detectMultiScale(
        gray,
        scaleFactor=1.1,
        minNeighbors=5,
        minSize=(30, 30)
        #flags = cv2.CV_HAAR_SCALE_IMAGE
    )

    print("Found {} faces!".format(len(faces)))

    print(faces)
    # Draw a rectangle around the faces
    for (x, y, w, h) in faces:
        cv2.rectangle(frame, (x, y), (x+w, y+h), (0, 255, 0), 2)
        face_gray = gray[y:y+h, x:x+w]
        face_color = frame[y:y+h, x:x+w]
        eyes = eye_classifier.detectMultiScale(face_gray, 1.2, 3)
        for (ex,ey,ew,eh) in eyes:
            cv2.rectangle(face_color,(ex,ey),(ex+ew,ey+eh),(255,155,0),2)


    cv2.imshow("Faces found", frame)
    key = cv2.waitKey(1)
    if key == 27:
        break

camara.release()
cv2.destroyAllWindows()
