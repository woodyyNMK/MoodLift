from flask import Flask
from flask_pymongo import PyMongo
from pymongo import MongoClient
from pymongo.server_api import ServerApi

app = Flask(__name__)
app.config.from_pyfile('settings.py')
client = MongoClient(app.config["MONGO_URI"], server_api=ServerApi('1'))
db = client["sample_mflix"]

@app.route("/")
def home_page():
    movie = db.movies.find_one()
    return movie["title"]