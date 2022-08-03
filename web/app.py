import time
import redis
import sqlite3
import logging

from minio import Minio
from minio.error import S3Error

# import psycopg2
# from psycopg2.extras import LoggingConnection
from flask import Flask, render_template, request, url_for, flash, redirect

app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret_key_value'

# Redis
cache = redis.Redis(host='database-redis', port=6379)

# Logger
logging.basicConfig(filename="./webapp.logs", level=logging.DEBUG, filemode='a')
logger = logging.getLogger('webapp')


def backup_to_s3():
    # Create a client with the MinIO server playground, its access key
    # and secret key.
    client = Minio(
        "play.min.io",
        access_key="Q3AM3UQ867SPQQA43P2F",
        secret_key="zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG",
    )

    # Make 'asiatrip' bucket if not exist.
    found = client.bucket_exists("weblogzbackup")
    if not found:
        client.make_bucket("weblogzbackup")
    else:
        print("Bucket 'weblogzbackup' already exists")

    # Upload '/usr/src/app/webapp.logs' as object name
    # 'webapp.logs' to bucket 'weblogzbackup'.
    client.fput_object(
        "weblogzbackup", "webapp.logs", "./webapp.logs",
    )
    print("successfully uploaded ")

# Get SQLite database connection
def get_db_connection():

    # SQLite
    conn = sqlite3.connect('database.db')
    conn.row_factory = sqlite3.Row
    #print "Opened database successfully"

    # db_settings = {
    #     "user": "postgres",
    #     "password": "password",
    #     "host": "127.0.0.1",
    #     "database": "testdb",
    # }
    # # connect to the PostgreSQL server
    # conn = psycopg2.connect(connection_factory=LoggingConnection, **db_settings)
    # conn.initialize(logger)

    return conn

def get_hit_count():
    retries = 5
    while True:
        try:
            return cache.incr('hits')
        except redis.exceptions.ConnectionError as exc:
            if retries == 0:
                raise exc
            retries -= 1
            time.sleep(0.5)

@app.route('/')
def index():
    hit_count = get_hit_count()
    if (hit_count % 25) == 0:
        logging.debug('Uploading the logs to S3.')
        backup_to_s3()

    conn = get_db_connection()
    posts = conn.execute('SELECT * FROM posts').fetchall()
    conn.close()
    logging.debug('Current page hits: %s', hit_count )
    return render_template('index.html', posts=posts, hit_count=hit_count)

@app.route('/create/', methods=('GET', 'POST'))
def create():
    if request.method == 'POST':
        title = request.form['title']
        content = request.form['content']

        if not title:
            flash('Title is required!')
        elif not content:
            flash('Content is required!')
        else:
            conn = get_db_connection()
            conn.execute('INSERT INTO posts (title, content) VALUES (?, ?)',
                         (title, content))
            conn.commit()
            conn.close()
            return redirect(url_for('index'))

    return render_template('create.html')


if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)


