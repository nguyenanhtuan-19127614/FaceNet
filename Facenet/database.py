import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

from enum import Enum
import numpy as np

class UserState(Enum):
    NOINFO = "NOINFO"
    COMPLETED = "COMPLETED"

class UserData:
    def __init__(self, username, phone, base64, state):
        self.username = username
        self.phone = phone
        self.base64 = base64
        self.state = state

class FirebaseDB:

    def __init__(self):
        self.cred = credentials.Certificate('facenetdemo.json')
        self.app = firebase_admin.initialize_app(self.cred)
        self.db = firestore.client()

    def saveNewFaceID(self, faceFeatures, id, faceBase64):

        faceIdDocument = {
            "features": faceFeatures.tolist(),
            "id": id
        }

        userDocument = {
            "id": id,
            "name": "",
            "phone": "",
            "state": UserState.NOINFO.value,
            "faceBase64": faceBase64
        }

        faceid_document = self.db.collection("FaceID").document(str(id))
        user_document = self.db.collection("User").document(str(id))

        faceid_document.set(faceIdDocument)
        user_document.set(userDocument)

    def updateUserID(self, name, phone, id):

        userDocument = {
            "name": name,
            "phone": phone,
            "state": UserState.COMPLETED.value
        }

        user_document = self.db.collection("User").document(str(id))
        user_document.update(userDocument)

    def getUserDataByID(self, id):
        user_ref = self.db.collection("User").where("id", "==", str(id))
        docs = list(user_ref.stream())
        if len(docs) < 1:
            return None
        else:
            doc = docs[0].to_dict()
            userData = UserData(username=doc["name"],
                                phone=doc["phone"],
                                base64=doc["faceBase64"],
                                state= doc["state"])
            return userData

    def getUserData(self):
        user_refs = self.db.collection("User")
        docs = user_refs.stream()

        for doc in docs:
            print(doc.to_dict())

    def getFaceIdData(self):
        user_refs = self.db.collection("FaceID")
        docs = user_refs.stream()
        return docs

    def compareFaceData(self, faceFeatures):

        dbFaceDatas = self.getFaceIdData()

        bestID = ""
        bestDistance = 100.0
        faceExist = False

        for dbFaceData in dbFaceDatas:
            data = dbFaceData.to_dict()

            dataFaceFeats = data["features"]
            dataID = data["id"]
            dataArr = np.asarray(dataFaceFeats)

            distance = np.linalg.norm(faceFeatures-dataArr)
            print(dataID)
            print(distance)
            if distance < 0.6 and distance < bestDistance:
                bestDistance = distance
                faceExist = True
                bestID = dataID

        return (faceExist,bestID)
