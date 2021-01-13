require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SampleApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end

# Version of your assets, change this if you want to expire all your assets
# Loads environment variables from file config/local_env.yml
# access vars using ENV['VAR_NAME']

env_file = File.join(Rails.root, 'config', 'local_env.yml')
if File.exist?(env_file)
    YAML.load(File.open(env_file)).each do |key, value|
      ENV[key.to_s] = value
    end
end