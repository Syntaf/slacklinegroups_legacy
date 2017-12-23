require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Slacklinegroups
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Allow slacklinegroups to be placed within an iframe
    config.action_dispatch.default_headers = {
     'Access-Control-Allow-Origin' => 'http://localhost:3000/slacklinegroups.js'
    }

    config.after_initialize do
      Rails.application.load_tasks
      Rake::Task['minify:slg'].invoke
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
