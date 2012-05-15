require 'forwardable'

module Faraday
  class Response::VerboseLogger < Response::Middleware
    extend Forwardable

    def initialize(app, logger)
      super(app)
      @logger = logger
    end

    def_delegators :@logger, :debug, :info, :warn, :error, :fatal

    def call(env)
      info "#{env[:method]} #{env[:url].to_s}"
      debug('request headers') { dump_headers env[:request_headers] }
      debug('request body') { env[:body] }
      super
    end

    def on_complete(env)
      info('Status') { env[:status].to_s }
      debug('response headers') { dump_headers env[:response_headers] }
      debug('response body') { env[:body] }
    end

    private

    def dump_headers(headers)
      headers.map { |k, v| "#{k}: #{v.inspect}" }.join("\n")
    end
  end
end
