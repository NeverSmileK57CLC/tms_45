require File.expand_path('../boot', __FILE__)

require "csv"
require "rails/all"


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.

module BaseApp
  class Application < Rails::Application

    Bundler.require(*Rails.groups)
    Config::Integration::Rails::Railtie.preload

    config.before_configuration do
      env_file = File.join Rails.root, "config", "application.yml"
      YAML.load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end if File.exists? env_file
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    config.time_zone = Settings.time_zone

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
  end
end
