#### Summary

This directory contains files used to migrate the old schema to the new better and more modualar schema.

* migrate_old_seeds.rb: ruby script which parses old_group_seeds.rb into the new schema
* migrate_submitted_seeds.rb: ruby script which parses old_user_group_seeds.rb into the new schema
* old_group_seeds.rb & old_user_group_seeds.rb: database dump of the site at the time right before the migration to the new schema.

#### Running these files

These files require the rails environment to run, to do so perform these steps:

```
> cd slacklinegroups
> rails console
Running via Spring preloader in process 6916
Loading development environment (Rails 5.1.1)
2.4.0 :001 > load 'db/migrate_old_seeds.rb'
```