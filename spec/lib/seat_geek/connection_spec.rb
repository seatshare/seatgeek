require 'spec_helper'
require 'ostruct'

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

  describe "#events" do
    let(:url) { '/events'}
    let(:params) { {:test => 123} }

    it "should call #request with the correct url segment and the params passed" do
      instance.should_receive(:request).with(url, params)
      instance.events(params)
    end
  end

  describe "#handle_response" do
    let(:response) { double(Faraday::Response, :status => status, :body => body)}

    context "when response_format is set to ruby" do
      context "and the request was successful" do
        let(:status) { 200 }
        let(:body) { "{\"meta\":{\"per_page\":1,\"total\":63188,\"page\":1,\"took\":4,\"geolocation\":null},\"events\":[{\"stats\":{\"listing_count\":0,\"average_price\":0,\"lowest_price\":null,\"highest_price\":null},\"relative_url\":\"/palm-beach-cardinals-at-jupiter-hammerheads-tickets/minor-league-baseball/2012-05-14/798459/\",\"title\":\"Palm Beach Cardinals at Jupiter Hammerheads\",\"url\":\"http://seatgeek.com/palm-beach-cardinals-at-jupiter-hammerheads-tickets/minor-league-baseball/2012-05-14/798459/\",\"datetime_local\":\"2012-05-14T10:35:00\",\"performers\":[{\"away_team\":true,\"name\":\"Palm Beach Cardinals\",\"url\":\"http://seatgeek.com/palm-beach-cardinals-tickets/\",\"image\":null,\"short_name\":\"Palm Beach Cardinals\",\"slug\":\"palm-beach-cardinals\",\"score\":0,\"images\":[],\"type\":\"minor_league_baseball\",\"id\":9420},{\"home_team\":true,\"name\":\"Jupiter Hammerheads\",\"url\":\"http://seatgeek.com/jupiter-hammerheads-tickets/\",\"image\":null,\"short_name\":\"Jupiter Hammerheads\",\"primary\":true,\"slug\":\"jupiter-hammerheads\",\"score\":0,\"images\":[],\"type\":\"minor_league_baseball\",\"id\":9421}],\"venue\":{\"city\":\"Jupiter\",\"name\":\"Roger Dean Stadium\",\"url\":\"http://seatgeek.com/roger-dean-stadium-tickets/\",\"country\":\"US\",\"state\":\"FL\",\"score\":16592,\"postal_code\":\"33468\",\"location\":{\"lat\":26.8936,\"lon\":-80.1156},\"extended_address\":null,\"address\":\"4751 Main St\",\"id\":3927},\"short_title\":\"Palm Beach Cardinals at Jupiter Hammerheads\",\"datetime_utc\":\"2012-05-14T14:35:00\",\"score\":0,\"taxonomies\":[{\"parent_id\":null,\"id\":1000000,\"name\":\"sports\"},{\"parent_id\":1000000,\"id\":1010000,\"name\":\"baseball\"},{\"parent_id\":1010000,\"id\":1010300,\"name\":\"minor_league_baseball\"}],\"type\":\"minor_league_baseball\",\"id\":798459}]}" }

        it "should parse the json returned and respond with a ruby object" do
          instance.handle_response(response).should == MultiJson.decode(body)
        end
      end

      context "and the request was not successful" do
        let(:status) { 500 }
        let(:body) { "Internal Server Error" }

        it "should return the status code and exact result body" do
          instance.handle_response(response).should == {:status => status, :body => body}
        end
      end
    end

    context "when response format is not set to ruby" do
      let(:status) { 200 }
      let(:body) { "{\"meta\":{\"per_page\":1,\"total\":63188,\"page\":1,\"took\":4,\"geolocation\":null},\"events\":[{\"stats\":{\"listing_count\":0,\"average_price\":0,\"lowest_price\":null,\"highest_price\":null},\"relative_url\":\"/palm-beach-cardinals-at-jupiter-hammerheads-tickets/minor-league-baseball/2012-05-14/798459/\",\"title\":\"Palm Beach Cardinals at Jupiter Hammerheads\",\"url\":\"http://seatgeek.com/palm-beach-cardinals-at-jupiter-hammerheads-tickets/minor-league-baseball/2012-05-14/798459/\",\"datetime_local\":\"2012-05-14T10:35:00\",\"performers\":[{\"away_team\":true,\"name\":\"Palm Beach Cardinals\",\"url\":\"http://seatgeek.com/palm-beach-cardinals-tickets/\",\"image\":null,\"short_name\":\"Palm Beach Cardinals\",\"slug\":\"palm-beach-cardinals\",\"score\":0,\"images\":[],\"type\":\"minor_league_baseball\",\"id\":9420},{\"home_team\":true,\"name\":\"Jupiter Hammerheads\",\"url\":\"http://seatgeek.com/jupiter-hammerheads-tickets/\",\"image\":null,\"short_name\":\"Jupiter Hammerheads\",\"primary\":true,\"slug\":\"jupiter-hammerheads\",\"score\":0,\"images\":[],\"type\":\"minor_league_baseball\",\"id\":9421}],\"venue\":{\"city\":\"Jupiter\",\"name\":\"Roger Dean Stadium\",\"url\":\"http://seatgeek.com/roger-dean-stadium-tickets/\",\"country\":\"US\",\"state\":\"FL\",\"score\":16592,\"postal_code\":\"33468\",\"location\":{\"lat\":26.8936,\"lon\":-80.1156},\"extended_address\":null,\"address\":\"4751 Main St\",\"id\":3927},\"short_title\":\"Palm Beach Cardinals at Jupiter Hammerheads\",\"datetime_utc\":\"2012-05-14T14:35:00\",\"score\":0,\"taxonomies\":[{\"parent_id\":null,\"id\":1000000,\"name\":\"sports\"},{\"parent_id\":1000000,\"id\":1010000,\"name\":\"baseball\"},{\"parent_id\":1010000,\"id\":1010300,\"name\":\"minor_league_baseball\"}],\"type\":\"minor_league_baseball\",\"id\":798459}]}" }

      it "should return the status code and exact result body" do
        klass.new(:response_format => :json).\
          handle_response(response).should == {:status => status, :body => body}
      end
    end
  end

  describe "#performers" do
    let(:url) { '/performers'}
    let(:params) { {:test => 123} }

    it "should call #request with the correct url segment and the params passed" do
      instance.should_receive(:request).with(url, params)
      instance.performers(params)
    end
  end

  describe "#request" do
    let(:url) { 'http://api.seatgeek.com/2/events' }
    let(:params) { {} }
    let(:faraday) { mock(:faraday, :get => OpenStruct.new({:status => 200, :body => "[]"})) }

    context "when .response_format is jsonp" do
      let(:instance) { klass.new({:response_format => :jsonp}) }
      let(:expected_params) { {:params => params.merge({:format => :jsonp})} }

      it "should set the format param to jsonp" do
        Faraday.should_receive(:new).with(url, expected_params).and_return(faraday)
        instance.request(url, params)
      end
    end

    context "when .response_format is xml" do
      let(:instance) { klass.new({:response_format => :xml}) }
      let(:expected_params) { {:params => params.merge({:format => :xml})} }

      it "should set the format param to xml" do
        Faraday.should_receive(:new).with(url, expected_params).and_return(faraday)
        instance.request(url, params)
      end
    end

    context "when additional parameters were passed to #initialize" do
      let(:instance) { klass.new({:response_format => :jsonp, :testing => 123}) }
      let(:expected_params) { {:params => params.merge({:format => :jsonp, :testing => 123})} }

      it "should add those parameters to the request params" do
        Faraday.should_receive(:new).with(url, expected_params).and_return(faraday)
        instance.request(url, params)
      end
    end
  end

  describe "#taxonomies" do
    let(:url) { '/taxonomies'}
    let(:params) { {:test => 123} }

    it "should call #request with the correct url segment and the params passed" do
      instance.should_receive(:request).with(url, params)
      instance.taxonomies(params)
    end
  end

  describe "#uri" do
    it "should take in a path and combine it with protocol, url and version" do
      instance.uri('/events').should == "http://api.seatgeek.com/2/events"
    end
  end

  describe "#venues" do
    let(:url) { '/venues'}
    let(:params) { {:test => 123} }

    it "should call #request with the correct url segment and the params passed" do
      instance.should_receive(:request).with(url, params)
      instance.venues(params)
    end
  end
end
