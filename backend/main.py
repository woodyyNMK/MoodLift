from flask import Flask
from flask_pymongo import PyMongo
from pymongo import MongoClient
from pymongo.server_api import ServerApi
import pyrebase

app = Flask(__name__)
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


email = input("Enter email: ")
password = input("Enter password: ")
# user = auth.create_user_with_email_and_password(email, password)
user = auth.sign_in_with_email_and_password(email, password)
# print(user)
print(user['idToken'])
info = auth.get_account_info(user['idToken'])
print(info)

@app.route("/")
def home_page():
    movie = db.movies.find_one()
    return movie["title"]