# About

This is sample [Node.js](http://nodejs.org) application for demoing interactions with the [Tendril Connect HTTP APIs](https://dev.tendrilinc.com/docs), while exploring development of a Node.js client SDK for the same APIs.  It is a work in progress!

# Installation

First clone the repo:

	git clone git@github.com:rbergman/tendril-connect-demos.git

Then, with [Node.js](http://nodejs.org) v0.6.x:

	cd tendril-connect-demos
	npm install -g coffee # if not already installed
	npm install

Next:

	cp config/env.coffee.sample config/env.coffee

Edit env.coffee to configure a custom session secret for your app.  This can be any secret pass phrase you deem appropriate.

Then at [Tendril's developer site](https://dev.tendrilinc.com), create an app to acquire an OAuth2 app id and key.  Further edit oauth.coffee to add your app id and secret.  At this point you should be ready to start the server like so:

	./server [server port]

Or:

	coffee ./app/server.coffee [server port]

The server will start on port 3001, unless you optionally specify your own port in the commands above.
