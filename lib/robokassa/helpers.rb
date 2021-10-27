module Robokassa
  module Helpers
    # Generates url for payment page
    #
    # === Example
    # <%= robokassa_payment_form order.id, order.amount, "Order #{order.id}", '', 'ru', order.user.email) do %>
    #   <%= submit_tag "Pay with robokassa", name: nil %>
    # <% end %>
    #
    def robokassa_payment_form(invoice_id, amount, description, currency='', language='ru', email='', custom_options={})
      form_options = Robokassa.interface.init_form_payment_options(invoice_id, amount, description, custom_options, currency, language, email)
      content_tag :form, action: Robokassa.interface.init_payment_base_url, method: :post do
        (form_options.map do |key, value|
          content_tag :input, '', name: key, value: value, type: :hidden
        end + [
          if block_given?
            capture do
              yield(form_options)
            end
          else
            content_tag :input, '', type: :submit, value: "Pay with Robokassa"
          end
        ]).join.html_safe
      end
    end
  end
end
