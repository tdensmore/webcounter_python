import time
import redis
import sqlite3
from flask import Flask, render_template, request, url_for, flash, redirect

app = Flask(__name__)

app.config['SECRET_KEY'] = 'secret_key_value'

# Redis
cache = redis.Redis(host='database-redis', port=6379)

# Get SQLite database connection
def get_db_connection():
    conn = sqlite3.connect('database.db')
    conn.row_factory = sqlite3.Row
    #print "Opened database successfully"
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
    #return 'I have been hit %i times since deployment.\n' % int(count)
    # return render_template('index.html')
    conn = get_db_connection()
    posts = conn.execute('SELECT * FROM posts').fetchall()
    conn.close()
    return render_template('index.html', posts=posts, hit_count=hit_count)
    #return render_template('index.html', posts=posts, hit_count=444)

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


