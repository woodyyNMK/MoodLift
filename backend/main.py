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
import requests

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
            info = auth.get_account_info(user['idToken'])
            # print(info)
            user_doc = db.users.find_one({"_id": user['idToken']})
            # print(user_doc)
            if user_doc:
                db.users.update_one({"_id": user['idToken']}, {"$set": {"password": info['users'][0]['passwordHash']}})

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

@app.route("/resetPassword", methods=['POST'])
def resetPassword():
    email = request.json['email']
    # print(email)
    try:
        user = Auth.get_user_by_email(email)
        # print(user)
        auth.send_password_reset_email(email)
        response = {
            "message": "Password reset email sent"
        }
        return json.dumps(response), 200
    except Auth.UserNotFoundError:
        response = {
            "message": "You need to create account first"
        }
        return json.dumps(response), 404
    except:
        response = {
            "message": "Error sending password reset email"
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
        auth.send_email_verification(user['idToken'])
        info = auth.get_account_info(user['idToken'])
        db.users.insert_one({
            "displayName": name,
            "email": user["email"],
            "_id": user["localId"],
            "password": info['users'][0]['passwordHash'],
            "createdAt": datetime.now()
        })
        response = {
            "message": "Successfully Created Account"
        }
        return json.dumps(response), 200
    except:
        response = {
            "message": "Email already exists"
        }
        return json.dumps(response), 401
    
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
            pos = request.json['positive']
            neg = request.json['negative']
            neutral = request.json['neutral']
            if user:
                diary = {
                    "_id":str(ObjectId()),
                    "text": text,
                    "createdAt": datetime.now(),
                    "positive": pos,
                    "negative": neg,
                    "neutral": neutral,
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
def update_diary():
    auth_header = request.headers.get('Authorization')
    token = auth_header.split(" ")[1] if auth_header else ''

    if not token:
        return json.dumps({"message": "Unauthorized"}), 401

    try:
        decoded_token = Auth.verify_id_token(token)
        uid = decoded_token['uid']

        diary_id = request.args.get('param')
        diary_text = request.json.get('diary')
        positive_score = request.json.get('positive')
        negative_score = request.json.get('negative')
        neutral_score = request.json.get('neutral')

        missing_fields = [
            field for field, value in [
                ("diary ID", diary_id),
                ("diary text", diary_text),
                ("positive value", positive_score),
                ("negative value", negative_score),
                ("neutral value", neutral_score)
            ] if not value
        ]

        if missing_fields:
            return json.dumps({"message": f"Missing {' and '.join(missing_fields)}"}), 400

        user_doc = db.users.find_one({"_id": uid})

        if user_doc and 'diaries' in user_doc and diary_id in user_doc['diaries']:
            update_result = db.diaries.update_one(
                {"_id": diary_id},
                {"$set": {
                    "text": diary_text,
                    "positive": positive_score,
                    "negative": negative_score,
                    "neutral": neutral_score
                }}
            )
            if update_result.modified_count == 1:
                return json.dumps({"message": "Diary updated successfully"}), 200
            else:
                return json.dumps({"message": "Diary update failed"}), 500
        else:
            return json.dumps({"message": "Diary ID not found in user's diary array or User not found"}), 404

    except Exception as e:
        return json.dumps({"message": "Error updating diary", "error": str(e)}), 500


@app.route("/deleteDiary", methods=['DELETE'])
def deleteDiary():
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

        try:
            user_doc = db.users.find_one({"_id": uid})
            # print(f"User document: {user_doc}")

            if user_doc:
                if 'diaries' in user_doc and id in user_doc['diaries']:
                    db.diaries.delete_one(
                        {"_id": id},
                    )
                    return json.dumps({"message": "Diary deleted successfully"}), 200
                else:
                    response = {
                        "message": "Diary ID not found in user's diary array"
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
            "message": "Error deleting diary",
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
            # print(selectedDateTime)
            date = datetime.strptime(selectedDateTime, "%Y-%m-%d %H:%M:%S.%fZ")
            # print(date)
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
    

@app.route("/showArticles", methods=['GET'])
def showArticles():
    
    auth_header = request.headers.get('Authorization')
    if auth_header:
        token = auth_header.split(" ")[1]
    else:
        token = ''
    if token != '':
        decoded_token = Auth.verify_id_token(token)
        uid = decoded_token['uid']
        try:
            # Fetch the user document from the users collection
            user = db.users.find_one({"_id": uid})
            if user:
                # Fetch the diaries for the given date
                articles = db.articles.find()
                # Convert the diaries to a list and return them in the response
                article_list = list(articles)
                # print(article_list)
                response = {
                    "articles": article_list,
                    "message": "Articles fetched successfully",
                }
                return json.dumps(response, default=json_util.default), 200
            else:
                response = {
                    "message": "User not found"
                }
                return json.dumps(response), 401
        except:
            response = {
                "message": "Error fetching Articles"
            }
            return json.dumps(response), 401
    else:
        response = {
            "message": "Unauthorized"
        }
        return json.dumps(response), 401 

@app.route("/showSummary", methods=['GET'])
def showSummary():
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

            date = datetime.strptime(selectedDateTime, "%Y-%m-%d %H:%M:%S.%f")

            # Fetch the user document from the users collection
            user = db.users.find_one({"_id": uid})

            # Define the start and end dates
            start_date = datetime(date.year, date.month, 1)
            if date.month == 12:
                end_date = datetime(date.year + 1, 1, 1)
            else:
                end_date = datetime(date.year, date.month + 1, 1)

            if user and 'diaries' in user:
                # Fetch the diaries for the given date
                pipeline = [
                    {"$match": {
                        "_id": {"$in": user['diaries']},
                        "createdAt": {
                            "$gte": start_date,
                            "$lt": end_date
                        }
                    }},
                    {"$group": {
                        "_id": None,
                        "totalPositive": {"$sum": "$positive"},
                        "totalNegative": {"$sum": "$negative"},
                        "totalNeutral": {"$sum": "$neutral"},
                        "count": {"$sum": 1}
                    }},
                    {"$project": {
                        "averagePositive": {"$divide": ["$totalPositive", "$count"]},
                        "averageNegative": {"$divide": ["$totalNegative", "$count"]},
                        "averageNeutral": {"$divide": ["$totalNeutral", "$count"]}
                    }}
                ]
                result = db.diaries.aggregate(pipeline)
                averages = list(result)
                if averages:
                    response = {
                    "message": "Here's the summary for selected month",
                    "averagePositive": averages[0]['averagePositive'],
                    "averageNegative": averages[0]['averageNegative'],
                    "averageNeutral": averages[0]['averageNeutral']
                }

                return json.dumps(response), 200
        except:
            response = {
                "message": "No diaries for selected Month"
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
print(user)
# print(user['idToken'])
info = auth.get_account_info(user['idToken'])
print(info)
'''
