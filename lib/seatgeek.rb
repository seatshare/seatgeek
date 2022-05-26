# frozen_string_literal: true

require 'logger'
require 'multi_json'
require 'yajl'

MultiJson.engine = :yajl

##
# Module: SeatGeek
module SeatGeek
end

require 'seat_geek/connection'

unless Kernel.const_defined?(:SG)
  class SG < SeatGeek::Connection; end
end

require 'seat_geek/version'

require 'faraday/response/verbose_logger'
