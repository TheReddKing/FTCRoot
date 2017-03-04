# General Structure of the code


This is a rails setup.

## app directory


### controllers/views

There are 3 main 'controllers'

Events : Search, display events

Regions : Find Events through a region search

Teams : Team info and results


There are 2 helping 'controllers'

Pages: For generic webpages with no backend

Tools: Stats and Maps!


#### data

This is where all the data is stored. Contains all the data to be loaded into the rails server.

All this data is parsed from the ```lib/tasks/init.rake``` file. That's where the file->database magic happens.
