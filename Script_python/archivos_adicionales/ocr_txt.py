import cv2
import pytesseract

img = cv2.imread("captcha_test.jpg")
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
ret, thresh1 = cv2.threshold(gray, 0, 255, cv2.THRESH_OTSU | cv2.THRESH_BINARY_INV)
rect_kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (18, 18))

dilation = cv2.dilate(thresh1, rect_kernel, iterations = 1)
contours, hierarchy = cv2.findContours(dilation, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)

im2 = img.copy()
 
# Creando un archivo para almacenar el texto
file = open("recognized.txt", "w+")
file.write("")
file.close()

for cnt in contours:
    x, y, w, h = cv2.boundingRect(cnt)
 
    # Dibujar cuadrados a la imagen 
    rect = cv2.rectangle(im2, (x, y), (x + w, y + h), (0, 255, 0), 2)

    # Recortar la imagen para procesar
    cropped = im2[y:y + h, x:x + w]

    # Actualizar el archivo creado
    file = open("recognized.txt", "a")

    # Aplicar OCR al texto para recuperar su contenido
    text = pytesseract.image_to_string(cropped)

    # Adicionar nuevo texto al archivo
    file.write(text)
    file.write("\n")

    # Close the file
    file.close
cv2.imshow("output", im2)
cv2.waitKey(0)