require 'spec_helper'

describe SG do
  it "should be a subclass of SeatGeek::Connection" do
    SG.ancestors.should include SeatGeek::Connection
  end
end
