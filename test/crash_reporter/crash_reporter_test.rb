require 'test_helper'

describe CrashReporter do
  it "can configure itself" do
    CrashReporter.configure do |c|
      c.tags = "whataburger"
    end

    assert_equal ["whataburger"], CrashReporter.configuration.tags
  end
end
