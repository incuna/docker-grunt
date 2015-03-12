FROM ruby:2.1

# Although this environment is built for running grunt/npm 
#  tasks, we need ruby as well to run the compass task. 
# The Dockerfile is based on the ruby image rather than 
# the node image, as the ruby base image is more complex 
#  to duplicate

# Install fontforge and ttfautohint for webfont compiling.
# TODO: build latest version of ttfautohint from source
RUN apt-get update && apt-get install -y fontforge ttfautohint=0.97-1 && rm -rf /var/lib/apt/lists/*

# Install Node to run grunt. Copied from the official node docker image.
# https://github.com/joyent/docker-node/blob/3bb9c7ba9eb2360a031717b146747eea781abfab/0.12/Dockerfile

# verify gpg and sha256: http://nodejs.org/dist/v0.10.30/SHASUMS256.txt.asc
# gpg: aka "Timothy J Fontaine (Work) <tj.fontaine@joyent.com>"
# gpg: aka "Julien Gilli <jgilli@fastmail.fm>"
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys 7937DFD2AB06298B2293C3187D33FF9D0246406D 114F43EE0176B71C7BC219DD50A3051F888C628D

ENV NODE_VERSION 0.12.0
ENV NPM_VERSION 2.5.0

RUN curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
	&& curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
	&& gpg --verify SHASUMS256.txt.asc \
	&& grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
	&& tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
	&& rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
	&& npm install -g npm@"$NPM_VERSION" \
	&& npm cache clear

#install grunt-cli
RUN npm install -g grunt-cli@0.1.13 \
	&& npm cache clear

# Create folder to store and run the app
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
