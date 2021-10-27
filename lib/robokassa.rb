require 'cgi'
require 'digest/md5'

module Robokassa
  class InvalidSignature < ArgumentError; end
  class InvalidToken < ArgumentError; end

  mattr_accessor :interface

  class Engine < Rails::Engine #:nodoc:
    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
    end

    config.to_prepare &method(:activate).to_proc
  end
end

require 'robokassa/controller'
require 'robokassa/interface'
require 'robokassa/engine'

ActiveSupport.on_load :action_view do
  require 'robokassa/helpers'
  ::ActionView::Base.send :include, Robokassa::Helpers
end
