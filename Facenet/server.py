from flask import Flask
from flask import request
# from pymongo import MongoClient
from model_handler.modelHandler import FacenetModel
from keras.preprocessing.image import load_img
import numpy as np


facenetModel = FacenetModel()
app = Flask(__name__)
# client = MongoClient(host='0.0.0.0', port=105)

@app.route('/hello/', methods=['GET', 'POST'])
def welcome():

    args = request.args
    base64Str = args["base64"]
    print(base64Str)
    prediction = facenetModel.predictBase64(base64Str)
    print(prediction)

    resp = {"success": True}

    return resp

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=105)