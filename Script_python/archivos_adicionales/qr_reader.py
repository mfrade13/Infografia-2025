''' '''
import cv2
#import pandas as pd
import numpy as np
from pyzbar import pyzbar
# result = decode(cv2.imread('qr_test2.png'), symbols=[ZBarSymbol.QRCODE])

# image_qr = "qr_test2.png"
# print(result)
current_df = ""



def read_barcodes(frame, current_val):
    barcodes = pyzbar.decode(frame)
    for barcode in barcodes:
        x, y, w, h = barcode.rect
        barcode_info = barcode.data.decode('utf-8')
        print(barcode_info)
        cv2.rectangle(frame, (x, y), (x+w, y+h), (0, 255, 0), 2)

        # 2
        font = cv2.FONT_HERSHEY_DUPLEX
        cv2.putText(frame, barcode_info,
                    (x + 6, y - 6), font,
                    2.0, (255, 255, 255), 1
                    )
        # 3



    return frame


def main():
    # 1
    camera = cv2.VideoCapture(0)
    ret, frame = camera.read()
    current_df = ""
    # 2
    while ret:
        ret, frame = camera.read()
        frame = read_barcodes(frame, current_df)
        cv2.imshow('Barcode/QR code reader', frame)
        if cv2.waitKey(1) & 0xFF == 27:
            break
    # 3
    camera.release()
    cv2.destroyAllWindows()


# Í
if __name__ == '__main__':
    main()
