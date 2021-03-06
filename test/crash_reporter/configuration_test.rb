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

  it "gets project default name from git" do
    assert_equal "crash-reporter", config.project_name
  end

  it "gets repo url from git" do
    assert_equal "https://github.com/articulate/crash-reporter", config.repo_url
  end

  it "gets repo name from git" do
    assert_equal "crash-reporter", config.repo_name
  end

  it "gets repo path from git" do
    assert_equal "articulate/crash-reporter", config.repo_path
  end

  it 'can configure via a block' do
    config = CrashReporter::Configure.setup do |c|
      c.engine = CustomReporter.new
      c.tags = "ur_mom"
    end

    assert_equal "ur_mom", config.tags.first
    assert_instance_of CustomReporter, config.engines.first
  end

  it 'adds version to tags' do
    config = CrashReporter::Configure.setup do |c|
      c.version = "1.2.3"
    end

    assert_equal ["crash report", '1.2.3'], config.tags
  end
 end
