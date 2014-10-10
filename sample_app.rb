unless File.exist?('Gemfile')
  File.write('Gemfile', <<-GEMFILE)
    source 'https://rubygems.org'
    gem 'rails', github: 'rails/rails'
  GEMFILE

  system 'bundle'
end

require 'bundler'
Bundler.setup(:default)

require 'rails'
require 'action_controller/railtie'

class TestApp < Rails::Application
  config.root = File.dirname(__FILE__)
  config.session_store :cookie_store, key: 'cookie_store_key'
  config.secret_token    = 'secret_token'
  config.secret_key_base = 'secret_key_base'

  config.logger = Logger.new($stdout)
  Rails.logger  = config.logger

  routes.draw do
    root 'test#index'
  end
end

class TestController < ActionController::Base
  include Rails.application.routes.url_helpers

  def index
    head :ok, :content_type => 'text/html'
  end
end

require 'minitest/autorun'
require 'rack/test'

class BugTest < Minitest::Test
  include Rack::Test::Methods
  include Rails.application.routes.url_helpers

  def test_some_test
    assert_equal '/', root_path(controller: "test", action: "index")
  end

  private
    def app
      Rails.application
    end
end
