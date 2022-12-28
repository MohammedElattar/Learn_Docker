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

#! ############################### Containers ###############################################

#! Run a container in detached mode , so we can use our terminal again
#? we use the -d flag to run in detached mode

# docker run -d -it react-app:1

#! Naming our container 
#? when we run a new image , docker set a random name to our container , so if we want to set that name 
#? when running our image we use => --name flag
# docker run -d --name hello-world react-app:1
#? Of course if the contaienr is immdeiately closes after that operation
#? we can use -dt , t here means that container holds input and output , so it works as expected
# docker run -dt --name test react-app:1

#! Seeing the logs of our container 
#? it's usefull when error occures and we want to see that error 
#? docker logs <container_name|container_id>
#? we have some options with it
#? -f which follow the logs of that container , so we see realtime logs of that container
#? -n to spceify how many lines we want to see from the end
#? -t if we want to see timestamp when each line was created

#! Mapping our containers to host's ports
#? If we run our application on port 3000 in our container , our host machine 
#? cannot see that port , and it's closed on it 
#? so we use -p flag to open that port on host and run our application on that port
#? Here we tell the host that your port 3000 is listening my port 20 in my container
#? -p host_port:container_port => that is our syntax
#? docker run -p 3000:20

#! Executing commands on a running container
#? we use exec command for that
# docker exec <container_name|id> <our command>
#? of course we can use sh to interact with our container 
#? Here we can type any command we want
# docker exec -it <container_name|id> sh
#? and if we exited that exec , our container will still work

#! What if we want to stop , start our container
#? we use
# docker stop <container>
# docker start <container>

#! Volumes
#? If we store any data on a container , this data is invisible to other container , even with the same image
#? so that we shouldn't store any data on container , we use volums for that manner
#? we can create a volume using that command
# docker volume create <volume_name>
#? if we want to list all our volums we use 
# docker volume ls
#? if we want to inspect our container to show more info about it we use 
# docker volume inspect <volume_name>
#? To Make our container use our volume , we pass -v flag to it like that
# docker run -d -v <volume_name>:<directory on our container>
# docker run -d -v app:/app/data
#? If either volume is not exists , or directory , docker will create them for us
#? but there is a problem in that , if we created a regular user , and docker create that directory for us
#? we cannot write to that directory , because docker is the root user , and we don't have write permission to write to the file 

#! Copying files or directories between the host and container 
#? we can use that command to do
# docker cp <container_id>:<from> <to> // That will copy from the container to our host machine
#docker cp from <container_id>:<to> // From host to container

#! Live changes from our container to our app or vice versa
#? if we make a change on our code and we want container to see that change
#? we can do that using "volumes"
#? if we are on mac , linux , we use that command
#* docker run -d --name app -v $(pwd):/app app
#? if we are on windows , we have to put the full path to our directory we want to share , because there
#? there is not "pwd" in cmd in windows
# docker run -dp 5000:3000 -v "C:/xampp/htdocs/learn_docker:/app" --name app app
#? and we will get a notification from Docker desktop to accept that sharing and it'll work !
#! ------------------------- And now we are done with docker , next let's see docker compose -------------




# Base Image
FROM node:16-alpine3.16

# Make a user with limited permissions
RUN addgroup app && adduser -S -G app app
USER app
# Specify the working directory
WORKDIR /app

# Add a new directory for the volume 
RUN mkdir data

# Make the changing file first
# Adding chown falg to add an additional layer without removing the previous one to get permissions

COPY --chown=app:node package*.json .

# Installing dependcies if not installed or any change occured to Package.json file

RUN npm install



# Copying our project file that we working on not node_modules , because we execlude it
# in .dockerignore file

COPY . .

# Expose our port that our app will work on
# !? that means that our app will work on port 3000

EXPOSE 3000

# Start our project by npm start
CMD [ "npm" , "start" ]