require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CinemaInformation
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # to auto load lib/ directory
    # 以下は、production環境ではautoloadされないので、避けるべきみたい
    #config.autoload_paths += %W(#{config.root}/lib)
    # 以下のように、production環境ではEagerLoadされるようにする
    # 参考URL：https://qiita.com/joooee0000/items/3ab0f3d791e0d0beb639
    config.paths.add 'lib', eager_load: true

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
