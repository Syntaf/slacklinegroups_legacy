Adaptive zoom:

    Point: (x, y)
    Modal: (width, height)

    @ (x, y), (x +/- width, y +/- height) must be within bounds


# slacklinegroups

This repo contains the code necessary to contribute to and run slacklinegroups.com. The primary focus of the site is to aggregate the worlds slackline groups into one central map. Below you will find documentation of running the site and creating a quick development environment (windows/linux).

For specific tips on contributing, see CONTRIBUTING.md

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

*Note* see the code for specific function documentation, this section aims to provide a very high level overview.s

slacklinegroups.com can be broken down into 3 main components: *user submitted content*, *administrative controls*, and the *map* itself.

#### User Submitted Content

_groups\_controller.rb_ implements the logic for allowing user groups to be submitted. This controller will use the `SubmittedGroup` record, which aggregates all possible fields a user could enter for the `Location`, `Info`, and `Group` tables used by the map. 

In _routes.rb_, we specify `:resources` for this controller, but hide the *show* and *index* from normals users. We only want users to be able to submit groups, so the index route redirects to the admin panel (where user submitted groups can be shown already) and the show route is never mentioned to normal users (it is used in the admin panel, but not specifically protected from users accessing if they manually enter a URL).

#### Administrative Panel

_admin\_controller.rb_ provides administrative tools for managing the site. Currently, an admin can do the following:

  * View all active groups
  * View user submitted groups with pending status
  * Preview a user submitted group on the active group map
  * Approve or reject a user submitted group
  * Delete or modify an active group

More tools are likely to come, but these are the most important pieces of the admin panel.

#### Active group map

Lastly, _map\_controller.rb_ and _embedded\_map\_controller.rb_ are responsible for displaying a map with all slacklinegroups on it. Both of these controllers inherit from _base\_map\_controller.rb_, which implements the core functionality of the slackline group map (whether that map be embedded or displayed on the website itself).

#### Controllers not mentioned in the above topics

Any controller not mentioned in the sections above is not of critical importance, and more relates to informational content. These controllers are very simple and are mostly JS/HTML, so there isn't much to say here.

## Schema

TBW

## Troubleshooting
* If JS is not loading, try re-running `rake assets:precompile`