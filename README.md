# About

This is a sample [Node.js](http://nodejs.org) application for demoing interactions with the [Tendril Connect HTTP APIs](https://dev.tendrilinc.com/docs).  It is a work in progress, so many areas are incomplete or less functional than might otherwise be desired.

For the lazy, you may be able to find the app running [here](http://freezing-robot-5534.herokuapp.com).

# Installation

First clone the repo:

	git clone git@github.com:TendrilDevProgram/tendril-connect-demos.git

Then, with [Node.js](http://nodejs.org) v0.6.x:

	cd tendril-connect-demos
	npm install -g coffee # if not already installed
	npm install

Next:

	cp config/env.coffee.sample config/env.coffee

Edit env.coffee to configure a custom session secret for your app.  This can be any secret pass phrase you deem appropriate.

Then at [Tendril's developer site](https://dev.tendrilinc.com), create an app to acquire an OAuth2 app id and key.  Further edit env.coffee to add your app id and secret.  At this point you should be ready to start the server like so:

	./server [server port]

Or:

	coffee ./app/server.coffee [server port]

The server will start on port 3001, unless you optionally specify your own port in the commands above.
