#!/usr/bin/env python

from flask import Flask
from datetime import datetime


app = Flask(__name__)
app.debug = True



@app.route('/')
def home():
    return 'Striplight'


@app.route('/getTime')
def getTime():
    actual_time = datetime.now().time()
    return str(actual_time)


if __name__ == '__main__':
    app.run(host='0.0.0.0')
