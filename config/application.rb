require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tinypantry
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Sydney'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.paperclip_defaults = {
      storage: :s3,
      s3_credentials: {
        bucket: Rails.application.secrets.s3_bucket_name,
        access_key_id: Rails.application.secrets.s3_key,
        secret_access_key: Rails.application.secrets.s3_secret
      }
    }

    # Exception handling
    config.exceptions_app = lambda do |env|
      ErrorsController.action(:show).call(env)
    end

    # Generators config
    config.generators.assets = false
    config.generators.helper = false

    # Mailer config
    config.action_mailer.default_url_options = { host: 'tinypantry.com' }
    config.action_mailer.delivery_method = :sendmail
  end
end
