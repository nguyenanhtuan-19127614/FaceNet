import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from enum import Enum
import numpy as np

class UserState(Enum):
    NODATA = "NoData"
    COMPLETED = "COMPLETED"

class FirebaseDB:

    def __init__(self):
        self.cred = credentials.Certificate('facenetdemo.json')
        self.app = firebase_admin.initialize_app(self.cred)
        self.db = firestore.client()

    def saveNewFaceID(self, faceFeatures, id):

        faceIdDocument = {
            "features": faceFeatures,
            "id": id
        }

        userDocument = {
            "id": id,
            "name": "",
            "phone": "",
            "state": UserState.NODATA.value
        }

        faceid_document = self.db.collection("FaceID").document(str(id))
        user_document = self.db.collection("User").document(str(id))

        faceid_document.set(faceIdDocument)
        user_document.set(userDocument)

    def updateUserID(self, name, phone, id):

        userDocument = {
            "id": id,
            "name": name,
            "phone": phone,
            "state": UserState.COMPLETED.value
        }

        user_document = self.db.collection("User").document(str(id))
        user_document.update(userDocument)

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
            if distance < 0.4 and distance < bestDistance:
                bestDistance = distance
                faceExist = True
                bestID = dataID

        return (faceExist,bestID)