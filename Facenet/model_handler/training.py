#Utils
from PIL import Image
import glob2
import numpy as np
import cv2
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
import pickle
#Tensorflow
import tensorflow as tf
from tensorflow import keras
from keras.layers import Dense, Lambda, Flatten, Input
from keras.models import Model
from keras.optimizers import Adam
from keras.applications import VGG16
import tensorflow_addons as tfa

def get_YALE_data():
    image_files = glob2.glob("YALE/centered/*")
    names = []
    states = []
    images = []
    for link in image_files:
        name = link.split("/")[-1].split(".")[0]
        state = link.split("/")[-1].split(".")[1]
        image = np.array(Image.open(link))
        names.append(name)
        states.append(state)
        images.append(image)
    # print(len(images))
    # print(np.unique(names, return_counts=True))
    return(images,names,states)

def resize_face_data(images):
    faceResizes = []
    for face in images:
        face_rz = cv2.resize(face, (224, 224))
        faceResizes.append(face_rz)
        print("face_rz:", face_rz)

    X = np.stack(faceResizes)
    print(X.shape)
    return X

#Visualize
def _show_images(person, names):
  # Khởi tạo subplot với 2 dòng 5 cột.
  fg, ax = plt.subplots(2, 6, figsize=(20, 8))
  fg.suptitle('All images of one person')
  ids = np.flatnonzero(np.array(names) == person)
  total = 0
  for i in np.arange(2):
    for j in np.arange(6):
      try:
        image = cv2.cvtColor(images[ids[total]], cv2.COLOR_BGR2RGB)
        total+=1
        ax[i, j].imshow(image)
        ax[i, j].axis('off')
      except:
        ax[i, j].axis('off')
        next

#Save load pickle
def _save_pickle(obj, link):
  with open(link, "wb") as f:
    pickle.dump(obj, f)

def _load_pickle(link):
  with open(link, "rb") as f:
    obj = pickle.load(f)
  return obj

#Create base network
def _base_network():
  model = VGG16(include_top = True, weights = None, input_tensor=Input(shape=(224, 224, 1)))
  dense = Dense(128)(model.layers[-4].output)
  norm2 = Lambda(lambda x: tf.math.l2_normalize(x, axis = 1))(dense)
  model = Model(inputs = [model.input], outputs = [norm2])
  return model

#Get data images
(images,names,states) = get_YALE_data()
# Resize Images
X = resize_face_data(images=images)

#Visualize
#_show_images(person='subject01',names=names)

#Split dataset
X_train, X_test, y_train, y_test, id_train, id_test = train_test_split(X, names, np.array((X)), stratify=names,
                                                                           test_size=1 / 11)
print(X_train.shape)
print(X_test.shape)
print(np.unique(y_test, return_counts=True))

 #Save, load pickle
_save_pickle(X, "YALE/X.pkl")
_save_pickle(names, "YALE/y.pkl")

#Training Model:
#Base network
model = _base_network()
model.summary()

model.compile(
    optimizer=tf.keras.optimizers.Adam(0.001),
    loss=tfa.losses.TripletSemiHardLoss())

gen_train = tf.data.Dataset.from_tensor_slices((np.expand_dims(X_train, axis=-1), y_train)).repeat().shuffle(1024).batch(32)

history = model.fit(gen_train,steps_per_epoch=50,epochs=10)
model.save('models/face_yale.h5')

