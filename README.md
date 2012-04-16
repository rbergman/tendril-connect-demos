# Installation

First clone the repo:

	git clone git@github.com:rbergman/tendril-connect-demos.git

Then, with [Node.js](http://nodejs.org) v0.6.x:

	cd tendril-connect-demos
	npm install -g coffee # if not already installed
	npm install

At [Tendril's developer site](https://dev.tendrilinc.com), create an app to acquire an OAuth2 app id and key.  Then:

	cp config/oauth.coffee.sample config/oauth.coffee

Edit oauth.coffee to add your app id and secret.  Then, you should be ready to start the server like so:

	./server

Or:

	coffee ./app/server.coffee

# About

This is sample [Node.js](http://nodejs.org) application for demoing interactions with the Tendril Connect REST APIs, while exploring development of a Node.js client SDK for the same APIs.  It is very much an early work in progress!
