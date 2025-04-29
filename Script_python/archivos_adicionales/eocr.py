import easyocr
import matplotlib.pyplot as plt 
import cv2

reader = easyocr.Reader(['en'])
result = reader.readtext('sample4.jpg')

# print(result)

img = plt.imread("sample4.jpg")

figure = plt.figure(figsize=(15,15))

plt.imshow(img)

for val in result:
    print(val)
    x = [n[0] for n in val[0]]
    print(x)
    y = [n[1] for n in val[0]]
    plt.fill(x,y,facecolor="none", edgecolor="blue")
    plt.text(x[1], y[1], val[1], color="blue", fontsize=15)

plt.axis("off")
plt.savefig("salida.png")
plt.show()

