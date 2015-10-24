#!/usr/bin/env python

from flask import Flask
import datetime


app = Flask(__name__)


@app.route('/')
def home():
    return 'Striplight'


@app.route('/getTime')
def getTime():
    time = datetime.datetime.now().time()
    return time


if __name__ == '__main__':
    app.run(hosts='0.0.0.0')
