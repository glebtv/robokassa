#encoding: utf-8

require File.dirname(__FILE__) + '/../spec_helper'
require 'robokassa/interface'
describe "Interface should work correct" do
  before :each do
  end

  it "Should correctly use test server" do
    i = Robokassa::Interface.new :test_mode => true
    i.should be_test_mode
    i.base_url.should == "http://auth.robokassa.ru/Merchant"
  end

  it "should compute correct signature string" do
    i = Robokassa::Interface.new :test_mode => true, :login => 'demo', :password1 => '12345'
    i.init_payment_signature_string(15, 185.0, "Order #125").should == "demo:185.0:15:12345"
    i.init_payment_signature_string(15, 185.0, "Order #125", {:a => 15, :c => 30, :b => 20}).should == "demo:185.0:15:12345:shpa=15:shpb=20:shpc=30"
  end

  it "should create correct init payment url for test_mode" do
    i = Robokassa::Interface.new :test_mode => true, :login => 'demo', :password1 => '12345'
    expected_url = "http://auth.robokassa.ru/Merchant/Index.aspx?MrchLogin=demo&OutSum=185.11&InvId=15&Desc=Order+125&SignatureValue=8e32c6ad194a540fe14fb97367360170&IncCurrLabel=&Email=demo%40robokassa.ru&Culture=ru&isTest=1&custom_options=%7B%7D"
    generated_url = i.init_payment_url(15, 185.11, "Order 125", '', 'ru', 'demo@robokassa.ru', {})
    puts generated_url
    generated_url.should == expected_url
  end

  it "should create correct init payment url for production" do
    i = Robokassa::Interface.new :login => 'shaggyone239', :password1 => '12345asdf'
    i.init_payment_signature_string(15, 185.11, "Order #125").should == "shaggyone239:185.11:15:12345asdf"
    i.init_payment_signature(15, 185.11, "Order #125").should == "55f2aee20767cde28e7fc49919cec969"
    i.init_payment_url(15, 185.11, "Order 125", '', 'ru', 'demo@robokassa.ru', {}).should ==
      "ttps://merchant.roboxchange.com/Index.aspx?MrchLogin=shaggyone239&OutSum=185.11&InvId=15&Desc=Order+125&SignatureValue=55f2aee20767cde28e7fc49919cec969&IncCurrLabel=&Email=demo%40robokassa.ru&Culture=ru&isTest=1"
    i.init_payment_signature(196, 2180.0, "R602412577").should == "adeedf2afbac5eca09b44898da3ef51a"
  end

  it "should check success result" do
    i = Robokassa::Interface.new :test_mode => true, :login => 'demo', :password1 => '12345'

    data = [ 15, 185.55, "Order #125", { :a => 15, :b => 30, :c => 20 } ]

    signature_string = i.init_payment_signature_string( *data )

    expect( signature_string ).to eq "demo:185.55:15:12345:shpa=15:shpb=30:shpc=20"

    expect( i.init_payment_signature( *data ) ).to eq '3de046ed8d103b39b2bea2728b2eab27'

    params = {
      "OutSum" => "185.55",
      "InvId" => "15",
      "SignatureValue" => '75d4910b8b751dda4362d89333b247ca',
      "Culture" => 'ru',
      "shpa" => "15",
      "shpb" => "30",
      "shpc" => "20",
    }

    expect { i.success_validate_signature( params ) }.not_to raise_error
  end
end
