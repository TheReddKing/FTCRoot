# How to setup this stuff

I'm assuming that you are running OSX or Linux with ruby installed, caz installing ruby is a pain on Windows.

If you don't have Ruby, install homebrew and install ruby. (Google that)



## First time

First Clone this repo

Then cd to this directory

Setup a local MYSQL server with a database named "ftcroot_development"

Edit the config/database.yml to the correct database username/password


## Updating everything to the latest stuff

And then type ```bundle install``` to install the gems

To load teams, events, and other stuff run ```rails init:M init:N init:O init:T```

This will take some time!



## To Run the Server

``` rails s ``` and the url to go to is ``` localhost:3000 ```
