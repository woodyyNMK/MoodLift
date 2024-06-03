import datetime
from flask import Flask, request, session
from flask_pymongo import PyMongo
from pymongo import MongoClient
from pymongo.server_api import ServerApi
import pyrebase
from flask_cors import CORS, cross_origin
import json

app = Flask(__name__)
CORS(app)
app.config.from_pyfile('settings.py')
cluster = MongoClient(app.config["MONGO_URI"], server_api=ServerApi('1'))
db = cluster["mood_lift"]

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

@app.route("/test")
def home_page():
    movie = db.movies.find_one()
    return movie["title"]

@app.route("/login", methods=['POST','GET' ])
def login():   
    if 'user' in session:
        return "You are logged in as " + session['user']
    if request.method == 'POST':
        email = request.json['email']
        password = request.json['password']

        try:
            user = auth.sign_in_with_email_and_password(email, password)
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
            "email": email,
            "_id": user["localId"],
            "password": password,
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