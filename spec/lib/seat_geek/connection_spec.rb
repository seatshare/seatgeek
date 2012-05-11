require 'spec_helper'

describe SeatGeek::Connection do
  let(:klass) { SeatGeek::Connection }
  let(:instance) { klass.new }

  describe ".adapter" do
    subject { klass.adapter }
    let(:default) { :net_http }

    it { should == default }
    it "should be writable" do
      klass.adapter = :typhoeus
      klass.adapter.should == :typhoeus
    end

    after { klass.adapter = default }
  end

  describe ".events" do
    it "proxies to #events" do
      klass.any_instance.should_receive(:events).and_return(nil)
      klass.events
    end

    it "passes any attributes to #events" do
      klass.any_instance.should_receive(:events).with(1, 2).and_return(nil)
      klass.events(1, 2)
    end
  end

  describe ".options" do
    it "should return a hash of all of the class level settings" do
      klass.options.should == {
        :adapter => :net_http,
        :protocol => :http,
        :response_format => :ruby,
        :url => "api.seatgeek.com",
        :version => 2
      }
    end
  end

  describe ".performers" do
    it "proxies to #performers" do
      klass.any_instance.should_receive(:performers).and_return(nil)
      klass.performers
    end

    it "passes any attributes to #performers" do
      klass.any_instance.should_receive(:performers).with(1, 2).and_return(nil)
      klass.performers(1, 2)
    end
  end

  describe ".protocol" do
    subject { klass.protocol }
    let(:default) { :http }

    it { should == default }
    it "should be writable" do
      klass.protocol = :https
      klass.protocol.should == :https
    end

    after { klass.protocol = default }
  end

  describe ".response_format" do
    subject { klass.response_format }
    let(:default) { :ruby }

    it { should == default }
    it "should be writable" do
      klass.response_format = :jsonp
      klass.response_format.should == :jsonp
    end

    after { klass.response_format = default }
  end

  describe ".taxonomies" do
    it "proxies to #taxonomies" do
      klass.any_instance.should_receive(:taxonomies).and_return(nil)
      klass.taxonomies
    end

    it "passes any attributes to #taxonomies" do
      klass.any_instance.should_receive(:taxonomies).with(1, 2).and_return(nil)
      klass.taxonomies(1, 2)
    end
  end

  describe ".url" do
    subject { klass.url }
    let(:default) { "api.seatgeek.com" }

    it { should == default }
    it "should be writable" do
      klass.url = "ticketevolution.com"
      klass.url.should == "ticketevolution.com"
    end

    after { klass.url = default }
  end

  describe ".venues" do
    it "proxies to #venues" do
      klass.any_instance.should_receive(:venues).and_return(nil)
      klass.venues
    end

    it "passes any attributes to #venues" do
      klass.any_instance.should_receive(:venues).with(1, 2).and_return(nil)
      klass.venues(1, 2)
    end
  end

  describe ".version" do
    subject { klass.version }
    let(:default) { 2 }

    it { should == 2 }
    it "should be writable" do
      klass.version = 1
      klass.version.should == 1
    end

    after { klass.version = default }
  end

  describe "#initialize" do
    let(:expected) { klass.options.merge(options) }
    let(:options) { { :testing => 123, :clone => :hello } }
    let(:str_options) { {}.tap{|o| options.each{|k, v| o[k.to_s] = v}} }
    let(:instance) { klass.new(options) }

    it "should take options passed and store them on top of the class options hash" do
      instance.instance_eval('@options').should == expected
    end

    it "should convert the keys passed to symbols" do
      klass.new(str_options).instance_eval('@options').should == expected
    end

    it "should serve options up via read accessor methods unless the methods already exist" do
      instance.testing.should == options[:testing]
      instance.clone.should_not == options[:clone]
    end
  end

  describe "#build_request" do
    it "should create and return a faraday object" do
      instance.build_request('/', {}).should be_a_kind_of Faraday::Connection
    end
  end

  describe "#events" do

    context "when passed an id" do
      it "should make a show call to the api" do
        pending "#request existing"
      end
    end
  end

  describe "#performers" do
    context "when passed an id" do
      it "should make a show call to the api" do
        pending "#request existing"
      end
    end
  end

  describe "#request" do
    let(:url) { '/events' }
    let(:params) { {} }
    let(:faraday) { mock(:faraday, :get => []) }

    it "should call #build_request with a url and parameters" do
      instance.should_receive(:build_request).with(url, params).and_return(faraday)
      faraday.should_receive(:get)
      instance.request(url, params)
    end
  end

  describe "#taxonomies" do
    context "when passed an id" do
      it "should make a show call to the api" do
        pending "#request existing"
      end
    end
  end

  describe "#uri" do
    it "should take in a path and combine it with protocol, url and version" do
      instance.uri('/events').should == "http://api.seatgeek.com/2/events"
    end
  end

  describe "#venues" do
    context "when passed an id" do
      it "should make a show call to the api" do
        pending "#request existing"
      end
    end
  end
end
