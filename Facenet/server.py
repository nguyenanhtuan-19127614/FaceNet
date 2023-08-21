from flask import Flask
from pymongo import MongoClient
from model_handler.modelHandler import FacenetModel
from keras.preprocessing.image import load_img
import numpy as np

facenetModel = FacenetModel()
app = Flask(__name__)
client = MongoClient(host='0.0.0.0', port=105)

@app.route('/hello/', methods=['GET', 'POST'])
def welcome():
    data = {"success": True}

    image1 = load_img('model_handler/testImg.jpeg', target_size=(224, 224), color_mode="grayscale")
    image2 = load_img('model_handler/testImg2.jpeg', target_size=(224, 224), color_mode="grayscale")
    prediction1 = facenetModel.predict(image1)
    prediction2 = facenetModel.predict(image2)
    dist = np.linalg.norm(prediction1 - prediction2)
    data["distance"] = str(dist)
    return data

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=105)