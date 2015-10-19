require 'test_helper'
require 'crash_reporter/dsl'

describe CrashReporter::DSL do
  class MyThing
    include CrashReporter::DSL

    def failure_to_communicate
      raise StandardError
    end

    capture_errors :failure_to_communicate
  end

  let(:reporter) { Minitest::Mock.new }

  before do
    CrashReporter.configure do |c|
      c.engine = reporter
    end
  end

  it "still raises original error" do
    thing = MyThing.new

    assert_raises(StandardError) do
      thing.failure_to_communicate
    end
  end

  it "runs error handling hooks" do
    thing = MyThing.new
    reporter.expect(:run, nil) { 'unimportant' }

    assert_raises(StandardError) do
      thing.failure_to_communicate
      reporter.verify
    end
  end
end
