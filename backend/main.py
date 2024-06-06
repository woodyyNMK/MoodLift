import datetime
from bson import ObjectId, json_util
from flask import Flask, jsonify, request
from flask_pymongo import PyMongo
from pymongo import MongoClient
from pymongo.server_api import ServerApi
import pyrebase
from flask_cors import CORS
from Crypto.Cipher import AES
from Crypto.Util.Padding import unpad
import base64
import json
import firebase_admin
from firebase_admin import auth as Auth, credentials
from datetime import datetime
app = Flask(__name__)
cors = CORS(app)

app.config.from_pyfile('settings.py')
cluster = MongoClient(app.config["MONGO_URI"], server_api=ServerApi('1'))
db = cluster["mood_lift"]
ENCRYPTION_KEY = app.config["ENCRYPTION_KEY"].encode('utf-8')
ivlength = 16

# Load the service account key JSON file.
cred = credentials.Certificate('./moodlift_firebase_service_account.json')
# Initialize the app with a service account, granting admin privileges
firebase_admin.initialize_app(cred)

# Initialize Firebase
firebaseconfig = {
    "apiKey": app.config["APIKEY"],
    "authDomain": app.config["AUTHDOMAIN"],
    "databaseURL": "",
    "storageBucket": app.config["STORAGEBUCKET"],
    "projectId": app.config["PROJECTID"],
    "messagingSenderId": app.config["MESSAGINGSENDERID"],
    "appId": app.config["APPID"],    
}
# Initialize Firebase
firebase = pyrebase.initialize_app(firebaseconfig)
# Get reference to the auth service and database service
auth = firebase.auth()


@app.route("/test")
def home_page():
    movie = db.movies.find_one()
    return movie["title"]

@app.route("/login", methods=['POST', 'GET'])
def login():
    if request.method == 'POST':
        # Get JSON data from the request
        email = request.json['email']
        encryptedpasswordb64 = request.json['password']
        ivb64 = request.json['iv']
        
        if not encryptedpasswordb64 or not ivb64:
            return jsonify({'error': 'Missing data'}), 400
        
        # Decode the base64 encoded values
        encrypted_password = base64.b64decode(encryptedpasswordb64)
        iv = base64.b64decode(ivb64)

        # Create AES cipher object for decryption
        cipher = AES.new(ENCRYPTION_KEY, AES.MODE_CBC, iv)
        
        # Decrypt and unpad the password
        decryptedpassword = unpad(cipher.decrypt(encrypted_password), AES.block_size).decode('utf-8')
        # print(f'Decrypted Password: {decryptedpassword}')
        
        try:
            user = auth.sign_in_with_email_and_password(email, decryptedpassword)
            # info = auth.get_account_info(user['idToken'])

            response = {
                "idToken": user['idToken'],
                "refreshToken": user['refreshToken'],
                "expiresIn": user['expiresIn'],
                "message": "Successfully logged in"
            }
            return json.dumps(response), 200
        except:
            response = {
                "message": "Invalid Credentials"
            }
            return json.dumps(response), 401 

@app.route("/register", methods=['POST'])
def register():
    name = request.json['name']
    email = request.json['email']
    encryptedpasswordb64 = request.json['password']
    ivb64 = request.json['iv']
    
    if not encryptedpasswordb64 or not ivb64:
        return jsonify({'error': 'Missing data'}), 400

    # Decode the base64 encoded values
    encrypted_password = base64.b64decode(encryptedpasswordb64)
    iv = base64.b64decode(ivb64)

    # Create AES cipher object for decryption
    cipher = AES.new(ENCRYPTION_KEY, AES.MODE_CBC, iv)

    # Decrypt and unpad the password
    decryptedpassword = unpad(cipher.decrypt(encrypted_password), AES.block_size).decode('utf-8')
    # print(f'Decrypted Password: {decryptedpassword}')
    try:
        user = auth.create_user_with_email_and_password(email, decryptedpassword)
        info = auth.get_account_info(user['idToken'])
        db.users.insert_one({
            "displayName": name,
            "email": user["email"],
            "_id": user["localId"],
            "password": info['users'][0]['passwordHash'],
            "createdAt": datetime.datetime.now()
        })
        response = {
            "message": "Successfully logged in"
        }
        return json.dumps(response), 200
    except:
        response = {
            "message": "Email already exists"
        }
        return json.dump(response), 401
    
@app.route("/createDiary", methods=['POST'])
def createDiray():
    auth_header = request.headers.get('Authorization')
    if auth_header:
        token = auth_header.split(" ")[1]
    else:
        token = ''
    if token != '':
        decoded_token = Auth.verify_id_token(token)
        uid = decoded_token['uid']
        try:
            user = db.users.find_one({"_id": uid})
            text = request.json['diary']
            if user:
                diary = {
                    "_id":str(ObjectId()),
                    "text": text,
                    "createdAt": datetime.now(),
                    "positive": 0,
                    "negative": 0,
                }
                # print(diary)
                db.diaries.insert_one(diary)
                db.users.update_one({"_id": uid}, {"$push": {"diaries": diary["_id"]}})
                response = {
                    "message": "Diary created successfully"
                }
                return json.dumps(response), 200
            else:
                response = {
                    "message": "User not found"
                }
                return json.dumps(response), 401
        except:
            response = {
                "message": "Error creating diary"
            }
            return json.dumps(response), 401
    else:
        response = {
            "message": "Unauthorized"
        }
        return json.dumps(response), 401
  
@app.route("/updateDiary", methods=['PUT'])
def updateDiary():
    auth_header = request.headers.get('Authorization')
    if auth_header:
        token = auth_header.split(" ")[1]
    else:
        token = ''

    if token == '':
        response = {
            "message": "Unauthorized"
        }
        return json.dumps(response), 401

    try:
        decoded_token = Auth.verify_id_token(token)
        uid = decoded_token['uid']
        # print(f"Decoded UID: {uid}")

        id = request.args.get('param')
        if not id:
            response = {
                "message": "Missing diary ID"
            }
            return json.dumps(response), 400
        # print(f"Diary ID: {id}")
        text = request.json.get('diary')
        if not text:
            response = {
                "message": "Missing diary text"
            }
            return json.dumps(response), 400

        try:
            user_doc = db.users.find_one({"_id": uid})
            # print(f"User document: {user_doc}")

            if user_doc:
                if 'diaries' in user_doc and id in user_doc['diaries']:
                    db.diaries.update_one(
                        {"_id": id},
                        {"$set": {"text": text}}
                    )
                    return json.dumps({"message": "Diary updated successfully"}), 200
                else:
                    response = {
                        "message": "Diary ID not found in user's diary array"
                    }
                    return json.dumps(response), 404
            else:
                response = {
                    "message": "User not found"
                }
                return json.dumps(response), 404

        except Exception as db_error:
            # print(f"Database error: {db_error}")
            response = {
                "message": "Error accessing user document",
                "error": str(db_error)
            }
            return json.dumps(response), 500

    except Exception as e:
        # print(f"Error: {e}")
        response = {
            "message": "Error updating diary",
            "error": str(e)
        }
        return json.dumps(response), 500
  
@app.route("/showDiaries", methods=['GET'])
def showDiaries():
    
    auth_header = request.headers.get('Authorization')
    if auth_header:
        token = auth_header.split(" ")[1]
    else:
        token = ''
    if token != '':
        decoded_token = Auth.verify_id_token(token)
        uid = decoded_token['uid']
        try:
            # Get the date parameter from the query string and convert it to a datetime object
            selectedDateTime = request.args.get('param')
            date = datetime.strptime(selectedDateTime, "%Y-%m-%d %H:%M:%S.%fZ")
            # Fetch the user document from the users collection
            user = db.users.find_one({"_id": uid})
            if user and 'diaries' in user:
                # Fetch the diaries for the given date
                diaries = db.diaries.find({
                    "_id": {"$in": user['diaries']},
                    "createdAt": {
                        "$gte": datetime(date.year, date.month, date.day, 0, 0, 0),
                        "$lt": datetime(date.year, date.month, date.day, 23, 59, 59)
                    }
                })
                # Convert the diaries to a list and return them in the response
                diaries_list = list(diaries)
                # print(diaries_list)
                response = {
                    "diaries": diaries_list,
                    "message": "Diaries fetched successfully",
                }
                return json.dumps(response, default=json_util.default), 200
            else:
                response = {
                    "message": "User not found or no diaries for the user"
                }
                return json.dumps(response), 401
        except:
            response = {
                "message": "Error fetching diaries"
            }
            return json.dumps(response), 401
    else:
        response = {
            "message": "Unauthorized"
        }
        return json.dumps(response), 401 
'''
email = input("Enter email: ")
password = input("Enter password: ")
# user = auth.create_user_with_email_and_password(email, password)
user = auth.sign_in_with_email_and_password(email, password)
# print(user)
print(user['idToken'])
info = auth.get_account_info(user['idToken'])
print(info)
'''