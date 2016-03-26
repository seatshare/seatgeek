require 'spec_helper'

describe SeatGeek::VERSION do
  it 'should match a three segment version number format' do
    expect(subject).to match(/^\d+\.\d+\.\d+(rc\d+)?$/)
  end
end
