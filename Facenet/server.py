from flask import Flask
from flask import request, json
from database import FirebaseDB
from model_handler.modelHandler import FacenetModel
from keras.preprocessing.image import load_img
import uuid


facenetModel = FacenetModel()
app = Flask(__name__)
database = FirebaseDB()

@app.route('/faceAuth/', methods=['POST'])
def faceAuth():

    json = request.json
    base64Str = json["base64"]
    print(base64Str)
    prediction = facenetModel.predictBase64(base64Str)

    faceExist,bestID = database.compareFaceData(faceFeatures=prediction)

    resp = {
        "code": 0,
        "faceExist": faceExist,
        "bestID": bestID,
    }

    return resp

@app.route('/updateUser/', methods=['GET', 'POST'])
def updateUser():
    resp = {"success": True}

    return resp

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=105)