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
    prediction = facenetModel.predictBase64(base64Str)

    faceExist,bestID = database.compareFaceData(faceFeatures=prediction)

    if faceExist == False:

        id = str(uuid.uuid4())
        database.saveNewFaceID(faceFeatures=prediction,
                               id=id,
                               faceBase64=base64Str)
        resp = {
            "code": 0,
            "message": "Face does not exist",
            "faceExist": False,
            "bestID": id
        }
        return resp

    else:
        userData = database.getUserDataByID(id=bestID)
        if userData == None:
            resp = {
                "code": 0,
                "message": "Face exist but not found ID",
                "faceExist": True,
                "bestID": ""
            }
            return resp
        else:
            resp = {
                "code": 0,
                "faceExist": True,
                "message": "Get data success",
                "bestID": bestID,
                "username": userData.username,
                "phone": userData.phone,
                "faceBase64": userData.base64,
                "state": userData.state
            }
            return resp


@app.route('/updateUser/', methods=['GET', 'POST'])
def updateUser():

    json = request.json
    username = json["username"]
    phone = json["phone"]
    id = json["id"]

    print(json)

    database.updateUserID(name=username,
                          phone=phone,
                          id=id)
    resp = {
        "code": 0,
        "message": "Update success",
    }

    return resp

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=105)