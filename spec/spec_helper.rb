require 'rubygems'
require 'bundler'
require 'combustion'
require 'rails'

Bundler.require :default, :development

#  :active_record,
Combustion.initialize! :action_controller

require 'rspec/rails'

RSpec.configure do |config|
  config.use_transactional_fixtures = true
end
