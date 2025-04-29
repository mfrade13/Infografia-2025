import cv2
import pytesseract
 
# Winsows requiere de la ruta donde esta el ejecutable de tesseract
#pytesseract.pytesseract.tesseract_cmd = 'C://users/documentos/tesseract.exe'
 
# Imagen para procesar
# img = cv2.imread("sample4.jpg")
img = cv2.imread("sample4.jpg")

 
# Convertir la imagen a gris para su procesamiento
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
 
# Usar un rango para poder el rango de tonos de la escala
ret, thresh1 = cv2.threshold(gray, 0, 255, cv2.THRESH_OTSU | cv2.THRESH_BINARY_INV)
 
# Specify structure shape and kernel size. 
# Kernel size increases or decreases the area 
# of the rectangle to be detected.
# A smaller value like (10, 10) will detect 
# each word instead of a sentence.
rect_kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (10, 10))
 
# Aplicar la dilatacion a la imagen en base al rango
dilation = cv2.dilate(thresh1, rect_kernel, iterations = 1)
 
# Contornos para encapsular los textis
contours, hierarchy = cv2.findContours(dilation, cv2.RETR_EXTERNAL, 
                                                 cv2.CHAIN_APPROX_NONE)
 
# obteniendo una copia de la imagen
im2 = img.copy()
 
# Creando un archivo para almacenar el texto
file = open("recognized.txt", "w+")
file.write("")
file.close()
 
for cnt in contours:
    x, y, w, h = cv2.boundingRect(cnt)
 
    # Dibujar cuadrados a la imagen 
    rect = cv2.rectangle(im2, (x, y), (x + w, y + h), (255, 255, 0), 4)

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