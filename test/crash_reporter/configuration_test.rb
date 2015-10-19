require 'test_helper'

describe CrashReporter::Configure do
  CustomReporter = Class.new
  DemoReporter = Class.new

  let(:config) { CrashReporter::Configure.new }

  it "can add crash reporters" do
    config.engine = CustomReporter.new
    config.engines << DemoReporter.new

    assert_equal 2, config.engines.count
  end

  it "overrides crash reporters if set via #=" do
    config.engine = CustomReporter.new
    config.engine = DemoReporter.new

    assert_equal 1, config.engines.count
    assert_instance_of DemoReporter, config.engines.first
  end

  it 'can configure via a block' do
    config = CrashReporter::Configure.setup do |c|
      c.engine = CustomReporter.new
      c.default_tag = "ur_mom"
    end

    assert_equal "ur_mom", config.default_tag
    assert_instance_of CustomReporter, config.engines.first
  end
 end
