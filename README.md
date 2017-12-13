# slacklinegroups

This repo contains the code necessary to contribute to and run slacklinegroups.com. The primary focus of the site is to aggregate the worlds slackline groups into one central map. Below you will find documentation of running the site and creating a quick development environment (windows/linux).

### Table of Contents
* [Setting up your development environment](#environment-setup)
* [Site structure](#setup)
* [Database Schema](#structure)
* [Troubleshooting](#schema)

## Environment Setup

#### Windows

* First, clone the repo `git clone https://Github.com/Syntaf/slacklinegroups`

* Download [Vagrant](https://www.vagrantup.com/downloads.html) if you don't already have it. Since rails on windows is really slow, vagrant will allow you to run a headless linux VM that can host the repo and sync with your local files.

* From inside the repo, run `vagrant up`

* After completion, ssh into the VM with `vagrant ssh`

* Inside the VM, create a user role for vagrant with `sudo -u postgres createuser --createdb vagrant`

* Your repo within vagrant is at `/vagrant`, so to seed it and start the server you'll need to run the following commands:
```
> cd /vagrant
> rake db:create
> rake db:migrate
> rake db:seed
> rake assets:precompile
> rails server
```

* `localhost:3000` should be reachable now, and development can be done via windows.

#### Linux

* First, clone the repo `git clone https://Github.com/Syntaf/slacklinegroups`

* (Recommended) install [RVM](https://rvm.io/) and configure ruby for version 2.4.0 and rails 5.1.1

* Proceed as normal with creating the db and running the server:
```
> rake db:create
> rake db:migrate
> rake db:seed
> rake assets:precompile
> rails server
```

## Structure

## Schema

## Troubleshooting
If JS is not loading, try `rake assets:precompile`