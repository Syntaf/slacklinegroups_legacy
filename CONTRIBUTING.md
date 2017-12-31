## Writing new controllers

When writing new controllers, you'll need to manually add the generated controller to the `/config/initializers/assets.rb` file. For example, to add some new controller _my\_thing\_controller.rb_ you would do:

```
> rails g controller my_thing
...
```

Then inside _assets.rb_ , modify the bottom line to:

```ruby

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
%w( map embedded_map about groups admin develop my_thing ).each do |controller|
  Rails.application.config.assets.precompile += ["#{controller}.js", "#{controller}.css"]
end
```

## Creating additional assets

Asset creation will *always* need to be done inside the rails asset pipeline, so you should never place js/sass/html/other files anywhere but `app/assets` (`vendor` is also allowed, but will rarely be needed).
