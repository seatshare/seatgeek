# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rubygems"
require "bundler/setup"
require 'seatgeek'

Gem::Specification.new do |s|
  s.name        = "seatgeek"
  s.version     = SeatGeek::VERSION
  s.authors     = ["Dan Matthews"]
  s.email       = ["dan@bluefoc.us"]
  s.homepage    = "http://platform.seatgeek.com"
  s.summary     = "A Ruby wrapper for the SeatGeek Platform API."
  s.description = "This gem provides Ruby functionality around the SeatGeek Platform API (http://platform.seatgeek.com). It is designed to be framework agnostic and was originally developed for use in my day job at Ticket Evolution."

  s.rubyforge_project = "seatgeek"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "rake"

  s.add_development_dependency "rspec"
end
