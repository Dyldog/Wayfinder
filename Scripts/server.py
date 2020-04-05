from flask import Flask
from flask import request
from flask import jsonify

import subprocess

import base64 
import os

import datetime

import os.path
from os import path

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

	log_folder = "Single_Apps/" + app_name + "Finder/logs/"
	runCommnad("mkdir -p " + log_folder)
	log_file = log_folder + datetime.datetime.now().isoformat().replace("/", "") + ".txt"
	runCommnad("touch " +log_file)
	
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

	make_assets_command = "Scripts/make_assets.sh -in /tmp/finder_image.png -name " + app_name + " -toolbar " + toolbar + " -background " + background + " -h1 " + h1 + " -h2 " + h2 + " -out ./Single_Apps >> " + log_file
	
	runCommnad(make_assets_command)
	runCommnad("Scripts/make_app_target.sh -name " + app_name + " -type " + place_type + " -out ./Single_Apps >> " + log_file)
	runCommnad("tuist generate --project-only >> " + log_file)
	runCommnadAsync("fastlane release subject:" + app_name + ">> " + log_file)
	
	return "\n".join([app_name, place_type, toolbar, background, h1, h2])

@app.route('/apps', methods=['GET'])
def apps():
	with open('Single_Apps/PROJECTS', 'r') as f:
	    projects = f.readlines()
	def makeResponse(line):
		comps = line.rstrip().split("~")
		return {
			"name": comps[0] + "Finder",
			"subject": comps[1]
		}

	project_names = map(makeResponse, projects)
	return jsonify(list(project_names))

@app.route('/logs/<name>', methods=['GET'])
def logs(name):
	if path.exists("Single_Apps/" + name) == False:
		return "App name " + name + "does not exist", 404

	log_dir = "Single_Apps/" + name + "/logs"
	if path.exists(log_dir) == False:
		return jsonify([])

	def makeResponse(logname):
		return {"name": logname}
	
	return jsonify(list(map(makeResponse, [name for name in os.listdir(log_dir)])))

@app.route('/log/<app>/<file>', methods=['GET'])
def log(app, file):
	file_path = "Single_Apps/" + app + "/logs/" + file
	if path.exists(file_path) == False:
		return "App name " + name + "does not exist", 404

	with open(file_path, 'r') as f:
	    log_text = "\n".join(f.readlines())

	return log_text

if __name__ == '__main__':
    app.run(host = '0.0.0.0', debug=True, port=5000) #run app in debug mode on port 5000