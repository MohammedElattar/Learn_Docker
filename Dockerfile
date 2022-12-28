# Base image and os that image working on
# FROM node:16-alpine3.16

# COPY -> is used to copy app file and build it in image

# Copy all files in the project
# COPY . .

# Copy specefic files into (app/) which Docker will create and put our project in 
# COPY package.json package-lock.json app/

# We can also use "REGEX" to match needed files , HERE we copy all files that starts with package and ends with .json
# COPY package*.json .

# we can use in destination directory relative or absolute path

# If we want to type a file that contains space or any special characters we use an array
# with content in it 
# COPY ["googl internet.txt" , "README.md"] .

# Working directory
# HERE we specify that all code that comes after that command expected to be in app directory
# WORKDIR /app

# * ADD => It's like COPY in everything , but it has additional features 
# ?1 => We can use it to add data from a link like that
# ? Here we get the source of google and create a file of that source
# ADD http://www.google.com app/

# ? We can also use add to uncompress a compressed file like that
#? That will unzip the file and get all the contents in it and add it to app directory
# ADD main.zip app/
# * Here in our situation we'll add all files including node_modules directory
# COPY . app/

#* But , what if we want to execlue some files or directory
#? We use .dockerignore to execlude files or directories , just like .gitignore 

#* After execulding node_modules directory , we need to run `npm install` command on our container to
#* get node modules , and we can make that using "RUN" command in dockerfile
#? Here we run npm install command to install dependecies
# RUN npm install


# We can also add environment variables too
#? We assign NAME to Google and they are the same 
# ENV NAME=Google
# ENV NAME Google

#* Here how to define  a new user to our application
#? In Linux , we use addgroup to add a new group which will contain a user 
#? Here we add a gorup and add app user to that group
# RUN addgroup app && adduser -S -G app app
# USER app

#* If we want to tell our container to point a spcefic port we use "Expose" COMMAND
#? Here it w'll point to 3000 port on docker , not on HOST machine
# EXPOSE 3000

#* If we want to run defualt commands on docker building we use CMD command
#? we can use npm start or ['npm' , 'start'] , and the difference is 
#? the first one is run on a seperate shell and the second one runs on the same shell
#? the second is better because it take small time and it's good when we want to uninstall our project
#? However , this " CMD " can be overriden if we type another commands , for example
#? docker build react-app npm install => it will make the same things like we typed 
#? if we typed docker build react-app , it 'll also make the same command , but if we make
#? docker build react-app gogole good
#? CMD [ "npm" , "start" ] 
#* We can also use ENTRYPOINT command , it's like CMD , but the difference is we can easily modify CMD commands
#? BY typing other commands in their place , but entrypoint , we must use --entrypoint tag to modify parameters of it

# ENTRYPOINT [ "npm" , "install" ]


#* now we gonna talk about how to publish our images to public so any one can access it 
#? first we go to docker hub and create an account and a new repository
#? it's like gihub in most things , after we create a new repository we take it's link
#? it's like your_user_name/respitoryName
#? now , we must create a new image with the same name of that repo
#? for exampe , if we have image called "react-app" , we make an image and tag it like so
#? docker image tag react-app:version_of_it mohamedattar2302/react-app:1
#? Now we created an image , now we must Login to our account from docker shell
#! docker login  , enter your username , and your password , and your are logged in ! 
#? after that we can push our image using docker push for that example
#? docker push mohamedattar2302/react-app:1
#? and the image will be pushed to our account with that tag name

# ! Exporting images as compressed file
#? we use that command
#? docker image save -o "Name of compressfile".[zip,tar,rar,....etc]

# ! Loading images
#? To Load images compressed using "docker image save " command , we use "docker image load " command
#? docker image load -i "Compressed file name".[extension]

#! Speeding up building our images
#? We install the files or dependcies that don't changed much times first from their main files
#? like composer.json or package.json , and then install our project files
# Base Image
FROM node:16-alpine3.16

# Make a user with limited permissions
RUN addgroup app && adduser -S -G app app
USER app


# Specify the working directory
WORKDIR /app
RUN touch file.txt

# RUN mkdir testdir

# # Make the changing file first

# COPY package*.json .

# # Installing dependcies if not installed or any change occured to Package.json file

# RUN npm install

# # Copying our project file that we working on not node_modules , because we execlude it

# COPY . .

# # Expose our port that our app will work on
# # !? that means that our app will work on port 3000

# EXPOSE 3000

# # Start our project by npm start
# CMD [ "npm" , "start" ]