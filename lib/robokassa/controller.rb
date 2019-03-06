module Robokassa::Controller
  extend ActiveSupport::Concern
  included do
    if protect_against_forgery?
      skip_before_action :verify_authenticity_token, only: [:notify]
    end
  end

  def notify
    if params[:token] != Robokassa.interface.token
        raise Robokassa::InvalidToken.new
    end
    render :text => Robokassa.interface.notify(params, self)
  end

  def success
    retval = Robokassa.interface.success(params, self)
    redirect_to retval if retval.is_a? String
  end

  def fail
    retval = Robokassa.interface.fail(params, self)
    redirect_to retval if retval.is_a? String
  end
end
