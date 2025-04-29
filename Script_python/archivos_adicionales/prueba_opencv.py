import cv2
import numpy as np

ruta_imagen = "cat.jpeg"
''' TRABAJO CON LAS IMAGENES DEL GATO '''
# img = cv2.imread(ruta_imagen)
# print(img.shape)
# #print(img)
# print(img[256][256])
# # img[256][256] = np.array([0,0,255])
# cv2.imshow("Imagen", img)
# b,g,r = cv2.split(img)
# cv2.imshow("Valor en B", b)
# zeros = np.zeros(img.shape[:2], dtype = "uint8")

# cv2.imshow("Matriz de zeros",zeros)
# cv2.imshow("Canal Rojo", cv2.merge([zeros,zeros, r]))
# cv2.imshow("Nueva imagen", cv2.merge([r,g,b]))

'''
    Trabajo para cambiar las escalas de color en una imagen
'''
# archivo = "1.jpg"
# img = cv2.imread(archivo)
# cv2.imshow("Imagen", img)

# img_gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
# cv2.imshow("Imagen gris", img_gray)

# img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

# print( img[200][200], img_rgb[200][200]  )
# cv2.imshow("RGB", img_rgb)

# img_cmyk = cv2.cvtColor(img, cv2.COLOR_BGR2YCrCb)
# cv2.imshow("CMYK", img_cmyk)

# img_hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
# cv2.imshow("HSV", img_hsv)
# cv2.waitKey(0)

'''
Lectura de la camara
'''
camara = cv2.VideoCapture(0)
texto_color = "COLOR"
while True:
    _, frame = camara.read()
    

    gray_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY) 
    # cv2.imshow("Gray", gray_frame)

    hsv_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)

    height, width, _ = frame.shape
    #print(width, height)
    centro_x = int(width/2)
    centro_y = int(height/2)

    pixel_centro = hsv_frame[centro_y][centro_x]
    hue_centro = pixel_centro[0]
    print(hue_centro)

    if hue_centro>= 90 and hue_centro <=100:
        texto_color = "celeste"
    elif hue_centro>= 135 and hue_centro <=145:
        texto_color = "morado"
    elif hue_centro>= 25 and hue_centro <=30:
        texto_color = "amarillo"
    elif hue_centro>= 15 and hue_centro <=20:
        texto_color = "naranja"
    elif hue_centro>= 0 and hue_centro <=10:
        texto_color = "rojo"
    elif hue_centro>= 145 and hue_centro <=155:
        texto_color = "rosado"
    elif hue_centro>= 50 and hue_centro <=80:
        texto_color = "verde"
    
        

    print(centro_x, centro_y)
    cv2.putText(frame, texto_color, (10,70), 0, 1.5, (0), 5 )
    cv2.circle(frame, (centro_x, centro_y), 8, (255,0,0), 3)
    cv2.imshow("Camara", frame)

    # "celeste"  90-100
    # morado = 135, 145
    # "amarillo" = 25-30
    # naranja"15-20"
    # rojo 0-10
    # rosado 145 -155
    # verde 50-80
    
    key = cv2.waitKey(1)
    if key == 27:
        break

camara.release()
cv2.destroyAllWindows()


