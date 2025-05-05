import pytesseract
try:
    from PIL import Image
except ImportError:
    import Image


# pytesseract.pytesseract.tesseract_cmd = 'C:/Programas/Tesseract/tesseract.exe'
def reconocimiento_de_texto(imagen):
    '''
    '''
    texto = pytesseract.image_to_string(Image.open(imagen))
    return texto

print(reconocimiento_de_texto("web_image.png"))
