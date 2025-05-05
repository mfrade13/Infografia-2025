import easyocr
import matplotlib.pyplot as plt 
import cv2

reader = easyocr.Reader(['es'])
result = reader.readtext('test_ci.jpeg')

print(result)

img = plt.imread("test_ci.jpeg")

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

