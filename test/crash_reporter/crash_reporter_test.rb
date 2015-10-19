require 'test_helper'

describe CrashReporter do
  it "can configure itself" do
    CrashReporter.configure do |c|
      c.default_tag = "whataburger"
    end

    assert_equal "whataburger", CrashReporter.configuration.default_tag
  end
end
