require 'logger'
require 'multi_json'
require 'yajl'

MultiJson.engine = :yajl

module SeatGeek
end

require 'seat_geek/connection'

unless Kernel.const_defined?(:SG)
  class SG < SeatGeek::Connection; end
end

require 'seat_geek/version'

require 'faraday/response/verbose_logger'
