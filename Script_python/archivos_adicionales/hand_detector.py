import cv2
import mediapipe as mp
import time


class handDetector():
    def __init__(self, mode=False, maxHands=3, detectionCon=0, trackCon=0.5):
        self.mode = mode
        self.maxHands = maxHands
        self.detectionCon = detectionCon
        self.trackCon = trackCon
        self.mpHands = mp.solutions.hands
        self.hands = self.mpHands.Hands(self.mode, self.maxHands,
                                        self.detectionCon, self.trackCon)
        self.mpDraw = mp.solutions.drawing_utils
    def findHands(self, img, draw=True):
        imgRGB = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        self.results = self.hands.process(imgRGB)
        # print(results.multi_hand_landmarks)
        if self.results.multi_hand_landmarks:
            for handLms in self.results.multi_hand_landmarks:
                if draw:
                    self.mpDraw.draw_landmarks(img, handLms,
                                               self.mpHands.HAND_CONNECTIONS)
        return img
    def findPosition(self, img, handNo=0, draw=True):
        lmList = []
        if self.results.multi_hand_landmarks:
            count = 0
            myHand = self.results.multi_hand_landmarks[handNo]
            for id, lm in enumerate(myHand.landmark):
                if id ==4 or id ==8:
                    print(id, lm)
                h, w, c = img.shape
                cx, cy = int(lm.x * w), int(lm.y * h)
                # print(id, cx, cy)
                lmList.append([id, cx, cy])
                if draw:
                    cv2.circle(img, (cx, cy), 15, (255, 0, 255), cv2.FILLED)
                    cv2.putText(img, f'{id}',(cx, cy), cv2.FONT_HERSHEY_PLAIN, 2, (255,0,0), 2)
 
            #tips indice, medio, anular y menhique
            for tip in range(2,6):
                if myHand.landmark[tip*4].y < myHand.landmark[tip*4 - 1].y:
                    count +=1
            #tip del pulgar
            if myHand.landmark[4].y < myHand.landmark[3].y and myHand.landmark[4].y < myHand.landmark[5].y:
                count +=1
            tp = myHand.landmark[4]
            ti = myHand.landmark[8]
            #cv2.line(img, (int(tp.y), int(tp.z)), (int(ti.y), int(ti.z)), (0,0,255),5)

            # if myHand.landmark[8].y < myHand.landmark[11].y:
            #     count +=1
            cv2.putText(img, str("Dedos levantados: " + str(count)), (100,70), cv2.FONT_HERSHEY_PLAIN, 
                          3, (255,0,0), 3 )
 
        return lmList

def main():
    pTime = 0
    cTime = 0
    cap = cv2.VideoCapture(0)
    detector = handDetector()
    while True:
        _, img = cap.read()
        img = detector.findHands(img)
        lmList = detector.findPosition(img)

        if len(lmList) != 0:
        #     #print(lmList)
            cv2.line(img, (lmList[4][1], lmList[4][2]), (lmList[8][1], lmList[8][2]), (0, 0, 255), 3)
        cTime = time.time()
        fps = 1 / (cTime - pTime)
        pTime = cTime
        cv2.putText(img, str(int(fps)), (10, 70), cv2.FONT_HERSHEY_PLAIN, 3,
                    (255, 0, 255), 3)
        


        cv2.imshow("Image", img)
        key = cv2.waitKey(1)
        if key == 27:
            break

if __name__ == "__main__":
    main()