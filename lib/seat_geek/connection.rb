module SeatGeek
  class Connection
    class << self; self; end.class_eval do
      def adapter; @@adapter ||= :net_http; end
      def adapter=(input); @@adapter = input; end

      def events(*args); new.events(*args); end

      def options
        {
          :adapter => adapter,
          :protocol => protocol,
          :response_format => response_format,
          :url => url,
          :version => version
        }
      end

      def performers(*args); new.performers(*args); end

      def protocol; @@protocol ||= :http; end
      def protocol=(input); @@protocol = input; end

      def response_format; @@response_format ||= :ruby; end
      def response_format=(input); @@response_format = input; end

      def taxonomies(*args); new.taxonomies(*args); end

      def url; @@url ||= "api.seatgeek.com"; end
      def url=(input); @@url = input; end

      def venues(*args); new.venues(*args); end

      def version; @@version ||= 2; end
      def version=(input); @@version = input; end
    end

    def initialize(options = {})
      @options = self.class.options.merge({}.tap do |opts|
        options.each do |k, v|
          opts[k.to_sym] = v
        end
      end)
    end

    def events(args = {})

    end

    def performers(args = {})

    end

    def taxonomies(args = {})

    end

    def venues(args = {})

    end

    private

    def method_missing(method, *args)
      @options.keys.include?(method.to_sym) && args.first.nil? ? @options[method.to_sym] : super
    end
  end
end
