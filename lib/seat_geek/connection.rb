# frozen_string_literal: true

require 'faraday'

##
# Module: SeatGeek
module SeatGeek
  ##
  # Class: Connection
  class Connection
    class << self; self; end.class_eval do
      def adapter
        @@adapter ||= :net_http
      end

      def adapter=(input)
        @@adapter = input
      end

      def events(*args)
        new.events(*args)
      end

      def logger
        @@logger ||= nil
      end

      def logger=(input)
        @@logger = input
      end

      def options
        {
          adapter: adapter,
          logger: logger,
          protocol: protocol,
          response_format: response_format,
          url: url,
          version: version,
          client_id: client_id
        }
      end

      def performers(*args)
        new.performers(*args)
      end

      def protocol
        @@protocol ||= :https
      end

      def protocol=(input)
        @@protocol = input
      end

      def response_format
        @@response_format ||= :ruby
      end

      def response_format=(input)
        @@response_format = input
      end

      def taxonomies(*args)
        new.taxonomies(*args)
      end

      def url
        @@url ||= 'api.seatgeek.com'
      end

      def url=(input)
        @@url = input
      end

      def venues(*args)
        new.venues(*args)
      end

      def version
        @@version ||= 2
      end

      def version=(input)
        @@version = input
      end

      def client_id
        @@client_id ||= nil
      end

      def client_id=(input)
        @@client_id = input
      end
    end

    def initialize(options = {})
      @options = self.class.options.merge({}.tap do |opts|
        options.each do |k, v|
          opts[k.to_sym] = v
        end
      end)
    end

    def events(params = {})
      request('/events', params)
    end

    def handle_response(response)
      if response_format == :ruby && response.status == 200
        MultiJson.decode(response.body)
      else
        { status: response.status, body: response.body }
      end
    end

    def performers(params = {})
      request('/performers', params)
    end

    def request(url, params)
      raise 'You must provide a `client_id` for SeatGeek' unless client_id || params[:client_id]
      handle_response(Faraday.new(*builder(url, params.clone)) do |build|
        if client_id
          build.use Faraday::Request::BasicAuthentication, client_id, nil
        end
        build.use Faraday::Response::VerboseLogger, logger unless logger.nil?
        build.adapter adapter
      end.get)
    end

    def response_format
      @options[:response_format].to_sym
    end

    def taxonomies(params = {})
      request('/taxonomies', params)
    end

    def uri(path)
      "#{protocol}://#{url}/#{version}#{path}"
    end

    def venues(params = {})
      request('/venues', params)
    end

    private

    def method_missing(method, *params)
      @options.keys.include?(method.to_sym) && params.first.nil? ? @options[method.to_sym] : super
    end

    def builder(uri_segment, params)
      [
        uri([].tap do |part|
          part << uri_segment
          part << "/#{params.delete(:id)}" unless params[:id].nil?
        end.join),
        {
          params: custom_options.merge((
            [:jsonp, :xml].include?(response_format) ? params.merge(format: response_format) : params))
        }
      ]
    end

    def custom_options
      @custom_options ||= {}.tap do |opts|
        ignore = self.class.options.keys
        @options.each do |k, v|
          opts[k] = v unless ignore.include?(k)
        end
      end
    end
  end
end
