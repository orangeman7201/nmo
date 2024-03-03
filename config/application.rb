require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sample
  class Application < Rails::Application
    config.load_defaults 7.1
    config.autoload_lib(ignore: %w(assets tasks))
    config.generators.system_tests = nil
    config.action_controller.forgery_protection_origin_check = false
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        # 本番環境ができたらoriginsに追加する
        # Todo: csrfの方もexposeで対応できるようにする
        origins 'localhost:3001'
        resource '*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head],
          expose: %w[access-token uid client],
          credentials: true
      end
    end

    # apiが受け取ったparamsをsnake_caseに変換する
    ActionDispatch::Request.parameter_parsers[:json] = lambda { |raw_post|
      # Modified from action_dispatch/http/parameters.rb
      data = ActiveSupport::JSON.decode(raw_post)

      # Transform camelCase param keys to snake_case
      if data.is_a?(Array)
        data.map { |item| item.deep_transform_keys!(&:underscore) }
      else
        data.deep_transform_keys!(&:underscore)
      end

      # Return data
      data.is_a?(Hash) ? data : { '_json': data }
    }

    # active_model_serializersのkeyをcamel_lowerに変換する
    ActiveModelSerializers.config.key_transform = :camel_lower

    OpenAI.configure do |config|
      config.access_token = ENV.fetch("OPENAI_API_KEY")
    end
  end
end
