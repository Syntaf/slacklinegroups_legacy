### Seeding

* On Friday, December 8th 2017 a migration occured that moved the database to an entirely new schema. As a result, seeding now requires a little extra work since the old ID's must be maintained. 

#### Dumping seeds

* Before dumping seeds, you'll want to save the information at the bottom of the seed, specifically:

```
res = ActiveRecord::Base.connection.execute("SELECT MAX(id)+1 AS idx FROM groups;")
gidx = res.first['idx']
res = ActiveRecord::Base.connection.execute("SELECT MAX(id)+1 AS idx FROM location;")
lidx = res.first['idx']
res = ActiveRecord::Base.connection.execute("SELECT MAX(id)+1 AS idx FROM info;")
iidx = res.first['idx']
res = ActiveRecord::Base.connection.execute("SELECT MAX(id)+1 AS idx FROM submitted_group;")
sidx = res.first['idx']
res = ActiveRecord::Base.connection.execute("SELECT MAX(id)+1 AS idx FROM submitted_group_history;")
shidx = res.first['idx']

ActiveRecord::Base.connection.execute("ALTER SEQUENCE groups_id_seq RESTART WITH #{gidx};")
ActiveRecord::Base.connection.execute("ALTER SEQUENCE location_id_seq RESTART WITH #{lidx};")
ActiveRecord::Base.connection.execute("ALTER SEQUENCE info_id_seq RESTART WITH #{iidx};")
ActiveRecord::Base.connection.execute("ALTER SEQUENCE submitted_group_id_seq RESTART WITH #{sidx};")
ActiveRecord::Base.connection.execute("ALTER SEQUENCE submitted_group_history_id_seq RESTART WITH #{shidx};")
```

Once you have a copy of this code, you can run `rake db:seed:dump EXCLUDE=[]` (note since the ID's are used at URL's, we want to exclude nothing in the dump). Once the dump is finished, move the cut code back into the bottom.

#### Seeding the database

If you followed the steps above, seeding the data should be done normally with `rake db:seed`. If you want to reset the entire database, you can run

```
> rake db:drop
> rake db:create
> rake db:migrate
> rake db:seed
```