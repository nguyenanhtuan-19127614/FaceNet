import tensorflow as tf
from tensorflow import keras
from keras.preprocessing.image import load_img
from keras.preprocessing.image import img_to_array
from keras.models import Model
from keras.layers import Dense, Lambda, Flatten, Input
from keras.applications import VGG16

import os
import base64
from PIL import Image,ImageOps
import cv2
import io
import numpy as np

class FacenetModel:

  imageSize = 224

  def __init__(self):
    self.model = self.__facenet_model()

  def predictBase64(self,base64Str):

    #Decode base64 -> PIL image type
    base64PILImg = self.__stringToPILType(base64Str)

    #Predict
    return self.predict(base64PILImg)

  def predict(self, image):
    image = img_to_array(image)
    image = image.reshape((1, image.shape[0], image.shape[1], image.shape[2]))
    # flatten để trả về mảng 1 chiều, dễ lưu data
    return self.model.predict(image).flatten()

  def __stringToPILType(self,base64_string):
    
    str = base64_string.replace(' ', '+')
    imgdata = base64.b64decode(str)

    img = Image.open(io.BytesIO(imgdata))
    img = img.resize((224, 224))
    grayscale = ImageOps.grayscale(img)
    return grayscale

  def __facenet_model(self):
    model = VGG16(include_top=True, weights=None, input_tensor=Input(shape=(224, 224, 1)))
    dense = Dense(128)(model.layers[-4].output)
    norm2 = Lambda(lambda x: tf.math.l2_normalize(x, axis=1))(dense)
    model = Model(inputs=[model.input], outputs=[norm2])

    ROOT_DIR = os.path.dirname(
      os.path.dirname(
        os.path.abspath(__file__)
      )
    )
    model_dir = ROOT_DIR + "/models/face_yale.h5"
    model.load_weights(model_dir)
    return model


