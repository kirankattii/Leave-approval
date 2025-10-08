from pymongo import MongoClient
from pymongo.collection import Collection
from bson import ObjectId
import os
from dotenv import load_dotenv
from pymongo import ASCENDING
from pymongo.errors import PyMongoError

load_dotenv()

MONGODB_URI = os.getenv("MONGODB_URI")

if not MONGODB_URI:
    raise ValueError("MONGODB_URI environment variable is not set!")

try:
    client = MongoClient(
        MONGODB_URI,
        serverSelectionTimeoutMS=5000,  # 5 second timeout
        connectTimeoutMS=10000,
        socketTimeoutMS=10000,
    )
    # Test connection
    client.admin.command('ping')
    db = client.get_default_database()
    print("✅ MongoDB connected successfully!")
except Exception as e:
    print(f"❌ MongoDB connection failed: {str(e)}")
    raise

users_collection: Collection = db["users"]
leaves_collection: Collection = db["leave_requests"]
tokens_collection: Collection = db["approval_tokens"]
password_resets_collection: Collection = db["password_resets"]

# Ensure unique indexes for users
try:
    users_collection.create_index([("email", ASCENDING)], unique=True, name="unique_email")
    users_collection.create_index([("username", ASCENDING)], unique=True, name="unique_username")
    # Optional TTL index could be added; for now we keep manual expiry checks
    password_resets_collection.create_index([("email", ASCENDING)], name="reset_email_idx")
except PyMongoError as e:
    # Index creation failures should not crash app startup; they will be logged by the server
    print(f"Index creation warning: {str(e)}")
