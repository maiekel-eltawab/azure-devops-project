import os

from flask import Flask
import psycopg2

app = Flask(__name__)


def get_db_connection():
    return psycopg2.connect(
        host=os.environ["DB_HOST"],
        database=os.environ["DB_NAME"],
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
        port=5432
    )


@app.route("/")
def home():
    return {
        "message": "DevOps Project API",
        "status": "running"
    }


@app.route("/health")
def health():
    return {
        "status": "healthy"
    }


@app.route("/db-health")
def db_health():
    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        cursor.execute("SELECT 1;")
        result = cursor.fetchone()

        cursor.close()
        connection.close()

        return {
            "database": "connected",
            "result": result[0]
        }

    except Exception as error:
        return {
            "database": "error",
            "message": str(error)
        }, 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
