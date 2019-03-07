# coding: utf-8

class RobokassaController < ActionController::Base
  include Robokassa::Controller

  def success
    super
  end
end
