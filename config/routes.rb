Robokassa::Engine.routes.draw do
  get "notify/:token" => 'robokassa#notify',  as: :robokassa_notification
  get "success"       => 'robokassa#success', as: :robokassa_on_success
  get "fail"          => 'robokassa#fail',    as: :robokassa_on_fail
end
