from flask import Flask
from flask import request
import subprocess

import base64 
import os

def runCommnad(command):
	print(command)
	p = subprocess.call(command, shell=True)

def runCommnadAsync(command):
	print(command)
	p = subprocess.Popen(command, shell=True)

app = Flask(__name__)

@app.route('/create', methods=['POST'])
def create():
	req_data = request.get_json()

	app_name = req_data["title"]
	
	imageBase64 = req_data["image"]

	imgdata = base64.b64decode(imageBase64)
	with open('/tmp/finder_image.png', 'wb') as f:
	    f.write(imgdata)
	
	place_type = req_data["placeType"]
	colors = req_data["colors"]

	toolbar = colors["toolbar"]
	background = colors["background"]
	h1 = colors["h1"]
	h2 = colors["h2"]

	make_assets_command = "Scripts/make_assets.sh -in /tmp/finder_image.png -name " + app_name + " -toolbar " + toolbar + " -background " + background + " -h1 " + h1 + " -h2 " + h2 + " -out ./Single_Apps"
	
	runCommnad(make_assets_command)
	runCommnad("Scripts/make_app_target.sh -name " + app_name + " -type " + place_type + " -out ./Single_Apps")
	runCommnad("tuist generate --project-only")
	runCommnadAsync("fastlane release subject:" + app_name)
	
	return "\n".join([app_name, place_type, toolbar, background, h1, h2])

if __name__ == '__main__':
    app.run(host = '0.0.0.0', debug=True, port=5000) #run app in debug mode on port 5000