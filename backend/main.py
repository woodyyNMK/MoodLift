import datetime
from flask import Flask, jsonify, request, session
from flask_pymongo import PyMongo
from pymongo import MongoClient
from pymongo.server_api import ServerApi
import pyrebase
from flask_cors import CORS, cross_origin
from Crypto.Cipher import AES
from Crypto.Util.Padding import unpad
import base64
import json

app = Flask(__name__)
cors = CORS(app)

app.config.from_pyfile('settings.py')
cluster = MongoClient(app.config["MONGO_URI"], server_api=ServerApi('1'))
db = cluster["mood_lift"]
ENCRYPTION_KEY = app.config["ENCRYPTION_KEY"].encode('utf-8')
ivlength = 16

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
app.secret_key = app.config["APPSECRETKEY"]

@app.route("/test")
def home_page():
    movie = db.movies.find_one()
    return movie["title"]

@app.route("/login", methods=['POST','GET' ])
def login():   
    if 'user' in session:
        return "You are logged in as " + session['user']
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

        # key = ENCRYPTION_KEY.encode('utf-8')  # convert string to bytes

        # Create AES cipher object for decryption
        cipher = AES.new(ENCRYPTION_KEY, AES.MODE_CBC, iv)
        
        # Decrypt and unpad the password
        decryptedpassword = unpad(cipher.decrypt(encrypted_password), AES.block_size).decode('utf-8')
        print(f'Decrypted Password: {decryptedpassword}')
        
        try:
            user = auth.sign_in_with_email_and_password(email, decryptedpassword)
            session['user'] = user['email']
            session["is_logged_in"] = True
            session["email"] = user["email"]
            session["uid"] = user["localId"]
            response = {
                "idToken": user['idToken'],
                "message": "Successfully logged in"
            }
            return json.dumps(response), 200
        except:
            response = {
                "message": "Invalid Credentials"
            }
            return json.dump(response), 401 
        
@app.route("/logout")
def logout():
    session.pop('user', None)
    response = {
        "message": "Successfully logged out"
    }
    return json.dumps(response), 200

@app.route("/register", methods=['POST'])
def register():
    name = request.json['name']
    email = request.json['email']
    password = request.json['password']
    try:
        user = auth.create_user_with_email_and_password(email, password)
        db.users.insert_one({
            "displayName": name,
            "email": user["email"],
            "_id": user["localId"],
            "password": user["passwordHash"],
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
    if 'user' in session:
        text = request.json['text']
        try:
            user = db.users.find_one({"_id": session["uid"]})
            if user:
                diary = {
                    "text": text,
                    "createdAt": datetime.datetime.now(),
                    "positive": 0,
                    "negative": 0,
                }
                db.diaries.insert_one(diary)
                db.users.update_one({"_id": session["uid"]}, {"$push": {"diaries": diary["_id"]}})
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