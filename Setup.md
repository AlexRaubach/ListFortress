# How I develop Rails projects on Windows

I built a new computer in Jan 2020 and I roughly documented the steps I took to get my development enviroment set up with some brief reasoning.

Quick note: Gems are packages for 

I run Windows for a variety of reasons but would like to get some of the benefits of developing on Linux. The best reason is because the production version of the site runs on Linux. Matching the OS allows me to run the exact same gem or ruby package versions in both development or production. My hosting provider, Heroku, will discard the list of gem versions, Gemfile.Lock, if it was created for a Windows install. 

To get the benefits of Linux when developing and Windows when doing everything else, I use the Windows Subsystem for Linux. Basicly, it gives me a command prompt that runs a simple version of Linux that can be used to run our Ruby programs.

Just go follow Microsoft's instructions for installing WSL. You'll have to enable a windows feature, restart and then install a distro from the windows store. I chose the Ubuntu distro and it's a solid choice but if you have strong opinions on a distro, you probably know enough to chose whichever distro you want.

Next is a database which will need to run on Windows. I highly suggest Postgres because it supports jsonb, a better way to store json data for our use case, and because it's what I use in production. Go to their website, download the latest version, install it and use a password that you’ll remember. Once it’s installed, run pgAdmin, open the server, find the login/group roles part and make a new user and password to use with Ruby on Rails. I make this new user a superuser but if you wanted you could lock down these permissions. Write this username and password down somewhere, we’ll use them once we get a little further along.

Next, let's install a code editor. I highly suggest Visual Studio Code because it has a really great integration with WSL. It allow me to be in Windows while VSCode seamlessly connects to WSL and runs all my code and extentions in Linux. [Read about it here](https://code.visualstudio.com/docs/remote/wsl) and just follow the instructions to get it set up.  

To finish our windows tasks, let's get our repo downloaded. Open WSL or another command line with git like Git Bash and navigiate to where you'd like to store the files. I personally use C:\dev (/mnt/c/dev on WSL) but it's up to you. Run `git clone https://github.com/AlexRaubach/ListFortress.git`

To be continued... Remaining topics

Rbenv

Ruby 

Bundler

install gems

Install other dependencies like Node

set up the project with db credentials 

Get it running `rails s` and `rails c`

