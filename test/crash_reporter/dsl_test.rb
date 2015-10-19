require 'test_helper'
require 'crash_reporter/dsl'

describe CrashReporter::DSL do
  class MyThing
    include CrashReporter::DSL

    def failure_to_communicate
      raise StandardError
    end

    def wrapper
      capture_errors do
        raise StandardError
      end
    end

    def doit_myself
      raise StandardError

    rescue => e
      report_crash e
    end

    capture_errors :failure_to_communicate
  end

  let(:reporter) { Minitest::Mock.new }
  let(:errorer) { MyThing.new }

  before do
    CrashReporter.configure do |c|
      c.engine = reporter
    end
  end

  it "runs error handling hooks automatically" do
    reporter.expect(:run, nil) { 'unimportant' }

    assert_raises(StandardError) do
      errorer.failure_to_communicate
      reporter.verify
    end
  end

  it "can handle errors more explicitly" do
    reporter.expect(:run, nil) { 'unimportant' }

    assert_raises(StandardError) do
      errorer.wrapper
      reporter.verify
    end
  end

  it "can report errors manually" do
    reporter.expect(:run, nil) { 'unimportant' }

    errorer.doit_myself
    reporter.verify
  end
end
