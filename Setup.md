# How I develop Rails projects on Windows

I built a new computer in Jan 2020 and I roughly documented the steps I took to get my development enviroment set up with some brief reasoning. Revised in Oct 2020 when I attempted to rebuild my dev enivroment in WSL2.

I run Windows for a variety of reasons but would like to get some of the benefits of developing on Linux, partially because the production version of the site runs on Linux (via Heroku). Matching the OS allows me to run the exact same gem or ruby package versions in both development or production which makes troubleshoot a lot easier and upgrading gems more predictable.

To get all these benefits without having to actually run Linux, I use the Windows Subsystem for Linux (WSL). Basicly, it gives me a command prompt that which is tied to a simple version of Linux that can be used to run and develop programs.

Before getting started, you'll have to decide between WSL1 and 2. WSL2 is a complete VM which has both upsides (performance) and downsides. I found the biggest downside to be getting postgres to work effortlessly. With WSL1 you can have pg installed in Windows where it autostarts and has an easy gui for infrequent config changes or db restores. If you have pg running inside WSL2, you'll have to manually sudo start it (and therefore have to type in your password) every time you start WSL2 or run rails. Connecting to a Windows pg instance in WSL2 is tough because neither the host computer or the WSL2 vm have constant IP addresses. I'm sure it's possible but it's not easy so imo you should just use WSL1.

Just go follow Microsoft's instructions for installing WSL. You'll have to enable a windows feature, restart and then install a distro from the windows store. I chose the latest Ubuntu LTS distro but if you have strong opinions on a distro, you probably know enough to chose whichever you want.

Next is a database which will need to run on Windows. I chose Postgres because it supports jsonb, a better way to store json data for our use case, and because it's what I use in production.  Go to their website, download the latest version, install it and use a password that you’ll remember. Once it’s installed, run pgAdmin, open the server, find the login/group roles part and make a new user and password to use with Ruby on Rails. I make this new user a superuser but if you wanted you could lock down these permissions. Write this username and password down somewhere, we’ll use them once we get a little further along.

Next, let's install a code editor. I highly suggest Visual Studio Code because it has a really great integration with WSL. It allow me to be in Windows while VSCode seamlessly connects to WSL and runs all my code and extentions in Linux. [Read about it here](https://code.visualstudio.com/docs/remote/wsl) and just follow the instructions to get it set up.

To finish our windows tasks, let's get our repo downloaded. Open WSL or another command line with git like Git Bash and navigiate to where you'd like to store the files. I personally use C:\dev (/mnt/c/dev on WSL) but you'd get better performance if you had the repo inside the WSL filesystem. Then run `git clone https://github.com/AlexRaubach/ListFortress.git`

Next we want to install a program to manage our ruby installation and versions so we can easily switch between / upgrade ruby for one project without impacting other projects. The two popular solutions are [Rbenv](https://github.com/rbenv/rbenv) and RVM. I recomend rbenv if you don't already have a preference. Just follow the setup instructions, I also install [ruby-build](https://github.com/rbenv/ruby-build#readme) with rbenv which requires more setup but makes it easy to install a new ruby version with only one command. I suggest installing the [recommended ruby-build packages](https://github.com/rbenv/ruby-build/wiki), installing [rbenv via this script](https://github.com/rbenv/rbenv-installer#rbenv-installer) then [following the ruby-build install instructions](https://github.com/rbenv/ruby-build#installation). 

Next just find which version of ruby you need (check .ruby-version in the repo's main folder) and install it. If you've followed my suggestions, this is as simple as `rbenv install 2.7.1` followed by `rbenv rehash`.

Next install bundler, this ruby program handles tracking and versioning ruby third party packages i.e. gems. Just run `gem install bundler`.

Now let's use bundler to install everything. In WSL, navigate to the project folder and run `bundler install`. This will read the Gemfile.lock file, see which version of every gem you need and then install it.

Lastly, you'll need a recent version of Node installed in WSL. I'd suggest just the most recent LTS version but it doesn't really matter for this project.

If you haven't already, in wsl, run `code .` from the root of the project folder to open vscode in wsl development mode.

Finally, let's setup our db and application credentials. In the root of the project, run `cp config/application.yml.sample config/application.yml` I use a gem called fiddler which reads application.yml, finds credientials stored there and puts them into the enviroment. It's important that you never commit your application.yml file to git as that will make all your secret keys public. This project already has .gitignore configured to exclude that file but just be careful. 

The only values you need to supply for ListFortress is the db user and password that you should have from earlier. Slack and AWS are used for league features like SSO and file storage but you shouldn't need them to get started.

Finally, try to run the server by `rails s` and then opening the specified webpage in your browser, the default is http://localhost:3000/

If you want to test out something, you can also open a rails console by running `rails c`.

If you use this guide and have questions or find it unclear, please reach out to me via the vassal league slack or open an issue and I'll try to help you out. Pull requests are also welcome.