require 'spec_helper'

describe SG do
  it "should be a subclass of SeatGeek::Connection" do
    expect(SG.ancestors).to include(SeatGeek::Connection)
  end
end
