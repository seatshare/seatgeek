require 'spec_helper'

describe SeatGeek::VERSION do
  it "should match a three segment version number format" do
    subject.should =~ /^\d+\.\d+\.\d+(rc\d+)?$/
  end
end
