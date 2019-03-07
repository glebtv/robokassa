require 'spec_helper'


describe 'routes', type: :routing do
  context "robokassa" do
    it "routes robokassa notify" do
      expect(:get => '/robokassa/notify/some-secure-notification-key').to route_to(
        controller:       'robokassa',
        action:           'notify',
        token:            'some-secure-notification-key'
      )
    end
    it "routes robokassa success" do
      expect(:get => '/robokassa/success').to route_to(
        controller: 'robokassa',
        action:     'success'
      )
    end
    it "routes robokassa fail" do
      expect(:get => '/robokassa/fail').to route_to(
        controller: 'robokassa',
        action:     'fail'
      )
    end
  end
end
