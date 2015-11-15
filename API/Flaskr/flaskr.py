#!/usr/bin/python
# all the imports
import sqlite3
from flask import Flask, request, session, g, redirect, url_for, abort, render_template, flash
from contextlib import closing 

# configuration
DATABASE = '/tmp/flaskr.db'
DEBUG = True
SECRET_KEY = 'development key'
USERNAME = 'admin'
PASSWORD = 'default'

# Fuck this hackathon bullshit :)
app = Flask(__name__)
app.config.from_object(__name__)
app.config.from_envvar('FLASKR_SETTINGS', silent=True)
def connect_db():
	return sqlite3.connect(app.config['DATABASE'])
if __name__ =='__main__':
	app.run()
#creating a database
def init_db():
	with closing(connect_db()) as db:
		with app.open_resource('schema.sql' , mode='r') as f:
			db.cursor().executescript(f.read())
		db.commit()
# Requesting Database Connections 
@app.before_request
def before_request():
	g.db = connect_db()
	
@app.teardown_request 
def teardown_request(exeception):
	db = getattr(g, 'db', None)
	if db is not None: 
		db.close()
#show the damn entries
@app.route('/')
def show_entries():
	cur = g.db.execute('select title, text from entries order by id desc')
	entries = [dict(title=row[0], text=row[1]) for row in cur.fetchall()]
	return render_template('show_entries.html', entries=entries)
#Add them shits 
@app.route('/add', methods=['POST'])
def add_entry():
	if not session.get(' logged_in'):
		abort(401)
	g.db.execute('insert into entries(title, text) values (?, ?)',[request.form['text']])
	g.db.commit()
	flash('New entry was successfully posted')
	return redirect(url_for('show_entries'))
#login and logout
@app.route('/login', methods=['GET', 'POST'])
def login():
	error = None 
	if request.method == 'POST':
		if request.form['username'] != app.config['USERNAME']:
			error = 'Invalid username'
		elif request.form['password'] != app.config['PASSWORD']:
			error = 'Invalid password'
		else:
			session['logged_in'] = True 
			flash('You were logged in')
			return redirect(url_for('show_entries'))
	return render_template('login.html', error=error)
@app.route('/logout')
def logout():
	session.pop('logged_in', None)
	flash('You were logged out')
	return redirect(url_for('show_entries'))
#layout.html 
<!doctype html>
<title>Flaskr</title>
<link rel=stylesheet type=text/css href="{{ url_for('static', filename='style.css') }}">
<div class=page>
	<h1>Flaskr</h1>
	<div class=metanav>
	{% if not session.logged_in %}
		<a href="{{ url_for('login') }}">log in</a>
	{% else %}
		<a href="{{ url_for('logout') }}">log out</a>
	{% endif %}
	</div>
	{% for message in get_flashed_messages() %}
		<div class=flash>{{ message }}</div>
	{% endfor %}
	{% block body %}{% endblock %}
</div>
#show_entries.html
{% extneds "layout.html" %}	
{% block body %}
	{% if session.logged_in %}
	<form action="{{ url_for{'add_entry') }}" method=post class=add-entry>
	<dl>
		<dt>Title:
		<dd><input type=text size=30 name=title>
		<dt>Text:
				<dd><textarea name=text rows=5 cols=40></textarea>
				<dd><input type=submit value=Share>
			</dl>
		</form>
	{% endif %}
	<ul class=entries>
	{% for entry in entries %}
		<li><h2>{{ entry.title }}</h2>{{ entry.text|safe }}
	{% else %}
		<li><em>Unbelievable.  No entries here so far</em>
	{% endfor %}
	</ul>
{% endblock %}
#Login.html 
{% extends "layout.html" %}
{% block body %}
	<h2>Login</h2>
	{% if error %}<p class=error><strong>Error:</strong> {{ error }}{% endif %}
	<form action="{{ url_for('login') }}" method=post>
		<dl>
			<dt>Username:
			<dd><input type=text name=username>
			<dt>Password:
			<dd><input type=password name=password>
			<dd><input type=submit value=Login>
		</dl>
	</form>
{% endblock %}	