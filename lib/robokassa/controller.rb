module Robokassa::Controller
  extend ActiveSupport::Concern
  included do
    skip_before_filter :verify_authenticity_token
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