require 'test_helper'
require 'crash_reporter/reporters/github_issues'

describe CrashReporter::GithubIssues do
  let(:reporter) { CrashReporter::GithubIssues.new("dummy/reporter", "faketoken123") }

  before do
    CrashReporter.configure do |c|
      c.project_name = "Testing things"
      c.default_tag = "yo dawg"
    end
  end

  it "posts an issue to the github API" do
    request = stub_request(:post, 'https://api.github.com/repos/dummy/reporter/issues')
                  .with(
                      headers: {'Authorization' => "token faketoken123"},
                      body: { labels: ['yo dawg'], title: 'Crash report from Testing things', body: 'hello world' }
                  ).to_return(body: "a github response", status: 201)


    reporter.run('hello world')
    assert_requested(request)
  end
end
