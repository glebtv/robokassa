About this fork
-------

Everything I didn't need is removed. Added signature verification where possible. Fixed a lot of stuff that didn't work for me

SUMMARY
-------

This gem adds robokassa support to your app.

Robokassa is payment system, that provides a single simple interface for payment systems popular in Russia.
If you have customers in Russia you can use the gem.

The first thing about this gem, is that it was oribinally desgned for spree commerce. So keep it im mind.


Using the Gem
-------------

Add the following line to your app Gemfile

    gem 'glebtv-robokassa'

Update your bundle

    bundle install

Mount engine in routes:
    mount Robokassa::Engine => '/robokassa'

    
Create `config/initializers/robokassa.rb` with such code

```ruby

    class RoboCustom < Robokassa::Interface
      def success_implementation(invoice_id, amount, language, custom_options, controller)
        # this is called to show user payment success page
        # Mostly secure to rely on
      end

      def fail_implementation(invoice_id, amount, language, custom_options, controller)
        # this is called to show user payment fail page and unlock inventory stocks for order
        # INSECURE
      end

      def notify_implementation(invoice_id, amount, custom_options, controller)
        # this is called by robokassa server, to actually validate payment
        # Secure.
      end
    end

    Robokassa.interface = RoboCustom.new({
      language: 'ru',
      test_mode: true,
      login: 'robox_login',
      password1: 'asdf1234',
      password2: 'qwer5678',
      token: 'qwer1234' # "robokassa/notify/:token"
    })
```

In View file:

```ERB
<% pay_url = Robokassa.interface.init_payment_url(order.id, order.amount, "Order #{order}", '', 'ru', order.user.email, {}) %>
<%= link_to "Оплатить через сервис ROBOX", pay_url %>
```

In Robokassa account settings set:

    Result URL: http://example.com/robokassa/notify
    Success URL: http://example.com/robokassa/success
    Fail URL: http://example.com/robokassa/fail


To overwrite controller you can do like this:

```ruby
# coding: utf-8
class RobokassaController < ApplicationController
  
  include Robokassa::Controller
  
  def success
    super
    @payment = Payment.find(params[:InvId])
    redirect_to dashboard_path, notice: "Ваш платеж на сумму #{@payment.amount} руб. успешно принят. Спасибо!"
  end

  def fail
    super
    redirect_to dashboard_path, varning: "Во время принятия платежа возникла ошибка. Мы скоро разберемся!"
  end
end
```

Testing
-----
In console:

Clone gem
```bash
git clone git://github.com/shaggyone/robokassa.git
```

Install gems and generate a dummy application (It'll be ignored by git):
```bash
cd robokassa
bundle install
bundle exec combust
```

Run specs:
```bash
rake spec
```

Generate a dummy test application

Plans
-----

I plan to add generators for views
