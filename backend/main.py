from flask import Flask, request, session
from flask_pymongo import PyMongo
from pymongo import MongoClient
from pymongo.server_api import ServerApi
import pyrebase
from flask_cors import CORS, cross_origin
import json

app = Flask(__name__)
cors = CORS(app)
app.config.from_pyfile('settings.py')
client = MongoClient(app.config["MONGO_URI"], server_api=ServerApi('1'))
db = client["sample_mflix"]

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
                "idToken": user['idToken']
            }
            return json.dumps(response), 200
        except:
            return json.dumps("Invalid credentials"), 401
        
@app.route("/logout")
def logout():
    session.pop('user', None)
    return "Successfully Logged Out", 200

@app.route("/register", methods=['POST'])
def register():
    email = request.form['email']
    password = request.form['password']
    try:
        user = auth.create_user_with_email_and_password(email, password)
        return "Successfully Created", 200
    except:
        return "Email already exists", 401