# all the imports
import sqlite3
from flask import Flask, request, session, g, redirect, url_for, \
     abort, render_template, flash
from contextlib import closing
from flask_bootstrap import Bootstrap
import hashlib

# configuration
# the database is not in tmp on the deployed verson 
DATABASE = '/minecraft.db'
DEBUG = True
SECRET_KEY = 'development key'
USERNAME = 'admin'
PASSWORD = 'default'


# create our little application :)
app = Flask(__name__)
app.config.from_object(__name__)
Bootstrap(app)

def connect_db():
    return sqlite3.connect(app.config['DATABASE'])

def init_db():
    with closing(connect_db()) as db:
        with app.open_resource('schema.sql', mode='r') as f:
            db.cursor().executescript(f.read())
        db.commit()

def runScript(scriptName):
    with closing(connect_db()) as db:
        with app.open_resource('scripts/' + scriptName, mode='r') as f:
            db.cursor().executescript(f.read())
        db.commit()


@app.before_request
def before_request():
    g.db = connect_db()

@app.teardown_request
def teardown_request(exception):
    db = getattr(g, 'db', None)
    if db is not None:
        db.close()

#Load the homepage where the announcements are displayed
@app.route('/')
def home():
    cur = g.db.execute('SELECT announcement, details, id, user, Timestamp FROM announcements ORDER BY id DESC LIMIT 5')
    entries = [dict(announcement=row[0], details=row[1],  key=row[2], user = row[3], timestamp = row[4]) for row in cur.fetchall()]
    return render_template('home.html', entries=entries)

#Add an announcement to the homepage
@app.route('/add_announcement', methods=['POST'])
def add_announcement():
    if not session.get('logged_in'):
        abort(401)
    g.db.execute('INSERT INTO announcements (announcement, details,user) VALUES (?, ?,?)',
                 [request.form['announcement'], request.form['details'], request.form['user']])
    g.db.commit()
    flash('New entry was successfully posted')
    return redirect(url_for('home'))


#login and set the session name
@app.route('/login', methods=['GET', 'POST'])
def login():
    error = None
    if request.method == 'POST':
	cur = g.db.execute('select username, pass from users where username = ?',[request.form['username']])
    	entries = [dict(username=row[0], password=row[1]) for row in cur.fetchall()]
        m = hashlib.md5()
	m.update(request.form['password'])
	print request.form['password']
	checkHash = m.hexdigest()

	if not entries:
		error = 'Invalid Username or Password'
	elif checkHash != entries[0]['password']:
		error = 'Invalid Username or Password'
	else:
		session['logged_in'] = True
		session['user'] = entries[0]['username']
        	return redirect(url_for('home'))
    return render_template('login.html', error=error)

#log out: update the session
@app.route('/logout')
def logout():
    session.pop('logged_in', None)
    flash('You were logged out')
    return redirect(url_for('show_entries'))


if __name__ == '__main__':
    app.run()



