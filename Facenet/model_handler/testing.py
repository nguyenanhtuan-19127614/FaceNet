import tensorflow as tf
from tensorflow import keras

from keras.preprocessing.image import load_img
from keras.preprocessing.image import img_to_array

from keras.models import Model
from keras.layers import Dense, Lambda, Flatten, Input
from keras.applications import VGG16

import numpy as np
import cv2
from PIL import Image
from modelHandler import FacenetModel

def _base_network():
  model = VGG16(include_top = True, weights = None, input_tensor=Input(shape=(224, 224, 1)))
  dense = Dense(128)(model.layers[-4].output)
  norm2 = Lambda(lambda x: tf.math.l2_normalize(x, axis = 1))(dense)
  model = Model(inputs = [model.input], outputs = [norm2])
  return model

#==============================================
facenet = FacenetModel()

image1 = load_img('model_handler/testImg.jpeg', target_size=(224, 224), color_mode= "grayscale")
image2 = load_img('model_handler/testImg2.jpeg', target_size=(224, 224), color_mode= "grayscale")

prediction1 = facenet.predict(image1)
prediction2 = facenet.predict(image2)

print(type(prediction1))
print(prediction1)
print(prediction1.shape)

dist = np.linalg.norm(prediction1-prediction2)

print(dist)
