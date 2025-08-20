import os, json
from flask import Flask, jsonify
import psycopg

app = Flask(__name__)

DB_HOST=os.getenv("DB_HOST","localhost")
DB_PORT=int(os.getenv("DB_PORT","5432"))
DB_USER=os.getenv("DB_USER","appuser")
DB_PASSWORD=os.getenv("DB_PASSWORD","password")
DB_NAME=os.getenv("DB_NAME","postgres")

@app.get("/health")
def health():
    return jsonify(status="ok")

@app.get("/db-check")
def db_check():
    try:
        with psycopg.connect(host=DB_HOST, port=DB_PORT, user=DB_USER, password=DB_PASSWORD, dbname="postgres", connect_timeout=3) as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT 1;")
                return jsonify(db="reachable")
    except Exception as e:
        return jsonify(error=str(e)), 500

@app.get("/")
def root():
    return jsonify(message="Backend root")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
