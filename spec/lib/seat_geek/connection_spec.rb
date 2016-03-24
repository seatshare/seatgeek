require 'spec_helper'
require 'ostruct'

describe SeatGeek::Connection do
  let(:klass) { SeatGeek::Connection }
  let(:instance) { klass.new(client_id: 'foobar') }

  describe '.adapter' do
    subject { klass.adapter }
    let(:default) { :net_http }

    it { should == default }
    it 'should be writable' do
      klass.adapter = :typhoeus
      expect(klass.adapter).to eq(:typhoeus)
    end

    after { klass.adapter = default }
  end

  describe '.events' do
    it 'proxies to #events' do
      expect_any_instance_of(klass).to receive(:events).and_return(nil)
      klass.events
    end

    it 'passes any attributes to #events' do
      expect_any_instance_of(klass).to receive(:events).with(1, 2)
        .and_return(nil)
      klass.events(1, 2)
    end
  end

  describe '.logger' do
    subject { klass.logger }
    let(:default) { nil }
    let(:logger) { Logger.new(STDOUT) }

    it { should == default }
    it 'should be writable' do
      klass.logger = logger
      expect(klass.logger).to eq(logger)
    end

    after { klass.logger = default }
  end

  describe '.options' do
    it 'should return a hash of all of the class level settings' do
      expect(klass.options).to eq(
        adapter: :net_http,
        logger: nil,
        protocol: :https,
        response_format: :ruby,
        url: 'api.seatgeek.com',
        version: 2,
        client_id: nil
      )
    end
  end

  describe '.performers' do
    it 'proxies to #performers' do
      expect_any_instance_of(klass).to receive(:performers).and_return(nil)
      klass.performers
    end

    it 'passes any attributes to #performers' do
      expect_any_instance_of(klass).to receive(:performers).with(1, 2)
        .and_return(nil)
      klass.performers(1, 2)
    end
  end

  describe '.protocol' do
    subject { klass.protocol }
    let(:default) { :https }

    it { should == default }
    it 'should be writable' do
      klass.protocol = :https
      expect(klass.protocol).to eq(:https)
    end

    after { klass.protocol = default }
  end

  describe '.client_id' do
    subject { klass.client_id }
    let(:default) { nil }

    it { should == default }
    it 'should be writable' do
      klass.client_id = 'some_client_id'
      expect(klass.client_id).to eq('some_client_id')
    end

    after { klass.client_id = default }
  end

  describe '.response_format' do
    subject { klass.response_format }
    let(:default) { :ruby }

    it { should == default }
    it 'should be writable' do
      klass.response_format = :jsonp
      expect(klass.response_format).to eq(:jsonp)
    end

    after { klass.response_format = default }
  end

  describe '.taxonomies' do
    it 'proxies to #taxonomies' do
      expect_any_instance_of(klass).to receive(:taxonomies).and_return(nil)
      klass.taxonomies
    end

    it 'passes any attributes to #taxonomies' do
      expect_any_instance_of(klass).to receive(:taxonomies).with(1, 2)
        .and_return(nil)
      klass.taxonomies(1, 2)
    end
  end

  describe '.url' do
    subject { klass.url }
    let(:default) { 'api.seatgeek.com' }

    it { should == default }
    it 'should be writable' do
      klass.url = 'ticketevolution.com'
      expect(klass.url).to eq('ticketevolution.com')
    end

    after { klass.url = default }
  end

  describe '.venues' do
    it 'proxies to #venues' do
      expect_any_instance_of(klass).to receive(:venues).and_return(nil)
      klass.venues
    end

    it 'passes any attributes to #venues' do
      expect_any_instance_of(klass).to receive(:venues).with(1, 2)
        .and_return(nil)
      klass.venues(1, 2)
    end
  end

  describe '.version' do
    subject { klass.version }
    let(:default) { 2 }

    it { should == 2 }
    it 'should be writable' do
      klass.version = 1
      expect(klass.version).to eq(1)
    end

    after { klass.version = default }
  end

  describe '#initialize' do
    let(:expected) { klass.options.merge(options) }
    let(:options) { { testing: 123, clone: 'hello', client_id: 'some_data' } }
    let(:str_options) { {}.tap { |o| options.each { |k, v| o[k.to_s] = v } } }
    let(:instance) { klass.new(options) }

    it 'should take options passed and store '\
      'them on top of the class options hash' do
      expect(instance.instance_eval('@options')).to eq(expected)
    end

    it 'should convert the keys passed to symbols' do
      expect(klass.new(str_options).instance_eval('@options')).to eq(expected)
    end

    it 'should serve options up via read accessor '\
      'methods unless the methods already exist' do
      expect(instance.testing).to eq(options[:testing])
      expect(instance.clone).not_to eq(options[:clone])
    end
  end

  describe '#events' do
    let(:url) { '/events' }
    let(:params) { { test: 123 } }

    it 'should call #request with the correct'\
      'url segment and the params passed' do
      expect(instance).to receive(:request).with(url, params)
      instance.events(params)
    end
  end

  describe '#handle_response' do
    let(:response) { double(Faraday::Response, status: status, body: body) }

    context 'when response_format is set to ruby' do
      context 'and the request was successful' do
        let(:status) { 200 }
        let(:body) { File.read('spec/fixtures/handle_response.json') }

        it 'should parse the json returned and respond with a ruby object' do
          expect(instance.handle_response(response))
            .to eq(MultiJson.decode(body))
        end
      end

      context 'and the request was not successful' do
        let(:status) { 500 }
        let(:body) { 'Internal Server Error' }

        it 'should return the status code and exact result body' do
          expect(instance.handle_response(response))
            .to eq(status: status, body: body)
        end
      end
    end

    context 'when response format is not set to ruby' do
      let(:status) { 200 }
      let(:body) { File.read('spec/fixtures/handle_response.json') }

      it 'should return the status code and exact result body' do
        expect(klass.new(response_format: :json).handle_response(response))
          .to eq(status: status, body: body)
      end
    end
  end

  describe '#performers' do
    let(:url) { '/performers' }
    let(:params) { { test: 123 } }

    it 'should call #request with the correct '\
      'url segment and the params passed' do
      expect(instance).to receive(:request).with(url, params)
      instance.performers(params)
    end
  end

  describe '#request' do
    let(:uri_segment) { '/venues' }
    let(:url) { "https://api.seatgeek.com/2#{uri_segment}" }
    let(:params) { {} }
    let(:faraday) { double(:faraday, get: OpenStruct.new(status: 200, body: '[]')) }

    context 'when .client_id is not set as class property' do
      let(:instance) { klass.new }
      let(:expected_params) { { params: params.merge(format: :jsonp) } }

      it 'should throw an exception' do
        expect { instance.request(uri_segment, params) }
          .to raise_error('You must provide a `client_id` for SeatGeek')
      end

      it 'should not throw an exception if provided in paramters' do
        expect {
          params[:client_id] = 'foobar'
          instance.request(uri_segment, params)
        }.to_not raise_error
      end
    end

    context 'when .response_format is jsonp' do
      let(:instance) { klass.new(response_format: :jsonp, client_id: 'foobar') }
      let(:expected_params) { { params: params.merge(format: :jsonp) } }

      it 'should set the format param to jsonp' do
        expect(Faraday).to receive(:new).with(url, expected_params)
          .and_return(faraday)
        instance.request(uri_segment, params)
      end
    end

    context 'when .response_format is xml' do
      let(:instance) { klass.new(response_format: :xml, client_id: 'foobar') }
      let(:expected_params) { { params: params.merge(format: :xml) } }

      it 'should set the format param to xml' do
        expect(Faraday).to receive(:new).with(url, expected_params)
          .and_return(faraday)
        instance.request(uri_segment, params)
      end
    end

    context 'when additional parameters were passed to #initialize' do
      let(:instance) { klass.new(response_format: :jsonp, testing: 123, client_id: 'foobar') }
      let(:expected_params) { { params: params.merge(format: :jsonp, testing: 123)} }

      it 'should add those parameters to the request params' do
        expect(Faraday).to receive(:new).with(url, expected_params)
          .and_return(faraday)
        instance.request(uri_segment, params)
      end
    end

    context 'when client_id was passed as a parameter' do
      let(:instance) { klass.new }
      let(:params) { { client_id: 'foobar' } }
      let(:expected_params) { { params: params.merge(client_id: 'foobar') } }

      it 'should make the request with the client_id parameter set' do
        expect(Faraday).to receive(:new).with(url, expected_params)
          .and_return(faraday)
        instance.request(uri_segment, params)
      end
    end
  end

  describe '#taxonomies' do
    let(:url) { '/taxonomies' }
    let(:params) { { test: 123 } }

    it 'should call #request with the correct '\
      'url segment and the params passed' do
      expect(instance).to receive(:request).with(url, params)
      instance.taxonomies(params)
    end
  end

  describe '#uri' do
    it 'should take in a path and combine it with protocol, url and version' do
      expect(instance.uri('/events')).to eq('https://api.seatgeek.com/2/events')
    end
  end

  describe '#venues' do
    let(:url) { '/venues' }
    let(:params) { { test: 123 } }

    it 'should call #request with the correct '\
      'url segment and the params passed' do
      expect(instance).to receive(:request).with(url, params)
      instance.venues(params)
    end
  end
end
