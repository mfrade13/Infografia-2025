import cv2

# capture video/ video path
# cap = cv2.VideoCapture(0)


#use trained cars XML classifiers
car_cascade = cv2.CascadeClassifier('haarcascade_car.xml')

frame= cv2.imread("street_cars.jpeg")

gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

#detect cars in image
cars = car_cascade.detectMultiScale(gray, 1.1, 3)
if len(cars)!=0:
    print(cars)
    for (x,y,w,h) in cars:
        cv2.rectangle(frame,(x,y),(x+w,y+h),(0,255,0),2)
        # crop_img = frame[y:y+h,x:x+w]

    cv2.imshow('Cars', frame)
    cv2.waitKey(0)